import 'dart:math';

import 'package:flutter/material.dart';
import 'package:huertapp/models/crop.dart';
import 'package:huertapp/models/models.dart';
import 'package:huertapp/providers/orchard_form_provider.dart';
import 'package:huertapp/services/crops_services.dart';
import 'package:huertapp/themes/app_theme.dart';
import 'package:huertapp/ui/input_decorations.dart';
import 'package:huertapp/widgets/card_item.dart';
import 'package:provider/provider.dart';

class OrchardFormScreen extends StatelessWidget {
  const OrchardFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Orchard? orchard =
        ModalRoute.of(context)?.settings.arguments as Orchard?;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.primary,
          title: Text(orchard != null ? 'Editar ${orchard.name}' : 'Añadir'),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            backgroundColor: AppTheme.primary,
            child: const Icon(Icons.add)),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ChangeNotifierProvider(
                  create: (context) => OrchardFormProvider(null),
                  child: _OrchardForm(orchard: orchard),
                )
              ],
            ),
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
    final screenSize = MediaQuery.of(context).size;
    final cropsService = Provider.of<CropsService>(context);

    return SizedBox(
      height: screenSize.height * 0.8,
      // decoration: BoxDecoration(),
      child: Form(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            _NameInput(
                screenSize: screenSize, name: widget.orchard?.name ?? ''),
            const SizedBox(height: 10),
            _DescriptionInput(screenSize: screenSize),
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
              child: const Text('Añadir cultivo'),
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
  }) : super(key: key);

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
