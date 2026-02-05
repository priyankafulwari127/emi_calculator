abstract class InterestEvent {}

class CalculateInterest extends InterestEvent {
  final String loanAmount;
  final String tenureInMonths;
  final String tenureInYears;
  final String emi;
  final String? prePaymentAmount;       // ← new
  final String? prePaymentFrequency;

  CalculateInterest(this.loanAmount, this.tenureInMonths, this.tenureInYears, this.emi, {this.prePaymentAmount, this.prePaymentFrequency});
}
