import 'dart:math';

import 'package:emi_calculator/bloc_state_management/event/interest_event.dart';
import 'package:emi_calculator/bloc_state_management/state/interest_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/amortization_table_model.dart';

class InterestBloc extends Bloc<InterestEvent, InterestState> {
  InterestBloc() : super(InterestInitial()) {
    on<CalculateInterest>(
      (event, emit) {
        final principal = double.tryParse(event.loanAmount) ?? 0.0;
        final emiInDouble = double.tryParse(event.emi) ?? 0.0;

        final interestRatePercent = _calculateInterest(
          event.loanAmount,
          event.tenureInMonths,
          event.tenureInYears,
          event.emi,
        );
        final totalMonths = _getTotalMonths(event.tenureInYears, event.tenureInMonths);
        final amortization = _buildAmortization(
          principal: principal,
          annualRate: interestRatePercent,
          totalMonths: totalMonths,
          emi: emiInDouble,
        );

        double totalInterest = 0;
        double totalPaid = 0;

        for (final row in amortization) {
          totalInterest += row.interest;
          totalPaid += row.emi;
        }

        emit(
          CalculatedInterest(
            inter: interestRatePercent,
            principleAmount: principal,
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

  int _getTotalMonths(String yearsStr, String monthsStr) {
    double years = double.tryParse(yearsStr) ?? 0.0;
    double months = double.tryParse(monthsStr) ?? 0.0;
    return (years * 12 + months).round();
  }

  List<AmortizationTableModel> _buildAmortization({
    required double principal,
    required double annualRate,
    required int totalMonths,
    required double emi,
  }) {
    final table = <AmortizationTableModel>[];
    final monthlyRate = annualRate / 12 / 100;

    double balance = principal;

    for (int month = 1; month <= totalMonths && balance > 0; month++) {
      final interest = balance * monthlyRate;
      double principalPaid = emi - interest;

      if (principalPaid > balance) {
        principalPaid = balance;
      }

      balance -= principalPaid;

      table.add(
        AmortizationTableModel(
          period: month.toDouble(),
          emi: interest + principalPaid,
          interest: interest,
          principleAmount: principalPaid,
          balance: balance,
        ),
      );
    }

    return table;
  }
}
