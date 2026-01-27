import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/amortization_table_model.dart';
import '../event/loan_amount_event.dart';
import '../state/loan_amount_state.dart';

class LoanAmountBloc extends Bloc<LoanAmountEvent, LoanAmountState> {
  LoanAmountBloc() : super(LoanAmountInitial()) {
    on<CalculateLoanAmount>(
      (event, emit) {
        final amount = _calculateLoanAmount(
          event.emi,
          event.interest,
          event.tenureInMonths,
          event.tenureInYears,
        );
        final totalPaid = _calculateTotalAmountPaid(
          amount,
          event.emi,
          event.interest,
          event.tenureInYears,
          event.tenureInYears,
        );
        final totalInterest = _calculateTotalInterest(
          amount,
          totalPaid,
          event.interest,
          event.tenureInYears,
          event.tenureInMonths,
        );
        final amortization = _calculateDetailMonthToMonthCalculations(
          amount,
          event.interest,
          event.tenureInMonths,
          event.tenureInYears,
          event.emi,
        );
        emit(
          CalculatedLoanAmount(
            amount: amount,
            totalInterest: totalInterest,
            totalAmountPaid: totalPaid,
            amortizationTable: amortization,
          ),
        );
      },
    );
  }
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

double _calculateTotalAmountPaid(double loanAmount, String emi, String interest, String tenureInYears, String tenureInMonths) {
  double monthlyTenureInDouble = double.tryParse(tenureInMonths) ?? 0.0;
  double yearlyTenureInDouble = double.tryParse(tenureInYears) ?? 0.0;
  double emiInDouble = double.tryParse(emi) ?? 0.0;

  //converting tenure to months
  var monthlyTenure = (yearlyTenureInDouble * 12) + monthlyTenureInDouble;

  var totalAmountPaid = emiInDouble * monthlyTenure;
  return totalAmountPaid;
}

double _calculateTotalInterest(double loanAmount, double totalPaid, String interest, String tenureInYears, String tenureInMonths) {
  var totalInterest = totalPaid - loanAmount;
  return totalInterest;
}

List<AmortizationTableModel> _calculateDetailMonthToMonthCalculations(double loanAmount, String interest, String tenureInMonths, String tenureInYears, String emi) {
  double interestInDouble = double.tryParse(interest) ?? 0.0;
  double monthDurationInDouble = double.tryParse(tenureInMonths) ?? 0.0;
  double yearlyDurationInDouble = double.tryParse(tenureInYears) ?? 0.0;
  double emiInDouble = double.tryParse(emi) ?? 0.0;

  var monthlyInterestInDouble = (interestInDouble / 12) / 100;
  var durationInMonths = (yearlyDurationInDouble * 12) + monthDurationInDouble;
  var currentBalance = loanAmount;

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
