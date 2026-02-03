import 'dart:math';

import 'package:emi_calculator/bloc_state_management/event/interest_event.dart';
import 'package:emi_calculator/bloc_state_management/state/interest_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/amortization_table_model.dart';

class InterestBloc extends Bloc<InterestEvent, InterestState> {
  InterestBloc() : super(InterestInitial()) {
    on<CalculateInterest>((event, emit) {
      final interestRatePercent = _calculateInterest(
        event.loanAmount,
        event.tenureInMonths,
        event.tenureInYears,
        event.emi,
      );

      final principal = double.tryParse(event.loanAmount) ?? 0.0;
      final emiValue = double.tryParse(event.emi) ?? 0.0;

      final totalMonths = _getTotalMonths(event.tenureInYears, event.tenureInMonths);

      final amortization = _calculateAmortizationWithPrepayments(
        principal: principal,
        annualRate: interestRatePercent,
        totalMonths: totalMonths,
        emi: emiValue,
        prepayAmountStr: event.prePaymentAmount,
        prepayFreq: event.prePaymentFrequency,
      );

      double totalInterest = 0;
      double totalPrincipalPaid = 0;
      for (var row in amortization) {
        totalInterest += row.interest;
        totalPrincipalPaid += row.principleAmount;
      }
      final totalPaid = totalPrincipalPaid + totalInterest;

      emit(CalculatedInterest(
        inter: interestRatePercent,
        principleAmount: principal,
        totalInterest: totalInterest,
        totalAmountPaid: totalPaid,
        amortizationTable: amortization,
      ));
    });
  }

  double _calculateInterest(String loanAmount, String tenureInMonths, String tenureInYears, String emi) {
    double emiInDouble = double.tryParse(emi) ?? 0.0;
    double monthsTenureInDouble = double.tryParse(tenureInMonths) ?? 0.0;
    double yearsTenureInDouble = double.tryParse(tenureInYears) ?? 0.0;
    double loanAmountInDouble = double.tryParse(loanAmount) ?? 0.0;

    // multiply emi with tenure (in months)
    var durationInMonths = (yearsTenureInDouble * 12) + monthsTenureInDouble;

    double low = 0.0;
    double high = 1.0;
    double mid = 0.0;

    for (int i = 0; i < 100; i++) {
      mid = (low + high) / 2;
      double monthlyRate = mid / 12;

      var calculatedEmi = loanAmountInDouble * monthlyRate * (pow(1 + monthlyRate, durationInMonths)) / (pow(1 + monthlyRate, durationInMonths) - 1);

      if (calculatedEmi > emiInDouble) {
        high = mid;
      } else {
        low = mid;
      }
    }
    return mid * 100;
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
