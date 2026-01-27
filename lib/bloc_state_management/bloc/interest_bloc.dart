import 'dart:math';

import 'package:emi_calculator/bloc_state_management/event/interest_event.dart';
import 'package:emi_calculator/bloc_state_management/state/interest_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/amortization_table_model.dart';

class InterestBloc extends Bloc<InterestEvent, InterestState> {
  InterestBloc() : super(InterestInitial()) {
    on<CalculateInterest>(
      (event, emit) {
        final interest = _calculateInterest(
          event.loanAmount,
          event.tenureInMonths,
          event.tenureInYears,
          event.emi,
        );
        final principleAmount = _calculatePrincipleAmount(event.loanAmount);
        final totalPaid = _calculateTotalAmountPaid(
          event.loanAmount,
          event.emi,
          interest,
          event.tenureInYears,
          event.tenureInMonths,
        );
        final totalInterest = _calculateTotalInterest(
          event.loanAmount,
          totalPaid,
          interest,
          event.tenureInYears,
          event.tenureInMonths,
        );
        final amortization = _calculateDetailMonthToMonthCalculations(
          event.loanAmount,
          interest,
          event.tenureInMonths,
          event.tenureInYears,
          event.emi,
        );

        emit(
          CalculatedInterest(
            inter: interest,
            principleAmount: principleAmount,
            totalInterest: totalInterest,
            totalAmountPaid: totalPaid,
            amortizationTable: amortization,
          ),
        );
      },
    );
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

  double _calculateTotalAmountPaid(String loanAmount, String emi, double interest, String tenureInYears, String tenureInMonths) {
    double monthlyTenureInDouble = double.tryParse(tenureInMonths) ?? 0.0;
    double yearlyTenureInDouble = double.tryParse(tenureInYears) ?? 0.0;
    var emiInDouble = double.tryParse(emi) ?? 0.0;

    //converting tenure to months
    var monthlyTenure = (yearlyTenureInDouble * 12) + monthlyTenureInDouble;

    var totalAmountPaid = emiInDouble * monthlyTenure;
    return totalAmountPaid;
  }

  double _calculateTotalInterest(String loanAmount, double totalPaid, double interest, String tenureInYears, String tenureInMonths) {
    double loanAmountInDouble = double.tryParse(loanAmount) ?? 0.0;

    var totalInterest = totalPaid - loanAmountInDouble;
    return totalInterest;
  }

  double _calculatePrincipleAmount(String loanAmount) {
    return double.tryParse(loanAmount) ?? 0.0;
  }

  List<AmortizationTableModel> _calculateDetailMonthToMonthCalculations(String loanAmount, double interest, String tenureInMonths, String tenureInYears, String emi) {
    double loanAmountInDouble = double.tryParse(loanAmount) ?? 0.0;
    double monthDurationInDouble = double.tryParse(tenureInMonths) ?? 0.0;
    double yearlyDurationInDouble = double.tryParse(tenureInYears) ?? 0.0;
    double emiInDouble = double.tryParse(emi) ?? 0.0;

    var monthlyInterestInDouble = (interest / 12) / 100;
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
