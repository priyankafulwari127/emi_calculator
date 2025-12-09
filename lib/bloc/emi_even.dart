abstract class EmiEvent{}

class CalculateEmi extends EmiEvent{
  final String loanAmount;
  final String interest;
  final String tenure;

  CalculateEmi(this.loanAmount, this.interest, this.tenure);
}