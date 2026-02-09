import 'package:emi_calculator/core/shared_components/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/shared_cubit/list_visibility_cubit.dart';
import '../../../core/shared_cubit/pre_payment_visibility.dart';
import '../../bloc/home_bloc/emi/emi_bloc.dart';
import '../../bloc/home_bloc/emi/emi_event.dart';
import '../../bloc/home_bloc/interest/interest_bloc.dart';
import '../../bloc/home_bloc/interest/interest_event.dart';
import '../../bloc/home_bloc/loan_amount/loan_amount_bloc.dart';
import '../../bloc/home_bloc/loan_amount/loan_amount_event.dart';
import '../../bloc/home_bloc/period/period_bloc.dart';
import '../../bloc/home_bloc/period/period_event.dart';
import '../../screens/ui/detailed_calculation_screen.dart';

class HomeTabs {
  TextEditingController loanAmountController = TextEditingController();
  TextEditingController interestController = TextEditingController();
  TextEditingController monthDurationController = TextEditingController();
  TextEditingController yearsDurationController = TextEditingController();
  TextEditingController emiController = TextEditingController();

  TextEditingController prePaymentController = TextEditingController();
  String? selectedPrePaymentFrequency;

  Widget emiTab(BuildContext context, int index) {
    var prePaymentVisibility = context.read<PrePaymentVisibility>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          textField(context, 'Loan Amount', loanAmountController),
          const SizedBox(
            height: 10,
          ),
          textField(context, 'Annual Interest', interestController),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: textField(context, 'Years', yearsDurationController),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: textField(context, 'Months', monthDurationController),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              prePaymentVisibility.toggleVisibility();
            },
            child: BlocBuilder<PrePaymentVisibility, bool>(
              builder: (context, isVisible) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      isVisible ? Icons.arrow_drop_up : Icons.add,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    Text(
                      isVisible ? 'pre-payment' : 'add pre-payment',
                      style: Theme.of(context).textTheme.bodyMedium,
                      selectionColor: Theme.of(context).colorScheme.onSurface,
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          BlocBuilder<PrePaymentVisibility, bool>(
            builder: (emit, isVisible) {
              return Visibility(
                visible: isVisible,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: textField(context, 'Pre-payment(optional)', prePaymentController),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surfaceContainer,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          value: selectedPrePaymentFrequency,
                          hint: const Text("Frequency"),
                          items: const [
                            DropdownMenuItem(value: null, child: Text("None")),
                            DropdownMenuItem(value: "one_time", child: Text("One-time")),
                            DropdownMenuItem(value: "monthly", child: Text("Monthly")),
                            DropdownMenuItem(value: "yearly", child: Text("Yearly")),
                          ],
                          onChanged: (value) {
                            selectedPrePaymentFrequency = value;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final preAmt = prePaymentController.text.trim();
                final preFreq = selectedPrePaymentFrequency;

                context.read<EmiBloc>().add(
                      CalculateEmi(
                        loanAmountController.text,
                        interestController.text,
                        monthDurationController.text,
                        yearsDurationController.text,
                        prePaymentAmount: preAmt.isNotEmpty ? preAmt : null,
                        prePaymentFrequency: preFreq,
                      ),
                    );
                if (loanAmountController.text.isEmpty && interestController.text.isEmpty && yearsDurationController.text.isEmpty && monthDurationController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all the details')),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(value: context.read<EmiBloc>()),
                          BlocProvider.value(value: context.read<LoanAmountBloc>()),
                          BlocProvider.value(value: context.read<InterestBloc>()),
                          BlocProvider.value(value: context.read<PeriodBloc>()),
                          BlocProvider.value(value: context.read<ListVisibilityCubit>()),
                          BlocProvider.value(value: context.read<PrePaymentVisibility>()),
                        ],
                        child: DetailedCalculation(tab: index),
                      ),
                    ),
                  );
                }
              },
              child: Text(
                'Calculate',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loanAmountTab(BuildContext context, int index) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          textField(context, 'EMI', emiController),
          const SizedBox(
            height: 10,
          ),
          textField(context, 'Annual Interest', interestController),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: textField(context, 'Years', yearsDurationController),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: textField(context, 'Months', monthDurationController),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Pre-payment is not supported by this tab',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final preAmt = prePaymentController.text.trim();
                final preFreq = selectedPrePaymentFrequency;

                context.read<LoanAmountBloc>().add(
                      CalculateLoanAmount(
                        emiController.text,
                        interestController.text,
                        monthDurationController.text,
                        yearsDurationController.text,
                        prePaymentAmount: preAmt.isNotEmpty ? preAmt : null,
                        prePaymentFrequency: preFreq,
                      ),
                    );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: context.read<EmiBloc>()),
                        BlocProvider.value(value: context.read<LoanAmountBloc>()),
                        BlocProvider.value(value: context.read<InterestBloc>()),
                        BlocProvider.value(value: context.read<PeriodBloc>()),
                        BlocProvider.value(value: context.read<ListVisibilityCubit>()),
                      ],
                      child: DetailedCalculation(tab: index),
                    ),
                  ),
                );
              },
              child: Text(
                'Calculate',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget interestTab(BuildContext context, int index) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          textField(context, 'Loan Amount', loanAmountController),
          const SizedBox(
            height: 10,
          ),
          textField(context, 'EMI', emiController),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: textField(context, 'Years', yearsDurationController),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: textField(context, 'Months', monthDurationController),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Pre-payment is not supported by this tab',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final preAmt = prePaymentController.text.trim();
                final preFreq = selectedPrePaymentFrequency;

                context.read<InterestBloc>().add(
                      CalculateInterest(
                        loanAmountController.text,
                        monthDurationController.text,
                        yearsDurationController.text,
                        emiController.text,
                        prePaymentAmount: preAmt.isNotEmpty ? preAmt : null,
                        prePaymentFrequency: preFreq,
                      ),
                    );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: context.read<EmiBloc>()),
                        BlocProvider.value(value: context.read<LoanAmountBloc>()),
                        BlocProvider.value(value: context.read<InterestBloc>()),
                        BlocProvider.value(value: context.read<PeriodBloc>()),
                        BlocProvider.value(value: context.read<ListVisibilityCubit>()),
                      ],
                      child: DetailedCalculation(tab: index),
                    ),
                  ),
                );
              },
              child: Text(
                'Calculate',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget periodTab(BuildContext context, int index) {
    var prePaymentVisibility = context.read<PrePaymentVisibility>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          textField(context, 'Loan Amount', loanAmountController),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: textField(context, 'Annual Interest', interestController),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: textField(context, 'EMI', emiController),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              prePaymentVisibility.toggleVisibility();
            },
            child: BlocBuilder<PrePaymentVisibility, bool>(
              builder: (context, isVisible) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      isVisible ? Icons.arrow_drop_up : Icons.add,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    Text(
                      isVisible ? 'pre-payment' : 'add pre-payment',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          BlocBuilder<PrePaymentVisibility, bool>(
            builder: (emit, isVisible) {
              return Visibility(
                visible: isVisible,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: textField(context, 'Pre-payment(optional)', prePaymentController),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surfaceContainer,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          value: selectedPrePaymentFrequency,
                          hint: const Text("Frequency"),
                          items: const [
                            DropdownMenuItem(value: null, child: Text("None")),
                            DropdownMenuItem(value: "one_time", child: Text("One-time")),
                            DropdownMenuItem(value: "monthly", child: Text("Monthly")),
                            DropdownMenuItem(value: "yearly", child: Text("Yearly")),
                          ],
                          onChanged: (value) {
                            selectedPrePaymentFrequency = value;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final preAmt = prePaymentController.text.trim();
                final preFreq = selectedPrePaymentFrequency;

                context.read<PeriodBloc>().add(
                      CalculatePeriod(
                        interestController.text,
                        loanAmountController.text,
                        emiController.text,
                        prePaymentAmount: preAmt.isNotEmpty ? preAmt : null,
                        prePaymentFrequency: preFreq,
                      ),
                    );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: context.read<EmiBloc>()),
                        BlocProvider.value(value: context.read<LoanAmountBloc>()),
                        BlocProvider.value(value: context.read<InterestBloc>()),
                        BlocProvider.value(value: context.read<PeriodBloc>()),
                        BlocProvider.value(value: context.read<ListVisibilityCubit>()),
                        BlocProvider.value(value: context.read<PrePaymentVisibility>()),
                      ],
                      child: DetailedCalculation(tab: index),
                    ),
                  ),
                );
              },
              child: Text(
                'Calculate',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
