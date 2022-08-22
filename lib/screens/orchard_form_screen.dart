import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:huertapp/models/models.dart';
import 'package:huertapp/providers/orchard_form_provider.dart';
import 'package:huertapp/services/crops_services.dart';
import 'package:huertapp/services/orchards_service.dart';
import 'package:huertapp/themes/app_theme.dart';
import 'package:huertapp/ui/input_decorations.dart';
import 'package:huertapp/widgets/card_item.dart';
import 'package:provider/provider.dart';

class OrchardFormScreen extends StatelessWidget {
  const OrchardFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrchardService orchardService = Provider.of<OrchardService>(context);
    return ChangeNotifierProvider(
      create: (context) => OrchardFormProvider(orchardService.selectedOrchard),
      child: _OrchardFormBody(orchardService: orchardService),
    );
  }
}

class _OrchardFormBody extends StatelessWidget {
  final OrchardService orchardService;
  const _OrchardFormBody({Key? key, required this.orchardService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orchardForm = Provider.of<OrchardFormProvider>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.primary,
          title: Text(orchardService.isEditing
              ? 'Editar ${orchardService.selectedOrchard.name}'
              : 'Añadir'),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: orchardService.isSaving
                ? null
                : () async {
                    if (!orchardForm.isValidForm()) return;
                    await orchardService.saveOrchard(orchardForm.orchard);
                    Navigator.of(context).pop();
                  },
            backgroundColor: AppTheme.primary,
            child: orchardService.isSaving
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Icon(FontAwesomeIcons.save)),
        body: SafeArea(
          child: SingleChildScrollView(
            child: _OrchardForm(orchard: orchardService.selectedOrchard),
          ),
        ));
  }
}

class _OrchardForm extends StatefulWidget {
  final Orchard? orchard;

  const _OrchardForm({
    Key? key,
    this.orchard,
  }) : super(key: key);

  @override
  State<_OrchardForm> createState() => _OrchardFormState();
}

class _OrchardFormState extends State<_OrchardForm> {
  final List<Crop> selectedCrops = [];
  @override
  Widget build(BuildContext context) {
    final orchardForm = Provider.of<OrchardFormProvider>(context);
    final orchard = orchardForm.orchard;
    final screenSize = MediaQuery.of(context).size;
    final cropsService = Provider.of<CropsService>(context);

    return SizedBox(
      height: screenSize.height * 0.8,
      child: Form(
          key: orchardForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: screenSize.width * 0.9,
                  child: TextFormField(
                    decoration: InputDecorations.inputDecoration(
                        isRequired: true, labelText: 'Nombre'),
                    maxLines: 1,
                    initialValue: orchard.name,
                    onChanged: (name) => orchard.name = name,
                    validator: (name) {
                      if (name == null || name.isEmpty) {
                        return 'El nombre es obligatorio';
                      }
                      if (name.length > 32) {
                        return 'Este campo no debe superar los 32 caracteres';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: screenSize.width * 0.9,
                  child: TextFormField(
                    decoration: InputDecorations.inputDecoration(
                        isRequired: false, labelText: 'Descripción'),
                    keyboardType: TextInputType.multiline,
                    maxLength: 250,
                    initialValue: orchard.description,
                    onChanged: (description) => orchard.description = description,
                    validator: (description) {
                      if (description != null && description.length > 250) {
                        return 'Este campo no debe superar los 250 caracteres';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                MaterialButton(
                  color: AppTheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _AddCropDialog(
                            size: screenSize,
                            lstCrops: cropsService.crops,
                          );
                        });
                    // TODO: Eliminar
                    selectedCrops.add(cropsService.crops[Random().nextInt(4)]);
                    setState(() {});
                  },
                  child: const Text(
                    'Añadir cultivo',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemBuilder: (context, index) =>
                        CardItem(title: selectedCrops[index].name),
                    itemCount: selectedCrops.length,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class _DescriptionInput extends StatelessWidget {
  const _DescriptionInput({
    Key? key,
    required this.screenSize,
    this.value,
  }) : super(key: key);

  final String? value;
  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenSize.width * 0.9,
      child: TextFormField(
        decoration: InputDecorations.inputDecoration(
            isRequired: false, labelText: 'Descripción'),
        keyboardType: TextInputType.multiline,
        maxLength: 250,
        initialValue: value,
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  const _NameInput({
    Key? key,
    required this.screenSize,
    required this.name,
  }) : super(key: key);

  final Size screenSize;
  final String name;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenSize.width * 0.9,
      child: TextFormField(
        decoration: InputDecorations.inputDecoration(
            isRequired: true, labelText: 'Nombre'),
        maxLines: 1,
        initialValue: name,
      ),
    );
  }
}

class _AddCropDialog extends StatelessWidget {
  final List<Crop> lstCrops;
  final Size? size;

  const _AddCropDialog({
    Key? key,
    required this.lstCrops,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      scrollable: true,
      elevation: 5,
      title: const Text('Selecciona un cultivo'),
      actions: [
        MaterialButton(
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.red,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
        ),
        MaterialButton(
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: const Text('Añadir', style: TextStyle(color: Colors.white)),
        ),
      ],
      content: SizedBox(
        height: 300,
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (Crop crop in lstCrops)
                CardItem(
                  title: crop.name,
                  trailingIcon: FadeInImage(
                      placeholder: const AssetImage('/assets/images/icon.png'),
                      image: NetworkImage(crop.iconUrl),
                      fit: BoxFit.cover,
                      width: size != null ? size!.width * 0.075 : 30,
                      height: size != null ? size!.height * 0.035 : 30),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
