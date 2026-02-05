import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabCalculationWidget<B extends BlocBase<S>, S> extends StatelessWidget {
  final String title;
  final String Function(S state) valueProvider;

  const TabCalculationWidget({super.key, required this.title, required this.valueProvider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        BlocBuilder<B, S>(
          builder: (context, state) {
            return Text(
              valueProvider(state),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            );
          },
        ),
      ],
    );
  }
}
