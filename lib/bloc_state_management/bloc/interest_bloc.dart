import 'dart:math';

import 'package:emi_calculator/bloc_state_management/event/interest_event.dart';
import 'package:emi_calculator/bloc_state_management/state/interest_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InterestBloc extends Bloc<InterestEvent, InterestState>{
  InterestBloc() : super(InterestInitial()){
    on<CalculateInterest>((event, emit){
      final interest = _calculateInterest(
        event.loanAmount,
        event.tenureInMonths,
        event.tenureInYears,
        event.emi,
      );

      emit(CalculatedInterest(interest));
    });
  }

  double _calculateInterest(String loanAmount, String tenureInMonths, String tenureInYears, String emi){
    double emiInDouble = double.tryParse(emi) ?? 0.0;
    double monthsTenureInDouble = double.tryParse(tenureInMonths) ?? 0.0;
    double yearsTenureInDouble = double.tryParse(tenureInYears) ?? 0.0;
    double loanAmountInDouble = double.tryParse(loanAmount) ?? 0.0;

    // multiply emi with tenure (in months)
    var durationInMonths = (yearsTenureInDouble * 12) + monthsTenureInDouble;

    double low = 0.0;
    double high = 1.0;
    double mid = 0.0;

    for(int i=0; i<100; i++){
      mid = (low + high) / 2;
      double monthlyRate = mid / 12;

      var calculatedEmi = loanAmountInDouble * monthlyRate * (pow(1 + monthlyRate, durationInMonths)) /
          (pow(1 + monthlyRate, durationInMonths) - 1);

      if(calculatedEmi > emiInDouble){
        high = mid;
      }else{
        low = mid;
      }
    }
    return mid * 100;
  }
}