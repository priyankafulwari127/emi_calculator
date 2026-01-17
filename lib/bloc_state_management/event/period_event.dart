abstract class PeriodEvent{}

class CalculatePeriod extends PeriodEvent{
  final String interest;
  final String loanAmount;
  final String emi;

  CalculatePeriod(this.interest, this.loanAmount, this.emi);
}