abstract class EmiState{}

class EmiInitial extends EmiState{}

class CalculatedEmi extends EmiState{
  final double emi;

  CalculatedEmi(this.emi);
}