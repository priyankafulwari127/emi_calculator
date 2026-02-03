import 'dart:math';

import 'package:emi_calculator/bloc_state_management/event/period_event.dart';
import 'package:emi_calculator/bloc_state_management/state/period_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/amortization_table_model.dart';

class PeriodBloc extends Bloc<PeriodEvent, PeriodState> {
  PeriodBloc() : super(PeriodInitial()) {
    on<CalculatePeriod>((event, emit) {
      final principal = double.tryParse(event.loanAmount) ?? 0.0;
      final emi = double.tryParse(event.emi) ?? 0.0;
      final annualRate = double.tryParse(event.interest) ?? 0.0;

      // We simulate until loan is paid off
      final amortization = _calculateAmortizationWithPrepayments(
        principal: principal,
        annualRate: annualRate,
        totalMonths: 360, // max reasonable — will break early
        emi: emi,
        prepayAmountStr: event.prePaymentAmount,
        prepayFreq: event.prePaymentFrequency,
      );

      final actualMonths = amortization.length;
      final periodInYears = actualMonths / 12.0;

      double totalInterest = 0;
      double totalPrincipal = 0;
      for (var row in amortization) {
        totalInterest += row.interest;
        totalPrincipal += row.principleAmount;
      }
      final totalPaid = totalPrincipal + totalInterest;

      emit(CalculatedPeriod(
        period: periodInYears,
        principleAmount: principal,
        totalInterest: totalInterest,
        totalAmountPaid: totalPaid,
        amortizationTable: amortization,
      ));
    });
  }

  double _calculatePeriod(String interest, String loanAmount, String emi) {
    //formula for period calculation is log(EMI / (EMI - (P * R))) / log(1 + R)
    double interestInDouble = double.tryParse(interest) ?? 0.0;
    double loanAmountInDouble = double.tryParse(loanAmount) ?? 0.0;
    double emiInDouble = double.tryParse(emi) ?? 0.0;

    // R (interest in months)(currently in year)
    var monthlyInterest = (interestInDouble / 12) / 100;
    //(EMI - (P * R))
    var emiMinusAmountAndRate = emiInDouble - (loanAmountInDouble * monthlyInterest);
    // log(1 + R)
    var divider = log(1 + monthlyInterest);
    // log(EMI / (EMI - (P * R)))
    var dividend = log(emiInDouble / emiMinusAmountAndRate);
    var period = dividend / divider;
    var periodInYears = period / 12;
    return periodInYears;
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
