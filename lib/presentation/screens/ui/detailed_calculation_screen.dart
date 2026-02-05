import 'package:emi_calculator/presentation/widgets/detailed_calculation_components/amortization_table_header.dart';
import 'package:emi_calculator/presentation/widgets/detailed_calculation_components/amortization_table_list.dart';
import 'package:emi_calculator/presentation/widgets/detailed_calculation_components/core_totals_calculation_row.dart';
import 'package:emi_calculator/presentation/widgets/detailed_calculation_components/tab_calculation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/shared_cubit/list_visibility_cubit.dart';
import '../../bloc/home_bloc/emi/emi_bloc.dart';
import '../../bloc/home_bloc/emi/emi_state.dart';
import '../../bloc/home_bloc/interest/interest_bloc.dart';
import '../../bloc/home_bloc/interest/interest_state.dart';
import '../../bloc/home_bloc/loan_amount/loan_amount_bloc.dart';
import '../../bloc/home_bloc/loan_amount/loan_amount_state.dart';
import '../../bloc/home_bloc/period/period_bloc.dart';
import '../../bloc/home_bloc/period/period_state.dart';

class DetailedCalculation extends StatelessWidget {
  final int tab;

  const DetailedCalculation({super.key, required this.tab});

  @override
  Widget build(BuildContext context) {
    final listVisibility = context.read<ListVisibilityCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.purple[400],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            calculationSwitch(),
            const SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                listVisibility.toggleVisibility();
              },
              child: BlocBuilder<ListVisibilityCubit, bool>(
                builder: (context, isVisible) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isVisible ? 'Hide Details' : 'View Details',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        isVisible ? Icons.arrow_drop_down_rounded : Icons.arrow_drop_up_rounded,
                        size: 22,
                        color: Colors.black,
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: BlocBuilder<ListVisibilityCubit, bool>(
                builder: (emit, isVisible) {
                  return Visibility(
                    visible: isVisible,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                amortizationTableHeaderComponent('Months'),
                                amortizationTableHeaderComponent('Principle Paid'),
                                amortizationTableHeaderComponent('EMI'),
                                amortizationTableHeaderComponent('Interest'),
                                amortizationTableHeaderComponent('Balance'),
                              ],
                            ),
                            const Divider(
                              indent: 5,
                              endIndent: 5,
                            ),
                            //amortization table values
                            AmortizationTableList(tab: tab)
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget calculationSwitch() {
    switch (tab) {
      case 0:
        return SingleChildScrollView(
          child: Column(
            children: [
              TabCalculationWidget<EmiBloc, EmiState>(
                title: 'EMI',
                valueProvider: (state) {
                  if (state is CalculatedEmi) {
                    return 'Rs. ${state.emi.round()}';
                  }
                  return 'Rs. 0.0';
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CoreTotalsCalculationRow<EmiBloc, EmiState>(
                        label: 'Principle Amount',
                        valueProvider: (state) {
                          if (state is CalculatedEmi) {
                            return 'Rs. ${state.principleAmount.round()}';
                          }
                          return 'Rs. 0.0';
                        },
                      ),
                      const Divider(
                        indent: 2,
                        endIndent: 2,
                      ),
                      CoreTotalsCalculationRow<EmiBloc, EmiState>(
                        label: 'Total Interest',
                        valueProvider: (state) {
                          if (state is CalculatedEmi) {
                            return 'Rs. ${state.totalInterest.round()}';
                          }
                          return 'Rs. 0.0';
                        },
                      ),
                      const Divider(
                        indent: 2,
                        endIndent: 2,
                      ),
                      CoreTotalsCalculationRow<EmiBloc, EmiState>(
                        label: 'Total Amount Paid',
                        valueProvider: (state) {
                          if (state is CalculatedEmi) {
                            return 'Rs. ${state.totalAmountPaid.round()}';
                          }
                          return 'Rs. 0.0';
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      case 1:
        return SingleChildScrollView(
          child: Column(
            children: [
              TabCalculationWidget<LoanAmountBloc, LoanAmountState>(
                title: 'Loan Amount',
                valueProvider: (state) {
                  if (state is CalculatedLoanAmount) {
                    return 'Rs. ${state.amount.toStringAsFixed(2)}';
                  }
                  return 'Rs. 0.0';
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CoreTotalsCalculationRow<LoanAmountBloc, LoanAmountState>(
                        label: 'Principle Amount',
                        valueProvider: (state) {
                          if (state is CalculatedLoanAmount) {
                            return 'Rs. ${state.amount.round()}';
                          }
                          return 'Rs. 0.0';
                        },
                      ),
                      const Divider(
                        indent: 2,
                        endIndent: 2,
                      ),
                      CoreTotalsCalculationRow<LoanAmountBloc, LoanAmountState>(
                        label: 'Total Interest',
                        valueProvider: (state) {
                          if (state is CalculatedLoanAmount) {
                            return 'Rs. ${state.totalInterest.round()}';
                          }
                          return 'Rs. 0.0';
                        },
                      ),
                      const Divider(
                        indent: 2,
                        endIndent: 2,
                      ),
                      CoreTotalsCalculationRow<LoanAmountBloc, LoanAmountState>(
                        label: 'Total Amount Paid',
                        valueProvider: (state) {
                          if (state is CalculatedLoanAmount) {
                            return 'Rs. ${state.totalAmountPaid.round()}';
                          }
                          return 'Rs. 0.0';
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      case 2:
        return SingleChildScrollView(
          child: Column(
            children: [
              TabCalculationWidget<InterestBloc, InterestState>(
                title: 'Annual Interest',
                valueProvider: (state) {
                  if (state is CalculatedInterest) {
                    return '${state.inter.toStringAsFixed(2)}%';
                  }
                  return 'Rs. 0.00%';
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CoreTotalsCalculationRow<InterestBloc, InterestState>(
                        label: 'Principle Amount',
                        valueProvider: (state) {
                          if (state is CalculatedInterest) {
                            return 'Rs. ${state.principleAmount.round()}';
                          }
                          return 'Rs. 0.0';
                        },
                      ),
                      const Divider(
                        indent: 2,
                        endIndent: 2,
                      ),
                      CoreTotalsCalculationRow<InterestBloc, InterestState>(
                        label: 'Total Interest',
                        valueProvider: (state) {
                          if (state is CalculatedInterest) {
                            return 'Rs. ${state.totalInterest.round()}';
                          }
                          return 'Rs. 0.0';
                        },
                      ),
                      const Divider(
                        indent: 2,
                        endIndent: 2,
                      ),
                      CoreTotalsCalculationRow<InterestBloc, InterestState>(
                        label: 'Total Amount Paid',
                        valueProvider: (state) {
                          if (state is CalculatedInterest) {
                            return 'Rs. ${state.totalAmountPaid.round()}';
                          }
                          return 'Rs. 0.0';
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      case 3:
        return SingleChildScrollView(
          child: Column(
            children: [
              TabCalculationWidget<PeriodBloc, PeriodState>(
                title: 'Loan Period',
                valueProvider: (state) {
                  if (state is CalculatedPeriod) {
                    return '${state.period.toStringAsFixed(2)} years';
                  }
                  return '0.00 years';
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CoreTotalsCalculationRow<PeriodBloc, PeriodState>(
                        label: 'Principle Amount',
                        valueProvider: (state) {
                          if (state is CalculatedPeriod) {
                            return 'Rs. ${state.principleAmount.round()}';
                          }
                          return 'Rs. 0.0';
                        },
                      ),
                      const Divider(
                        indent: 2,
                        endIndent: 2,
                      ),
                      CoreTotalsCalculationRow<PeriodBloc, PeriodState>(
                        label: 'Total Interest',
                        valueProvider: (state) {
                          if (state is CalculatedPeriod) {
                            return 'Rs. ${state.totalInterest.round()}';
                          }
                          return 'Rs. 0.0';
                        },
                      ),
                      const Divider(
                        indent: 2,
                        endIndent: 2,
                      ),
                      CoreTotalsCalculationRow<PeriodBloc, PeriodState>(
                        label: 'Total Amount Paid',
                        valueProvider: (state) {
                          if (state is CalculatedPeriod) {
                            return 'Rs. ${state.totalAmountPaid.round()}';
                          }
                          return 'Rs. 0.0';
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      default:
        return const Text(
          'No Data Found',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        );
    }
  }
}
