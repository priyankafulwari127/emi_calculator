import 'dart:math';

import 'package:emi_calculator/bloc/emi_even.dart';
import 'package:emi_calculator/bloc/emi_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmiBloc extends Bloc<EmiEvent, EmiState> {
  EmiBloc() : super(EmiInitial()) {
    on<CalculateEmi>((event, emit) {
      final emi = _calculateEmi(
        event.loanAmount,
        event.interest,
        event.tenure,
      );

      emit(CalculatedEmi(emi));
    });
  }

  double _calculateEmi(String loanAmount, String interest, String tenure) {
    double interestInDouble = double.tryParse(interest) ?? 0.0;
    double durationInDouble = double.tryParse(tenure) ?? 0.0;
    double loanAmountInDouble = double.tryParse(loanAmount) ?? 0.0;

    //converting duration from years to months
    var durationInMonths = durationInDouble * 12;

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
}
