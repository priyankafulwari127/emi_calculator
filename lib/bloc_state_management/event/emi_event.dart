abstract class EmiEvent {}

class CalculateEmi extends EmiEvent {
  final String loanAmount;
  final String interest;
  final String tenureInYears;
  final String tenureInMonths;

  CalculateEmi(
    this.loanAmount,
    this.interest,
    this.tenureInMonths,
    this.tenureInYears,
  );
}
