import 'package:emi_calculator/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:emi_calculator/presentation/bloc/auth_bloc/auth_event.dart';
import 'package:emi_calculator/presentation/bloc/auth_bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/home_components/home_tabs.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  HomeTabs homeTabs = HomeTabs();

  @override
  Widget build(BuildContext context) {
    final user = (context.watch<AuthBloc>().state as Authenticated).user;

    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: Text(
            'EMI Calculator',
            style: Theme.of(context).textTheme.displaySmall
          ),
          actions: [
            IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(LogoutRequest());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Logged Out as ${user.phoneNumber}'),
                  ),
                );
              },
              icon: Icon(
                Icons.login,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            )
          ],
          bottom: TabBar(
            indicatorColor: Theme.of(context).colorScheme.onSurface,
            labelColor: Theme.of(context).colorScheme.onSurface,
            tabs: const [
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
