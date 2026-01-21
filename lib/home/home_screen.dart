import 'package:emi_calculator/components/home_tabs.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  HomeTabs homeTabs = HomeTabs();

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
            homeTabs.emiTab(context, 0),
            homeTabs.loanAmountTab(context, 1),
            homeTabs.interestTab(context, 2),
            homeTabs.periodTab(context, 3),
          ],
        ),
      ),
    );
  }
}
