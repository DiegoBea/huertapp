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
      child: SingleChildScrollView(
        child: Form(
            key: orchardForm.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  _NameInput(screenSize: screenSize, orchard: orchard),
                  const SizedBox(height: 10),
                  _DescriptionInput(screenSize: screenSize, orchard: orchard),
                  const SizedBox(height: 10),
                  _cropListTitle(context, cropsService, screenSize),
                  const SizedBox(height: 10),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 325),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.primary, width: 2),
                        borderRadius: BorderRadius.circular(15)),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: selectedCrops.length,
                      itemBuilder: (context, index) => Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: ExpansionTile(
                            textColor: AppTheme.primary,
                            iconColor: AppTheme.primary,
                            title: ListTile(
                                leading: FadeInImage(
                                    placeholder: const AssetImage(
                                        '/assets/images/icon.png'),
                                    image: NetworkImage(
                                        selectedCrops[index].iconUrl),
                                    fit: BoxFit.cover,
                                    width: screenSize.width * 0.075,
                                    height: screenSize.height * 0.035),
                                title: Text(
                                  selectedCrops[index].name,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                )),
                            children: [
                              if (selectedCrops[index].seedbed)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text("Semillero"),
                                    ),
                                    Switch.adaptive(
                                        value: true,
                                        onChanged: (value) {},
                                        activeColor: AppTheme.primary),
                                  ],
                                ),
                              MaterialButton(
                                  onPressed: () => showDatePicker(
                                    confirmText: "Aceptar",
                                    cancelText: "Cancelar",
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now()),
                                  child: Icon(Icons.calendar_month)),
                                  MaterialButton(
                                  onPressed: () => {},
                                  child: Icon(Icons.calendar_today)),
                              const Text("Notificaciones",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text("Germinación"),
                                  ),
                                  Switch.adaptive(
                                      value: true,
                                      onChanged: (value) {},
                                      activeColor: AppTheme.primary),
                                ],
                              ),
                              if (selectedCrops[index].wateringNotification !=
                                  null)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text("Regadío"),
                                    ),
                                    Switch.adaptive(
                                        value: true,
                                        onChanged: (value) {},
                                        activeColor: AppTheme.primary),
                                  ],
                                ),
                              if (selectedCrops[index].transplantNotification !=
                                  null)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text("Transplante"),
                                    ),
                                    Switch.adaptive(
                                        value: true,
                                        onChanged: (value) {},
                                        activeColor: AppTheme.primary),
                                  ],
                                ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text("Cosecha"),
                                  ),
                                  Switch.adaptive(
                                      value: true,
                                      onChanged: (value) {},
                                      activeColor: AppTheme.primary),
                                ],
                              ),
                            ]),
                        // child: const SingleChildScrollView(child: ListTile(title: Text('Prueba'))),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Container _selectedCropsList() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 325),
      decoration: BoxDecoration(
          border: Border.all(color: AppTheme.primary, width: 2),
          borderRadius: BorderRadius.circular(15)),
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) => SingleChildScrollView(
          child: CardItem(
              title: selectedCrops[index].name,
              trailingIcon: IconButton(
                icon: const Icon(
                  Icons.remove,
                  color: Colors.red,
                ),
                onPressed: () {
                  selectedCrops.removeAt(index);
                  setState(() {});
                },
              )),
        ),
        itemCount: selectedCrops.length,
      ),
    );
  }

  Row _cropListTitle(
      BuildContext context, CropsService cropsService, Size screenSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Lista de cultivos',
          style: AppTheme.title2,
        ),
        MaterialButton(
          color: AppTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _showCropsDialog(context, cropsService, screenSize);
                });
            setState(() {});
          },
          child: const Text(
            'Añadir',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  AlertDialog _showCropsDialog(
      BuildContext context, CropsService cropsService, Size screenSize) {
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
      ],
      content: SizedBox(
        height: 400,
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (Crop crop in cropsService.crops)
                CardItem(
                  title: crop.name,
                  trailingIcon: FadeInImage(
                      placeholder: const AssetImage('/assets/images/icon.png'),
                      image: NetworkImage(crop.iconUrl),
                      fit: BoxFit.cover,
                      width: screenSize.width * 0.075,
                      height: screenSize.height * 0.035),
                  onTap: () {
                    selectedCrops.add(cropsService.crops
                        .firstWhere((element) => element.uid == crop.uid));
                    setState(() {});
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DescriptionInput extends StatelessWidget {
  const _DescriptionInput({
    Key? key,
    required this.screenSize,
    required this.orchard,
  }) : super(key: key);

  final Size screenSize;
  final Orchard orchard;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}

class _NameInput extends StatelessWidget {
  const _NameInput({
    Key? key,
    required this.screenSize,
    required this.orchard,
  }) : super(key: key);

  final Size screenSize;
  final Orchard orchard;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}
