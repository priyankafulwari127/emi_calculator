abstract class EmiEvent {}

class CalculateEmi extends EmiEvent {
  final String loanAmount;
  final String interest;
  final String tenureInYears;
  final String tenureInMonths;
  final String? prePaymentAmount;       // ← new
  final String? prePaymentFrequency;

  CalculateEmi(
    this.loanAmount,
    this.interest,
    this.tenureInMonths,
    this.tenureInYears, {this.prePaymentAmount, this.prePaymentFrequency}
  );
}
