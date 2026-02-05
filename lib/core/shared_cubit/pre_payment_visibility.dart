import 'package:flutter_bloc/flutter_bloc.dart';

class PrePaymentVisibility extends Cubit<bool>{
  PrePaymentVisibility(): super(false);

  void toggleVisibility(){
    emit(!state);
  }
}