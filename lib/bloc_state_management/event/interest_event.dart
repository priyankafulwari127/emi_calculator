abstract class InterestEvent {}

class CalculateInterest extends InterestEvent {
  final String loanAmount;
  final String tenureInMonths;
  final String tenureInYears;
  final String emi;

  CalculateInterest(this.loanAmount, this.tenureInMonths, this.tenureInYears, this.emi);
}
