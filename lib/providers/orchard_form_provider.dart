import 'package:flutter/material.dart';
import 'package:huertapp/models/models.dart';

class OrchardFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late Orchard orchard;
  late List<OrchardCropRelation> relations;

  OrchardFormProvider(
      this.orchard, this.relations);

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
