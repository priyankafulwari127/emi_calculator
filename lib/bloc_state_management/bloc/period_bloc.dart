import 'dart:math';

import 'package:emi_calculator/bloc_state_management/event/period_event.dart';
import 'package:emi_calculator/bloc_state_management/state/period_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/amortization_table_model.dart';

class PeriodBloc extends Bloc<PeriodEvent, PeriodState> {
  PeriodBloc() : super(PeriodInitial()) {
    on<CalculatePeriod>((event, emit) {
      final periodInYears = _calculatePeriod(
        event.interest,
        event.loanAmount,
        event.emi,
      );
      final periodInMonths = periodInYears * 12;

      final principleAmount = _calculatePrincipleAmount(
        event.loanAmount,
      );
      final totalPaid = _calculateTotalAmountPaid(
        event.loanAmount,
        event.emi,
        event.interest,
        periodInYears,
        periodInMonths,
      );
      final totalInterest = _calculateTotalInterest(
        event.loanAmount,
        totalPaid,
      );
      final amortizationTable = _calculateDetailMonthToMonthCalculations(
        event.loanAmount,
        event.interest,
        periodInMonths,
        periodInYears,
        event.emi,
      );

      emit(
        CalculatedPeriod(
          period: periodInYears,
          principleAmount: principleAmount,
          totalInterest: totalInterest,
          totalAmountPaid: totalPaid,
          amortizationTable: amortizationTable,
        ),
      );
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

  double _calculateTotalAmountPaid(String loanAmount, String emi, String interest, double tenureInYears, double tenureInMonths) {
    double monthlyTenureInDouble = double.tryParse(tenureInMonths.toString()) ?? 0.0;
    double yearlyTenureInDouble = double.tryParse(tenureInYears.toString()) ?? 0.0;
    double emiInDouble = double.tryParse(emi) ?? 0.0;

    //converting tenure to months
    var monthlyTenure = (yearlyTenureInDouble * 12) + monthlyTenureInDouble;

    var totalAmountPaid = emiInDouble * monthlyTenure;
    return totalAmountPaid;
  }

  double _calculateTotalInterest(String loanAmount, double totalPaid) {
    double loanAmountInDouble = double.tryParse(loanAmount) ?? 0.0;

    var totalInterest = totalPaid - loanAmountInDouble;
    return totalInterest;
  }

  double _calculatePrincipleAmount(String loanAmount) {
    return double.tryParse(loanAmount) ?? 0.0;
  }

  List<AmortizationTableModel> _calculateDetailMonthToMonthCalculations(String loanAmount, String interest, double tenureInMonths, double tenureInYears, String emi) {
    double loanAmountInDouble = double.tryParse(loanAmount) ?? 0.0;
    double interestInDouble = double.tryParse(interest) ?? 0.0;
    double emiInDouble = double.tryParse(emi) ?? 0.0;
    double monthDurationInDouble = double.tryParse(tenureInMonths.toString()) ?? 0.0;
    double yearlyDurationInDouble = double.tryParse(tenureInYears.toString()) ?? 0.0;

    var monthlyInterestInDouble = (interestInDouble / 12) / 100;
    var durationInMonths = (yearlyDurationInDouble * 12) + monthDurationInDouble;
    var currentBalance = loanAmountInDouble;

    List<AmortizationTableModel> table = [];

    for (double i = 1; i <= durationInMonths; i++) {
      var inter = currentBalance * monthlyInterestInDouble;
      var principlePaid = emiInDouble - inter;
      currentBalance -= principlePaid;

      if (currentBalance < 0) currentBalance = 0;

      if (i == durationInMonths) {
        currentBalance = 0;
      }

      table.add(
        AmortizationTableModel(
          emi: emiInDouble,
          principleAmount: principlePaid,
          interest: inter,
          period: i,
          balance: currentBalance,
        ),
      );
    }
    return table;
  }
}
