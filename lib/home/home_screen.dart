import 'package:emi_calculator/bloc/emi_bloc.dart';
import 'package:emi_calculator/bloc/emi_even.dart';
import 'package:emi_calculator/bloc/emi_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  TextEditingController loanAmountController = TextEditingController();
  TextEditingController interestController = TextEditingController();
  TextEditingController durationController = TextEditingController();

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
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
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
                        'Rs. ${state.emi.toString()}',
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
                    height: 30,
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
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                            filled: true,
                            fillColor: Colors.purple[50],
                            hintText: 'Annual interest',
                          ),
                          keyboardType: TextInputType.number,
                          controller: interestController,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                            filled: true,
                            fillColor: Colors.purple[50],
                            hintText: 'Duration of loan',
                          ),
                          keyboardType: TextInputType.number,
                          controller: durationController,
                        ),
                      )
                    ],
                  ),
                  const Spacer(),
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
                                durationController.text,
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
            ),
          ],
        ),
      ),
    );
  }
}
