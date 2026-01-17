abstract class InterestState{}

class InterestInitial extends InterestState{}

class CalculatedInterest extends InterestState{
  final double inter;
  CalculatedInterest(this.inter);
}