import '../../../../domain/model/amortization_table_model.dart';

abstract class PeriodState {}

class PeriodInitial extends PeriodState {}

class CalculatedPeriod extends PeriodState {
  final double period;
  final double principleAmount;
  final double totalInterest;
  final double totalAmountPaid;

  final List<AmortizationTableModel> amortizationTable;

  CalculatedPeriod({
    required this.period,
    required this.principleAmount,
    required this.totalInterest,
    required this.totalAmountPaid,
    required this.amortizationTable,
  });
}
