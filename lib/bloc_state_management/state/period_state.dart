abstract class PeriodState{}

class PeriodInitial extends PeriodState{}

class CalculatedPeriod extends PeriodState{
  final double period;
  CalculatedPeriod(this.period);
}