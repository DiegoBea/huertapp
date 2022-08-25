import 'dart:io';

import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:huertapp/helpers/helpers.dart';
import 'package:huertapp/models/models.dart';
import 'package:huertapp/providers/orchard_form_provider.dart';
import 'package:huertapp/services/services.dart';
import 'package:huertapp/themes/app_theme.dart';
import 'package:huertapp/ui/input_decorations.dart';
import 'package:huertapp/widgets/widgets.dart';
import 'package:provider/provider.dart';

class OrchardFormScreen extends StatelessWidget {
  const OrchardFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrchardService orchardService = Provider.of<OrchardService>(context);
    final ImageService imageService = Provider.of<ImageService>(context);
    PrintHelper.printInfo(
        "Relaciones: ${orchardService.selectedRelations.length}");
    return ChangeNotifierProvider(
      create: (context) => OrchardFormProvider(
          orchardService.selectedOrchard, orchardService.selectedRelations),
      child: _OrchardFormBody(
          orchardService: orchardService, imageService: imageService),
    );
  }
}

class _OrchardFormBody extends StatelessWidget {
  final OrchardService orchardService;
  final ImageService imageService;
  const _OrchardFormBody(
      {Key? key, required this.orchardService, required this.imageService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orchardForm = Provider.of<OrchardFormProvider>(context);
    return Scaffold(
        appBar: orchardService.selectedImageUrl == null
            ? AppBar(
                backgroundColor: AppTheme.primary,
                title: Text(orchardService.isEditing
                    ? 'Editar ${orchardService.selectedOrchard.name}'
                    : 'Añadir'),
              )
            : null,
        floatingActionButton: FloatingActionButton(
            onPressed: orchardService.isSaving
                ? null
                : () async {
                    if (!orchardForm.isValidForm()) return;
                    await orchardService.saveOrchard(
                        orchardForm.orchard,
                        orchardForm.relations,
                        orchardForm.image != null
                            ? File(orchardForm.image!.path)
                            : null);
                    Navigator.of(context).pop();
                  },
            backgroundColor: AppTheme.primary,
            child: orchardService.isSaving
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Icon(FontAwesomeIcons.save)),
        body: SafeArea(
            child: orchardService.selectedImageUrl != null
                ? CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        actions: const [
                          Padding(
                            padding: EdgeInsets.only(right: 25),
                            child: Icon(FontAwesomeIcons.solidImage),
                          ),
                        ],
                        backgroundColor: AppTheme.primary,
                        flexibleSpace: FlexibleSpaceBar(
                            background: FadeInImage(
                          placeholder:
                              const AssetImage('assets/videos/loading.gif'),
                          image: NetworkImage(orchardService.selectedImageUrl!),
                          fit: BoxFit.cover,
                        )),
                        expandedHeight: 200,
                        floating: false,
                        pinned: true,
                      ),
                      SliverList(
                          delegate: SliverChildListDelegate([
                        _OrchardForm(orchard: orchardService.selectedOrchard)
                      ])),
                    ],
                  )
                : SingleChildScrollView(
                    child:
                        _OrchardForm(orchard: orchardService.selectedOrchard),
                  )));
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
  @override
  Widget build(BuildContext context) {
    final orchardForm = Provider.of<OrchardFormProvider>(context);
    final orchardService = Provider.of<OrchardService>(context);
    final imageService = Provider.of<ImageService>(context);
    final orchard = orchardForm.orchard;
    final orchardCropRelations = orchardForm.relations;
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Imagen',
                        style: AppTheme.title2,
                      ),
                      IconButton(
                          onPressed: () async {
                            await imageService
                                .selectImage()
                                .then((value) => orchardForm.image = value);
                            setState(() {});
                          },
                          icon: const Icon(FontAwesomeIcons.camera)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (orchardForm.image != null)
                    SizedBox(
                        height: 200,
                        child: Image(
                          image: XFileImage(orchardForm.image!),
                          fit: BoxFit.cover,
                        )),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Lista de cultivos',
                        style: AppTheme.title2,
                      ),
                      _AddCropButton(context, cropsService, screenSize,
                          orchardCropRelations, orchard),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 325),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.primary, width: 2),
                        borderRadius: BorderRadius.circular(15)),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: orchardCropRelations.length,
                      itemBuilder: (context, index) => Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: ExpansionTile(
                            textColor: AppTheme.primary,
                            iconColor: AppTheme.primary,
                            title: ListTile(
                                trailing: IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                scrollable: true,
                                                elevation: 5,
                                                content: const Text(
                                                    '¿Deseas eliminar este cultivo?',
                                                    style: TextStyle(
                                                        fontSize: 15)),
                                                title: const Center(
                                                    child: Text(
                                                        'Eliminar cultivo')),
                                                actions: [
                                                  MaterialButton(
                                                    onPressed: () {
                                                      orchardService
                                                          .deleteRelation(
                                                              orchardCropRelations[
                                                                  index]);
                                                      orchardCropRelations
                                                          .removeAt(index);
                                                      setState(() {});
                                                      Navigator.pop(context);
                                                    },
                                                    color: Colors.red,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                    child: const Text(
                                                        'Eliminar',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                  MaterialButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                    color: Colors.blue,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                    child: const Text(
                                                        'Cancelar',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                ],
                                              ));
                                    },
                                    icon: const Icon(
                                      FontAwesomeIcons.times,
                                      color: Colors.red,
                                    )),
                                leading: FadeInImage(
                                    placeholder: const AssetImage(
                                        '/assets/images/icon.png'),
                                    image: NetworkImage(cropsService
                                        .getCropByUid(
                                            orchardCropRelations[index].cropUid)
                                        .iconUrl),
                                    fit: BoxFit.cover,
                                    width: screenSize.width * 0.075,
                                    height: screenSize.height * 0.035),
                                title: Text(
                                  cropsService
                                      .getCropByUid(
                                          orchardCropRelations[index].cropUid)
                                      .name,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                )),
                            children: [
                              if (cropsService
                                  .getCropByUid(
                                      orchardCropRelations[index].cropUid)
                                  .seedbed)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text("Semillero"),
                                    ),
                                    Switch.adaptive(
                                        value:
                                            orchardCropRelations[index].seedbed,
                                        onChanged: (value) {
                                          orchardCropRelations[index].seedbed =
                                              value;
                                          setState(() {});
                                        },
                                        activeColor: AppTheme.primary),
                                  ],
                                ),
                              MaterialButton(
                                  onPressed: () async {
                                    var datePicked =
                                        await DatePicker.showSimpleDatePicker(
                                            context,
                                            initialDate:
                                                orchardCropRelations[index]
                                                    .sownDate,
                                            dateFormat: "dd-MMMM-yyyy",
                                            locale: DateTimePickerLocale.es,
                                            looping: true,
                                            titleText: "Selecciona una fecha",
                                            confirmText: "Aceptar",
                                            cancelText: "Cancelar");
                                    if (datePicked != null) {
                                      orchardCropRelations[index].sownDate =
                                          datePicked;
                                    }
                                    setState(() {});
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Fecha de sembrado'),
                                      Icon(
                                        FontAwesomeIcons.calendarAlt,
                                        color: AppTheme.primary,
                                      ),
                                    ],
                                  )),
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
                                      value: orchardCropRelations[index]
                                          .germinationNotification,
                                      onChanged: (value) {
                                        orchardCropRelations[index]
                                            .germinationNotification = value;
                                        setState(() {});
                                      },
                                      activeColor: AppTheme.primary),
                                ],
                              ),
                              if (cropsService
                                      .getCropByUid(
                                          orchardCropRelations[index].cropUid)
                                      .wateringNotification !=
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
                                        value: orchardCropRelations[index]
                                            .wateringNotification,
                                        onChanged: (value) {
                                          orchardCropRelations[index]
                                              .wateringNotification = value;
                                          setState(() {});
                                        },
                                        activeColor: AppTheme.primary),
                                  ],
                                ),
                              if (cropsService
                                      .getCropByUid(
                                          orchardCropRelations[index].cropUid)
                                      .transplantNotification !=
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
                                        value: orchardCropRelations[index]
                                            .transplantNotification,
                                        onChanged: (value) {
                                          orchardCropRelations[index]
                                              .transplantNotification = value;
                                          setState(() {});
                                        },
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
                                      value: orchardCropRelations[index]
                                          .harvestNotification,
                                      onChanged: (value) {
                                        orchardCropRelations[index]
                                            .harvestNotification = value;
                                        setState(() {});
                                      },
                                      activeColor: AppTheme.primary),
                                ],
                              ),
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  MaterialButton _AddCropButton(
      BuildContext context,
      CropsService cropsService,
      Size screenSize,
      List<OrchardCropRelation> orchardCropRelations,
      Orchard orchard) {
    return MaterialButton(
      color: AppTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                scrollable: true,
                elevation: 5,
                title: const Text('Selecciona un cultivo'),
                actions: [
                  MaterialButton(
                    onPressed: () => Navigator.of(context).pop(),
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: const Text('Cancelar',
                        style: TextStyle(color: Colors.white)),
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
                                placeholder:
                                    const AssetImage('/assets/images/icon.png'),
                                image: NetworkImage(crop.iconUrl),
                                fit: BoxFit.cover,
                                width: screenSize.width * 0.075,
                                height: screenSize.height * 0.035),
                            onTap: () {
                              Crop selectedCrop =
                                  cropsService.getCropByUid(crop.uid);
                              orchardCropRelations.add(OrchardCropRelation(
                                  cropUid: selectedCrop.uid,
                                  orchardUid: orchard.uid,
                                  sownDate: DateTime.now(),
                                  wateringIntervalDays:
                                      selectedCrop.wateringNotification ?? 0,
                                  // wateringNotification:
                                  //     selectedCrop.wateringNotification !=
                                  //             null
                                  //         ? true
                                  //         : false,
                                  wateringNotification: false,
                                  seedbed: selectedCrop.seedbed,
                                  transplantNotification:
                                      selectedCrop.transplantNotification !=
                                              null
                                          ? true
                                          : false,
                                  transplantDays:
                                      selectedCrop.transplantNotification,
                                  germinationDays: selectedCrop.germination,
                                  germinationNotification: true,
                                  harvestDays: selectedCrop.harvestNotification,
                                  harvestNotification: true));
                              setState(() {});
                              Navigator.pop(context);
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              );
            });
        setState(() {});
      },
      child: const Text(
        'Añadir',
        style: TextStyle(color: Colors.white),
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
