import 'dart:math';

import 'package:emi_calculator/bloc_state_management/event/period_event.dart';
import 'package:emi_calculator/bloc_state_management/state/period_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PeriodBloc extends Bloc<PeriodEvent, PeriodState> {
  PeriodBloc() : super(PeriodInitial()) {
    on<CalculatePeriod>((event, emit) {
      final per = _calculatePeriod(
          event.interest,
          event.loanAmount,
          event.emi
      );

      emit(CalculatedPeriod(per));
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
}