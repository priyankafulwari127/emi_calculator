import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/loan_amount_event.dart';
import '../state/loan_amount_state.dart';

class LoanAmountBloc extends Bloc<LoanAmountEvent, LoanAmountState>{
  LoanAmountBloc() : super(LoanAmountInitial()){
    on<CalculateLoanAmount>((event, emit){
      final amount = _calculateLoanAmount(
        event.emi,
        event.interest,
        event.tenureInMonths,
        event.tenureInYears,
      );

      emit(CalculatedLoanAmount(amount));
    });
  }
}

double _calculateLoanAmount(String emi, String interest, String tenureInMonths, String tenureInYears){
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
