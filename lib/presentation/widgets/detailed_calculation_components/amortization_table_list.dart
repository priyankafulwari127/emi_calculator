import 'package:emi_calculator/presentation/widgets/detailed_calculation_components/amortization_table_list_values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/home_bloc/emi/emi_bloc.dart';
import '../../bloc/home_bloc/emi/emi_state.dart';
import '../../bloc/home_bloc/interest/interest_bloc.dart';
import '../../bloc/home_bloc/interest/interest_state.dart';
import '../../bloc/home_bloc/loan_amount/loan_amount_bloc.dart';
import '../../bloc/home_bloc/loan_amount/loan_amount_state.dart';
import '../../bloc/home_bloc/period/period_bloc.dart';
import '../../bloc/home_bloc/period/period_state.dart';

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
                              amortizationTableListValues('${state.amortizationTable[index].period.round()}'),
                              amortizationTableListValues('${state.amortizationTable[index].principleAmount.round()}'),
                              amortizationTableListValues('${state.amortizationTable[index].interest.round()}'),
                              amortizationTableListValues('${state.amortizationTable[index].emi.round()}'),
                              amortizationTableListValues('${state.amortizationTable[index].balance.round()}'),
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
                              amortizationTableListValues('${state.amortizationTable[index].period.round()}'),
                              amortizationTableListValues('${state.amortizationTable[index].principleAmount.round()}'),
                              amortizationTableListValues('${state.amortizationTable[index].interest.round()}'),
                              amortizationTableListValues('${state.amortizationTable[index].emi.round()}'),
                              amortizationTableListValues('${state.amortizationTable[index].balance.round()}'),
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
                              amortizationTableListValues('${state.amortizationTable[index].period.round()}'),
                              amortizationTableListValues('${state.amortizationTable[index].principleAmount.round()}'),
                              amortizationTableListValues('${state.amortizationTable[index].interest.round()}'),
                              amortizationTableListValues('${state.amortizationTable[index].emi.round()}'),
                              amortizationTableListValues('${state.amortizationTable[index].balance.round()}'),
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
                              amortizationTableListValues('${state.amortizationTable[index].period.round()}'),
                              amortizationTableListValues('${state.amortizationTable[index].principleAmount.round()}'),
                              amortizationTableListValues('${state.amortizationTable[index].interest.round()}'),
                              amortizationTableListValues('${state.amortizationTable[index].emi.round()}'),
                              amortizationTableListValues('${state.amortizationTable[index].balance.round()}'),
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
