import 'package:flutter/material.dart';
import 'package:huertapp/models/models.dart';
import 'package:image_picker/image_picker.dart';

class OrchardFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late Orchard orchard;
  late List<OrchardCropRelation> relations;
  XFile? image;

  OrchardFormProvider(this.orchard, this.relations);

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
