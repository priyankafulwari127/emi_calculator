abstract class PeriodEvent{}

class CalculatePeriod extends PeriodEvent{
  final String interest;
  final String loanAmount;
  final String emi;
  final String? prePaymentAmount;
  final String? prePaymentFrequency;

  CalculatePeriod(this.interest, this.loanAmount, this.emi, {this.prePaymentAmount, this.prePaymentFrequency});
}