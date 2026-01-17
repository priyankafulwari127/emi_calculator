abstract class LoanAmountEvent{}

class CalculateLoanAmount extends LoanAmountEvent{
  final String emi;
  final String interest;
  final String tenureInMonths;
  final String tenureInYears;

  CalculateLoanAmount(this.emi, this.interest, this.tenureInMonths, this.tenureInYears);
}