import 'package:emi_calculator/bloc_state_management/bloc/interest_bloc.dart';
import 'package:emi_calculator/bloc_state_management/bloc/loan_amount_bloc.dart';
import 'package:emi_calculator/bloc_state_management/bloc/period_bloc.dart';
import 'package:emi_calculator/bloc_state_management/event/interest_event.dart';
import 'package:emi_calculator/bloc_state_management/event/loan_amount_event.dart';
import 'package:emi_calculator/bloc_state_management/event/period_event.dart';
import 'package:emi_calculator/bloc_state_management/state/interest_state.dart';
import 'package:emi_calculator/bloc_state_management/state/loan_amount_state.dart';
import 'package:emi_calculator/bloc_state_management/state/period_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc_state_management/bloc/emi_bloc.dart';
import '../bloc_state_management/event/emi_event.dart';
import '../bloc_state_management/state/emi_state.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  TextEditingController loanAmountController = TextEditingController();
  TextEditingController interestController = TextEditingController();
  TextEditingController monthDurationController = TextEditingController();
  TextEditingController yearsDurationController = TextEditingController();
  TextEditingController emiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'EMI Calculator',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.purple[400],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            tabs: [
              Tab(text: 'EMI'),
              Tab(text: 'Loan Amount'),
              Tab(text: 'Interest'),
              Tab(text: 'Period'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            emiTab(context),
            loanAmountTab(context),
            interestTab(context),
            periodTab(context),
          ],
        ),
      ),
    );
  }

  Widget emiTab(BuildContext context) {
    var isDetailsButtonVisible = false;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Monthly EMI',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          BlocBuilder<EmiBloc, EmiState>(builder: (context, state) {
            if (state is CalculatedEmi) {
              return Text(
                'Rs. ${state.emi.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              );
            }
            return const Text(
              'Rs. 0.0',
              style: TextStyle(
                fontSize: 20,
              ),
            );
          }),
          const SizedBox(
            height: 20,
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.purple[50],
              hintText: 'Loan amount',
            ),
            keyboardType: TextInputType.number,
            controller: loanAmountController,
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.purple[50],
              hintText: 'Annual Interest',
            ),
            keyboardType: TextInputType.number,
            controller: interestController,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.purple[50],
                    hintText: 'Duration in Years',
                  ),
                  keyboardType: TextInputType.number,
                  controller: yearsDurationController,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.purple[50],
                    hintText: 'Duration in month',
                  ),
                  keyboardType: TextInputType.number,
                  controller: monthDurationController,
                ),
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

  Widget loanAmountTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Loan Amount',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          BlocBuilder<LoanAmountBloc, LoanAmountState>(builder: (context, state) {
            if (state is CalculatedLoanAmount) {
              return Text(
                'Rs. ${state.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              );
            }
            return const Text(
              'Rs. 0.0',
              style: TextStyle(
                fontSize: 20,
              ),
            );
          }),
          const SizedBox(
            height: 20,
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.purple[50],
              hintText: 'EMI',
            ),
            keyboardType: TextInputType.number,
            controller: emiController,
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.purple[50],
              hintText: 'Annual Interest',
            ),
            keyboardType: TextInputType.number,
            controller: interestController,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.purple[50],
                    hintText: 'Duration in Years',
                  ),
                  keyboardType: TextInputType.number,
                  controller: yearsDurationController,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.purple[50],
                    hintText: 'Duration in months',
                  ),
                  keyboardType: TextInputType.number,
                  controller: monthDurationController,
                ),
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
                context.read<LoanAmountBloc>().add(
                      CalculateLoanAmount(
                        emiController.text,
                        interestController.text,
                        monthDurationController.text,
                        yearsDurationController.text,
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

  Widget interestTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Annual Interest',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          BlocBuilder<InterestBloc, InterestState>(builder: (context, state) {
            if (state is CalculatedInterest) {
              return Text(
                '${state.inter.toStringAsFixed(2)}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              );
            }
            return const Text(
              '0%',
              style: TextStyle(
                fontSize: 20,
              ),
            );
          }),
          const SizedBox(
            height: 20,
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.purple[50],
              hintText: 'Loan amount',
            ),
            keyboardType: TextInputType.number,
            controller: loanAmountController,
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.purple[50],
              hintText: 'EMI',
            ),
            keyboardType: TextInputType.number,
            controller: emiController,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.purple[50],
                    hintText: 'Duration in years',
                  ),
                  keyboardType: TextInputType.number,
                  controller: yearsDurationController,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.purple[50],
                    hintText: 'Duration in months',
                  ),
                  keyboardType: TextInputType.number,
                  controller: monthDurationController,
                ),
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
                context.read<InterestBloc>().add(
                      CalculateInterest(
                        loanAmountController.text,
                        monthDurationController.text,
                        yearsDurationController.text,
                        emiController.text,
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

  Widget periodTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Loan Period',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          BlocBuilder<PeriodBloc, PeriodState>(builder: (context, state) {
            if (state is CalculatedPeriod) {
              return Text(
                '${state.period.toStringAsFixed(2)} years',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              );
            }
            return const Text(
              '0 years',
              style: TextStyle(
                fontSize: 20,
              ),
            );
          }),
          const SizedBox(
            height: 20,
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.purple[50],
              hintText: 'Loan amount',
            ),
            keyboardType: TextInputType.number,
            controller: loanAmountController,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.purple[50],
                    hintText: 'Annual interest',
                  ),
                  keyboardType: TextInputType.number,
                  controller: interestController,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.purple[50],
                    hintText: 'EMI',
                  ),
                  keyboardType: TextInputType.number,
                  controller: emiController,
                ),
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
                context.read<PeriodBloc>().add(
                      CalculatePeriod(
                        interestController.text,
                        loanAmountController.text,
                        emiController.text,
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
