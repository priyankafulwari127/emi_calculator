import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/model/amortization_table_model.dart';
import 'loan_amount_event.dart';
import 'loan_amount_state.dart';

class LoanAmountBloc extends Bloc<LoanAmountEvent, LoanAmountState> {
  LoanAmountBloc() : super(LoanAmountInitial()) {
    on<CalculateLoanAmount>((event, emit) {
      var emiInDouble = double.tryParse(event.emi) ?? 0.0;
      var interestInDouble = double.tryParse(event.interest) ?? 0.0;

      final amount = _calculateLoanAmount(
        event.emi,
        event.interest,
        event.tenureInMonths,
        event.tenureInYears,
      );

      final totalMonths = _getTotalMonths(event.tenureInYears, event.tenureInMonths);

      final amortization = _buildAmortization(
        principal: amount,
        annualRate: interestInDouble,
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
        CalculatedLoanAmount(
          amount: amount,
          totalInterest: totalInterest,
          totalAmountPaid: totalPaid,
          amortizationTable: amortization,
        ),
      );
    });
  }

  double _calculateLoanAmount(String emi, String interest, String tenureInMonths, String tenureInYears) {
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
