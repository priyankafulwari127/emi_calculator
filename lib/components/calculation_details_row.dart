import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalculationDetailsRow<B extends BlocBase<S>, S> extends StatelessWidget {
  final String label;
  final String Function(S state) valueProvider;

  const CalculationDetailsRow({super.key, required this.label, required this.valueProvider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          const Spacer(),
          BlocBuilder<B, S>(
            builder: (context, state) {
              return Text(
                valueProvider(state),
                style: const TextStyle(
                  fontSize: 14,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
