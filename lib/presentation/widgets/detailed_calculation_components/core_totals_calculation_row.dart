import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoreTotalsCalculationRow<B extends BlocBase<S>, S> extends StatelessWidget {
  final String label;
  final String Function(S state) valueProvider;

  const CoreTotalsCalculationRow({super.key, required this.label, required this.valueProvider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Spacer(),
          BlocBuilder<B, S>(
            builder: (context, state) {
              return Text(
                valueProvider(state),
                style: Theme.of(context).textTheme.bodyMedium,
              );
            },
          ),
        ],
      ),
    );
  }
}
