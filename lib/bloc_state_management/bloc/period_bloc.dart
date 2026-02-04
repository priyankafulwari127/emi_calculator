import 'dart:math';

import 'package:emi_calculator/bloc_state_management/event/period_event.dart';
import 'package:emi_calculator/bloc_state_management/state/period_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../service/amortization_table_logic.dart';

class PeriodBloc extends Bloc<PeriodEvent, PeriodState> {
  PeriodBloc() : super(PeriodInitial()) {
    on<CalculatePeriod>(
      (event, emit) {
        final principal = double.tryParse(event.loanAmount) ?? 0.0;
        final emi = double.tryParse(event.emi) ?? 0.0;
        final annualRate = double.tryParse(event.interest) ?? 0.0;

        final result = AmortizationService.calculate(
          principal: principal,
          annualRate: annualRate,
          emi: emi,
          maxMonths: 600,
          monthlyPrepayment: double.tryParse(event.prePaymentAmount ?? ""),
        );

        emit(
          CalculatedPeriod(
            period: result.months / 12,
            principleAmount: principal,
            totalInterest: result.totalInterest,
            totalAmountPaid: result.totalPaid,
            amortizationTable: result.table,
          ),
        );
      },
    );
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
