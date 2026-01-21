abstract class EmiState {}

class EmiInitial extends EmiState {}

class CalculatedEmi extends EmiState {
  final double emi;
  final double principleAmount;
  final double totalInterest;
  final double totalAmountPaid;

  CalculatedEmi(
    this.emi,
    this.principleAmount,
    this.totalInterest,
    this.totalAmountPaid,
  );
}
