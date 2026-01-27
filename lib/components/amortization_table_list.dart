import 'package:emi_calculator/bloc_state_management/bloc/emi_bloc.dart';
import 'package:emi_calculator/bloc_state_management/bloc/interest_bloc.dart';
import 'package:emi_calculator/bloc_state_management/bloc/loan_amount_bloc.dart';
import 'package:emi_calculator/bloc_state_management/bloc/period_bloc.dart';
import 'package:emi_calculator/bloc_state_management/state/emi_state.dart';
import 'package:emi_calculator/bloc_state_management/state/interest_state.dart';
import 'package:emi_calculator/bloc_state_management/state/loan_amount_state.dart';
import 'package:emi_calculator/bloc_state_management/state/period_state.dart';
import 'package:emi_calculator/components/amortization_values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AmortizationTableList<B extends BlocBase<S>, S> extends StatelessWidget {
  final int tab;

  const AmortizationTableList({super.key, required this.tab});

  @override
  Widget build(BuildContext context) {
    return amortizationTableSwitch();
  }

  Widget amortizationTableSwitch() {
    switch (tab) {
      case 0:
        return Expanded(
          child: BlocBuilder<EmiBloc, EmiState>(
            builder: (context, state) {
              if (state is CalculatedEmi) {
                return ListView.builder(
                  itemCount: state.amortizationTable.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              amortizationValues('${state.amortizationTable[index].period.round()}'),
                              amortizationValues('${state.amortizationTable[index].principleAmount.round()}'),
                              amortizationValues('${state.amortizationTable[index].emi.round()}'),
                              amortizationValues('${state.amortizationTable[index].interest.round()}'),
                              amortizationValues('${state.amortizationTable[index].balance.round()}'),
                            ],
                          ),
                        ),
                        const Divider()
                      ],
                    );
                  },
                );
              }
              return const Text('No Calculation Found');
            },
          ),
        );
      case 1:
        return Expanded(
          child: BlocBuilder<LoanAmountBloc, LoanAmountState>(
            builder: (context, state) {
              if (state is CalculatedLoanAmount) {
                return ListView.builder(
                  itemCount: state.amortizationTable.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              amortizationValues('${state.amortizationTable[index].period.round()}'),
                              amortizationValues('${state.amortizationTable[index].principleAmount.round()}'),
                              amortizationValues('${state.amortizationTable[index].emi.round()}'),
                              amortizationValues('${state.amortizationTable[index].interest.round()}'),
                              amortizationValues('${state.amortizationTable[index].balance.round()}'),
                            ],
                          ),
                        ),
                        const Divider()
                      ],
                    );
                  },
                );
              }
              return const Text('No Calculation Found');
            },
          ),
        );
      case 2:
        return Expanded(
          child: BlocBuilder<InterestBloc, InterestState>(
            builder: (context, state) {
              if (state is CalculatedInterest) {
                return ListView.builder(
                  itemCount: state.amortizationTable.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              amortizationValues('${state.amortizationTable[index].period.round()}'),
                              amortizationValues('${state.amortizationTable[index].principleAmount.round()}'),
                              amortizationValues('${state.amortizationTable[index].emi.round()}'),
                              amortizationValues('${state.amortizationTable[index].interest.round()}'),
                              amortizationValues('${state.amortizationTable[index].balance.round()}'),
                            ],
                          ),
                        ),
                        const Divider()
                      ],
                    );
                  },
                );
              }
              return const Text('No Calculation Found');
            },
          ),
        );
      case 3:
        return Expanded(
          child: BlocBuilder<PeriodBloc, PeriodState>(
            builder: (context, state) {
              if (state is CalculatedPeriod) {
                return ListView.builder(
                  itemCount: state.amortizationTable.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              amortizationValues('${state.amortizationTable[index].period.round()}'),
                              amortizationValues('${state.amortizationTable[index].principleAmount.round()}'),
                              amortizationValues('${state.amortizationTable[index].emi.round()}'),
                              amortizationValues('${state.amortizationTable[index].interest.round()}'),
                              amortizationValues('${state.amortizationTable[index].balance.round()}'),
                            ],
                          ),
                        ),
                        const Divider()
                      ],
                    );
                  },
                );
              }
              return const Text('No Calculation Found');
            },
          ),
        );
      default:
        return const Text("no calculation found");
    }
  }
}
