import 'package:emi_calculator/components/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc_state_management/bloc/emi_bloc.dart';
import '../bloc_state_management/bloc/interest_bloc.dart';
import '../bloc_state_management/bloc/loan_amount_bloc.dart';
import '../bloc_state_management/bloc/period_bloc.dart';
import '../bloc_state_management/calculation_list_cubit/list_visibility_cubit.dart';
import '../bloc_state_management/event/emi_event.dart';
import '../bloc_state_management/event/interest_event.dart';
import '../bloc_state_management/event/loan_amount_event.dart';
import '../bloc_state_management/event/period_event.dart';
import '../ui/detailed_calculation_screen.dart';

class HomeTabs {
  TextEditingController loanAmountController = TextEditingController();
  TextEditingController interestController = TextEditingController();
  TextEditingController monthDurationController = TextEditingController();
  TextEditingController yearsDurationController = TextEditingController();
  TextEditingController emiController = TextEditingController();

  Widget emiTab(BuildContext context, int index) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          textField('Loan Amount', loanAmountController),
          const SizedBox(
            height: 10,
          ),
          textField('Annual Interest', interestController),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: textField('Years', yearsDurationController),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: textField('Months', monthDurationController),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                context.read<EmiBloc>().add(
                      CalculateEmi(
                        loanAmountController.text,
                        interestController.text,
                        monthDurationController.text,
                        yearsDurationController.text,
                      ),
                    );
                if (loanAmountController.text.isEmpty && interestController.text.isEmpty && yearsDurationController.text.isEmpty && monthDurationController.text.isEmpty) {
                  const SnackBar(
                    content: Text('Please fill all the fields'),
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
                        ],
                        child: DetailedCalculation(tab: index),
                      ),
                    ),
                  );

                }
              },
              child: const Text(
                'Calculate',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
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
          textField('EMI', emiController),
          const SizedBox(
            height: 10,
          ),
          textField('Annual Interest', interestController),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: textField('Years', yearsDurationController),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: textField('Months', monthDurationController),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                context.read<LoanAmountBloc>().add(
                      CalculateLoanAmount(
                        emiController.text,
                        interestController.text,
                        monthDurationController.text,
                        yearsDurationController.text,
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
              child: const Text(
                'Calculate',
                style: TextStyle(
                  color: Colors.white,
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
          textField('Loan Amount', loanAmountController),
          const SizedBox(
            height: 10,
          ),
          textField('EMI', emiController),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: textField('Years', yearsDurationController),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: textField('Months', monthDurationController),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                context.read<InterestBloc>().add(
                      CalculateInterest(
                        loanAmountController.text,
                        monthDurationController.text,
                        yearsDurationController.text,
                        emiController.text,
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
              child: const Text(
                'Calculate',
                style: TextStyle(
                  color: Colors.white,
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          textField('Loan Amount', loanAmountController),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: textField('Annual Interest', interestController),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: textField('EMI', emiController),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                context.read<PeriodBloc>().add(
                      CalculatePeriod(
                        interestController.text,
                        loanAmountController.text,
                        emiController.text,
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
              child: const Text(
                'Calculate',
                style: TextStyle(
                  color: Colors.white,
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
