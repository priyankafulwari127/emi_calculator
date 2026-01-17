abstract class LoanAmountState{}

class LoanAmountInitial extends LoanAmountState{}

class CalculatedLoanAmount extends LoanAmountState{
  final double amount;
  CalculatedLoanAmount(this.amount);
}