abstract class LoanAmountEvent{}

class CalculateLoanAmount extends LoanAmountEvent{
  final String emi;
  final String interest;
  final String tenureInMonths;
  final String tenureInYears;
  final String? prePaymentAmount;       // ← new
  final String? prePaymentFrequency;

  CalculateLoanAmount(this.emi, this.interest, this.tenureInMonths, this.tenureInYears, {this.prePaymentAmount, this.prePaymentFrequency});
}