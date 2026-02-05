import '../../../../domain/model/amortization_table_model.dart';

abstract class LoanAmountState {}

class LoanAmountInitial extends LoanAmountState {}

class CalculatedLoanAmount extends LoanAmountState {
  final double amount;
  final double totalInterest;
  final double totalAmountPaid;

  final List<AmortizationTableModel> amortizationTable;

  CalculatedLoanAmount({
    required this.amount,
    required this.totalInterest,
    required this.totalAmountPaid,
    required this.amortizationTable,
  });
}
