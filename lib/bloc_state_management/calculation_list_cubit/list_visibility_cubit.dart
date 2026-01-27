import 'package:flutter_bloc/flutter_bloc.dart';

class ListVisibilityCubit extends Cubit<bool> {
  ListVisibilityCubit() : super(true);

  void toggleVisibility() {
    emit(!state);
  }
}
