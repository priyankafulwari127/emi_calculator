import 'dart:math';
import 'package:emi_calculator/model/amortization_table_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../service/amortization_table_logic.dart';
import '../event/emi_event.dart';
import '../state/emi_state.dart';

class EmiBloc extends Bloc<EmiEvent, EmiState> {
  EmiBloc() : super(EmiInitial()) {
    on<CalculateEmi>(
      (event, emit) {
        final emi = _calculateEmi(
          event.loanAmount,
          event.interest,
          event.tenureInMonths,
          event.tenureInYears,
        );
        final principal = double.tryParse(event.loanAmount) ?? 0;
        final interestRate = double.tryParse(event.interest) ?? 0;

        final totalMonths = _getTotalMonths(event.tenureInYears, event.tenureInMonths);

        final result = AmortizationService.calculate(
          principal: principal,
          annualRate: interestRate,
          emi: emi,
          maxMonths: totalMonths,
          monthlyPrepayment: double.tryParse(event.prePaymentAmount ?? ""),
        );

        emit(
          CalculatedEmi(
            emi,
            principal,
            result.totalInterest,
            result.totalPaid,
            result.table,
          ),
        );
      },
    );
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
}
