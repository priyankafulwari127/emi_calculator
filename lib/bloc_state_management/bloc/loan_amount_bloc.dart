import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/amortization_table_model.dart';
import '../event/loan_amount_event.dart';
import '../state/loan_amount_state.dart';

class LoanAmountBloc extends Bloc<LoanAmountEvent, LoanAmountState> {
  LoanAmountBloc() : super(LoanAmountInitial()) {
    on<CalculateLoanAmount>((event, emit) {
      final amount = _calculateLoanAmount(
        event.emi,
        event.interest,
        event.tenureInMonths,
        event.tenureInYears,
      );

      final totalMonths = _getTotalMonths(event.tenureInYears, event.tenureInMonths);

      final amortization = _calculateAmortizationWithPrepayments(
        principal: amount,
        annualRate: double.tryParse(event.interest) ?? 0.0,
        totalMonths: totalMonths,
        emi: double.tryParse(event.emi) ?? 0.0,
        prepayAmountStr: event.prePaymentAmount,
        prepayFreq: event.prePaymentFrequency,
      );

      double totalInterest = 0;
      double totalPrincipal = 0;
      for (var row in amortization) {
        totalInterest += row.interest;
        totalPrincipal += row.principleAmount;
      }
      final totalPaid = totalPrincipal + totalInterest;

      emit(CalculatedLoanAmount(
        amount: amount,
        totalInterest: totalInterest,
        totalAmountPaid: totalPaid,
        amortizationTable: amortization,
      ));
    });
  }

  double _calculateLoanAmount(String emi, String interest, String tenureInMonths, String tenureInYears) {
    // formula for loan amount calculation is EMI * ((1 + R)^n - 1) / (R * (1 + R)^n)
    double emiInDouble = double.tryParse(emi) ?? 0.0;
    double interestInDouble = double.tryParse(interest) ?? 0.0;
    double monthsTenureInDouble = double.tryParse(tenureInMonths) ?? 0.0;
    double yearsTenureInDouble = double.tryParse(tenureInYears) ?? 0.0;

    //tenure in months
    var durationsInMonths = (yearsTenureInDouble * 12) + monthsTenureInDouble;

    // R (this is monthly interest rate)
    var monthlyInterest = (interestInDouble / 12) / 100;
    // (1 + R)^n
    var interestWithTenure = pow(1 + monthlyInterest, durationsInMonths);
    //(R * (1 + R)^n)
    var divider = monthlyInterest * interestWithTenure;

    //final amount calculation
    var amount = emiInDouble * (interestWithTenure - 1) / divider;
    return amount;
  }

  int _getTotalMonths(String yearsStr, String monthsStr) {
    double years = double.tryParse(yearsStr) ?? 0.0;
    double months = double.tryParse(monthsStr) ?? 0.0;
    return (years * 12 + months).round();
  }

  List<AmortizationTableModel> _calculateAmortizationWithPrepayments({
    required double principal,
    required double annualRate,
    required int totalMonths,
    required double emi,
    String? prepayAmountStr,
    String? prepayFreq,
  }) {
    List<AmortizationTableModel> table = [];
    double balance = principal;
    final monthlyRate = annualRate / 12 / 100;

    double? prepayAmount = prepayAmountStr != null && prepayAmountStr
        .trim()
        .isNotEmpty
        ? double.tryParse(prepayAmountStr.trim())
        : null;

    bool hasPrepay = prepayAmount != null && prepayAmount > 0 && prepayFreq != null;

    for (int month = 1; month <= totalMonths; month++) {
      double extraPrincipal = 0;

      if (hasPrepay) {
        if (prepayFreq == "monthly") {
          extraPrincipal = prepayAmount!;
        } else if (prepayFreq == "yearly" && month % 12 == 1) {
          extraPrincipal = prepayAmount!;
        } else if (prepayFreq == "one_time" && month == 1) {
          extraPrincipal = prepayAmount!;
        }
      }

      balance -= extraPrincipal;
      if (balance < 0) balance = 0;

      double interestThisMonth = balance * monthlyRate;

      double principalThisMonth = emi - interestThisMonth;
      if (principalThisMonth > balance) {
        principalThisMonth = balance;
      }

      balance -= principalThisMonth;
      if (balance < 0) balance = 0;

      double totalPrincipalThisMonth = principalThisMonth + extraPrincipal;

      table.add(AmortizationTableModel(
        emi: emi,
        principleAmount: totalPrincipalThisMonth,
        interest: interestThisMonth,
        period: month.toDouble(),
        balance: balance,
      ));

      if (balance <= 0.01) break;
    }

    return table;
  }
}
