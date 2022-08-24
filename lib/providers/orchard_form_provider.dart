import 'package:flutter/material.dart';
import 'package:huertapp/models/models.dart';

class OrchardFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<OrchardCropRelation> lstRelations = [];
  late Orchard orchard;

  OrchardFormProvider(this.orchard);

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
