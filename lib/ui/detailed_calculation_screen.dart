import 'package:emi_calculator/bloc_state_management/bloc/interest_bloc.dart';
import 'package:emi_calculator/bloc_state_management/bloc/loan_amount_bloc.dart';
import 'package:emi_calculator/bloc_state_management/bloc/period_bloc.dart';
import 'package:emi_calculator/bloc_state_management/state/interest_state.dart';
import 'package:emi_calculator/bloc_state_management/state/loan_amount_state.dart';
import 'package:emi_calculator/bloc_state_management/state/period_state.dart';
import 'package:emi_calculator/components/calculation_details_row.dart';
import 'package:emi_calculator/components/calculation_header.dart';
import 'package:flutter/material.dart';

import '../bloc_state_management/bloc/emi_bloc.dart';
import '../bloc_state_management/state/emi_state.dart';

class DetailedCalculation extends StatelessWidget {
  final int tab;

  const DetailedCalculation({super.key, required this.tab});

  @override
  Widget build(BuildContext context) {
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
      body: calculationSwitch(),
    );
  }

  Widget calculationSwitch() {
    switch (tab) {
      case 0:
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CalculationHeader<EmiBloc, EmiState>(
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
                      CalculationDetailsRow<EmiBloc, EmiState>(
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
                      CalculationDetailsRow<EmiBloc, EmiState>(
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
                      CalculationDetailsRow<EmiBloc, EmiState>(
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
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CalculationHeader<LoanAmountBloc, LoanAmountState>(
                title: 'Loan Amount',
                valueProvider: (state) {
                  if (state is CalculatedLoanAmount) {
                    return 'Rs. ${state.amount.round()}';
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
                      CalculationDetailsRow<EmiBloc, EmiState>(
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
                      CalculationDetailsRow<EmiBloc, EmiState>(
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
                      CalculationDetailsRow<EmiBloc, EmiState>(
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
      case 2:
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CalculationHeader<InterestBloc, InterestState>(
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
                      CalculationDetailsRow<EmiBloc, EmiState>(
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
                      CalculationDetailsRow<EmiBloc, EmiState>(
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
                      CalculationDetailsRow<EmiBloc, EmiState>(
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
      case 3:
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CalculationHeader<PeriodBloc, PeriodState>(
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
                      CalculationDetailsRow<EmiBloc, EmiState>(
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
                      CalculationDetailsRow<EmiBloc, EmiState>(
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
                      CalculationDetailsRow<EmiBloc, EmiState>(
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
