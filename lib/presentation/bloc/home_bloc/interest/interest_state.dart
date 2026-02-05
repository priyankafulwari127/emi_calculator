import '../../../../domain/model/amortization_table_model.dart';

abstract class InterestState {}

class InterestInitial extends InterestState {}

class CalculatedInterest extends InterestState {
  final double inter;
  final double principleAmount;
  final double totalInterest;
  final double totalAmountPaid;

  final List<AmortizationTableModel> amortizationTable;

  CalculatedInterest({
    required this.inter,
    required this.principleAmount,
    required this.totalInterest,
    required this.totalAmountPaid,
    required this.amortizationTable,
  });
}
