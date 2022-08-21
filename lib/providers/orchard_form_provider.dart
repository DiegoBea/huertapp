import 'package:flutter/material.dart';
import 'package:huertapp/models/models.dart';

class OrchardFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Orchard? orchard;

  OrchardFormProvider(this.orchard);

  // updateAvailability(bool value) {
  //   product.available = value;
  //   notifyListeners();
  // }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
