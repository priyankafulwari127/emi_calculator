import 'dart:math';
import 'package:emi_calculator/model/amortization_table_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/emi_event.dart';
import '../state/emi_state.dart';

class EmiBloc extends Bloc<EmiEvent, EmiState> {
  EmiBloc() : super(EmiInitial()) {
    on<CalculateEmi>((event, emit) {
      final emi = _calculateEmi(
        event.loanAmount,
        event.interest,
        event.tenureInMonths,
        event.tenureInYears,
      );

      final totalMonths = _getTotalMonths(event.tenureInYears, event.tenureInMonths);

      final amortization = _calculateAmortizationWithPrepayments(
        principal: double.tryParse(event.loanAmount) ?? 0.0,
        annualRate: double.tryParse(event.interest) ?? 0.0,
        totalMonths: totalMonths,
        emi: emi,
        prepayAmountStr: event.prePaymentAmount,
        prepayFreq: event.prePaymentFrequency,
      );

      double totalInterest = 0;
      double totalPrincipalPaid = 0;
      for (var row in amortization) {
        totalInterest += row.interest;
        totalPrincipalPaid += row.principleAmount;
      }
      final totalAmountPaid = totalPrincipalPaid + totalInterest;

      emit(CalculatedEmi(
        emi,
        double.tryParse(event.loanAmount) ?? 0.0,
        totalInterest,
        totalAmountPaid,
        amortization,
      ));
    });
  }

  double _calculateEmi(String loanAmount, String interest, String tenureInMonths, String tenureInYears) {
    double interestInDouble = double.tryParse(interest) ?? 0.0;
    double monthDurationInDouble = double.tryParse(tenureInMonths) ?? 0.0;
    double yearlyDurationInDouble = double.tryParse(tenureInYears) ?? 0.0;
    double loanAmountInDouble = double.tryParse(loanAmount) ?? 0.0;

    //converting duration from years to months
    var durationInMonths = (yearlyDurationInDouble * 12) + monthDurationInDouble;
    // Formula for EMI calculation is P * R * ( 1 + R)^n / ((1 + R)^n - 1)
    // P = Principal Amount
    // R = Rate of Interest
    // n = duration for loan repayment or tenure

    // R = (rate of interest annually/12/100)
    var monthlyInterestFromAnnualInterest = (interestInDouble / 12) / 100;

    if (monthlyInterestFromAnnualInterest == 0) {
      return loanAmountInDouble / durationInMonths;
    }

    // (1 + R)
    var interestWithPlusOne = 1 + monthlyInterestFromAnnualInterest;
    // (1 + R)^n
    var interestWithTenure = pow(interestWithPlusOne, durationInMonths);
    //((1 + R)^n - 1)
    var divider = interestWithTenure - 1;
    //EMI value per month
    var emi = loanAmountInDouble * monthlyInterestFromAnnualInterest * interestWithTenure / divider;
    return emi;
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

    double? prepayAmount = prepayAmountStr != null && prepayAmountStr.trim().isNotEmpty
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