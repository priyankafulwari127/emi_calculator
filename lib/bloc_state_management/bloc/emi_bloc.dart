import 'dart:math';
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
      final totalAmountPaid = _calculateTotalAmountPaid(
        event.loanAmount,
        emi,
        event.interest,
        event.tenureInYears,
        event.tenureInMonths,
      );
      final totalInterest = _calculateTotalInterest(
        event.loanAmount,
        totalAmountPaid,
        event.interest,
        event.tenureInYears,
        event.tenureInMonths,
      );
      final principleAmount = _calculatePrincipleAmount(
        event.loanAmount,
        event.interest,
        event.tenureInMonths,
        event.tenureInYears,
        emi,
      );
      emit(CalculatedEmi(
        emi,
        principleAmount,
        totalInterest,
        totalAmountPaid,
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

  double _calculateTotalAmountPaid(String loanAmount, double emi, String interest, String tenureInYears, String tenureInMonths) {
    double monthlyTenureInDouble = double.tryParse(tenureInMonths) ?? 0.0;
    double yearlyTenureInDouble = double.tryParse(tenureInYears) ?? 0.0;

    //converting tenure to months
    var monthlyTenure = (yearlyTenureInDouble * 12) + monthlyTenureInDouble;

    var totalAmountPaid = emi * monthlyTenure;
    return totalAmountPaid;
  }

  double _calculateTotalInterest(String loanAmount, double totalPaid, String interest, String tenureInYears, String tenureInMonths) {
    double loanAmountInDouble = double.tryParse(loanAmount) ?? 0.0;

    var totalInterest = totalPaid - loanAmountInDouble;
    return totalInterest;
  }

  double _calculatePrincipleAmount(String loanAmount, String interest, String tenureInMonths, String tenureInYears, double emi) {
    double interestInDouble = double.tryParse(interest) ?? 0.0;
    double monthDurationInDouble = double.tryParse(tenureInMonths) ?? 0.0;
    double yearlyDurationInDouble = double.tryParse(tenureInYears) ?? 0.0;

    //converting duration from years to months
    var durationInMonths = (yearlyDurationInDouble * 12) + monthDurationInDouble;
    // R = (rate of interest annually/12/100)
    var monthlyInterest = (interestInDouble / 12) / 100;

    //(1 + monthlyInterest)^durationInMonths
    var interestWithTenure = pow(1 + monthlyInterest, durationInMonths);

    var upper = emi * (interestWithTenure - 1);
    var denominator = monthlyInterest * interestWithTenure;
    var principleAmount = upper / denominator;
    return principleAmount;
  }
}
