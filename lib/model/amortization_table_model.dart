class AmortizationTableModel {
  final double emi;
  final double principleAmount;
  final double interest;
  final double period;
  final double balance;

  AmortizationTableModel({
    required this.emi,
    required this.principleAmount,
    required this.interest,
    required this.period,
    required this.balance,
  });
}
