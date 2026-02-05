
import '../../../../domain/model/amortization_table_model.dart';

abstract class EmiState {}

class EmiInitial extends EmiState {}

class CalculatedEmi extends EmiState {
  final double emi;
  final double principleAmount;
  final double totalInterest;
  final double totalAmountPaid;

  final List<AmortizationTableModel> amortizationTable;

  CalculatedEmi(
    this.emi,
    this.principleAmount,
    this.totalInterest,
    this.totalAmountPaid,

    this.amortizationTable,
  );
}
