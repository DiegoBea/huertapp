import 'dart:io';

import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:huertapp/helpers/helpers.dart';
import 'package:huertapp/models/models.dart';
import 'package:huertapp/providers/orchard_form_provider.dart';
import 'package:huertapp/providers/theme_provider.dart';
import 'package:huertapp/services/services.dart';
import 'package:huertapp/shared_preferences/preferences.dart';
import 'package:huertapp/themes/app_theme.dart';
import 'package:huertapp/ui/input_decorations.dart';
import 'package:huertapp/widgets/widgets.dart';
import 'package:intl/intl.dart';
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
                backgroundColor: ThemeProvider.primary,
                title: Text(orchardService.isEditing
                    ? translate('feedback.edit',
                        args: {"name": orchardService.selectedOrchard.name})
                    : translate('titles.add')),
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
            backgroundColor: ThemeProvider.primary,
            child: orchardService.isSaving
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Icon(FontAwesomeIcons.save)),
        body: orchardService.selectedImageUrl != null
            ? CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: ThemeProvider.primary,
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
                child: _OrchardForm(orchard: orchardService.selectedOrchard),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          translate('titles.image'),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          translate('titles.cropList'),
                          style: AppTheme.title2,
                        ),
                        _addCropButton(context, cropsService, screenSize,
                            orchardCropRelations, orchard),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 325),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: ThemeProvider.primary, width: 2),
                        borderRadius: BorderRadius.circular(15)),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: orchardCropRelations.length,
                      itemBuilder: (context, index) => Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: ExpansionTile(
                            textColor: ThemeProvider.primary,
                            iconColor: ThemeProvider.primary,
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
                                                content: Text(
                                                    translate('crop.remove'),
                                                    style: const TextStyle(
                                                        fontSize: 15)),
                                                title: Center(
                                                    child: Text(translate(
                                                        'crop.removeTitle'))),
                                                actions: [
                                                  MaterialButton(
                                                    onPressed: () {
                                                      orchardService
                                                          .deleteRelation(
                                                              orchardCropRelations[
                                                                          index]
                                                                      .uid ??
                                                                  '');
                                                      orchardService.relations
                                                          .removeWhere((element) =>
                                                              element.uid ==
                                                              orchardCropRelations[
                                                                      index]
                                                                  .uid);
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
                                                    child: Text(
                                                        translate(
                                                            'titles.delete'),
                                                        style: const TextStyle(
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
                                                    child: Text(
                                                        translate(
                                                            'titles.cancel'),
                                                        style: const TextStyle(
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
                                        'assets/images/icon.png'),
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
                                      .name[Preferences.lang]!,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                )),
                            children: [
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
                                            titleText: translate(
                                                'feedback.chooseDate'),
                                            confirmText:
                                                translate('titles.confirm'),
                                            cancelText:
                                                translate('titles.cancel'));
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
                                      Text(translate('crop.sownDate', args: {
                                        "value": DateFormat("dd/MM/yy").format(
                                            orchardCropRelations[index]
                                                .sownDate)
                                      })), //Fecha de sembrado: ${DateFormat("dd/MM/yy").format(orchardCropRelations[index].sownDate)}
                                      Icon(
                                        FontAwesomeIcons.calendarAlt,
                                        color: ThemeProvider.primary,
                                      ),
                                    ],
                                  )),
                              Text(translate('titles.notifications'),
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Text(translate('crop.germination')),
                                  ),
                                  Switch.adaptive(
                                      value: orchardCropRelations[index]
                                          .germinationNotification,
                                      onChanged: (value) {
                                        orchardCropRelations[index]
                                            .germinationNotification = value;
                                        setState(() {});
                                      },
                                      activeColor: ThemeProvider.primary),
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
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Text(translate('crop.watering')),
                                    ),
                                    Switch.adaptive(
                                        value: orchardCropRelations[index]
                                            .wateringNotification,
                                        onChanged: (value) {
                                          orchardCropRelations[index]
                                              .wateringNotification = value;
                                          setState(() {});
                                        },
                                        activeColor: ThemeProvider.primary),
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
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Text(translate('crop.transplant')),
                                    ),
                                    Switch.adaptive(
                                        value: orchardCropRelations[index]
                                            .transplantNotification,
                                        onChanged: (value) {
                                          orchardCropRelations[index]
                                              .transplantNotification = value;
                                          setState(() {});
                                        },
                                        activeColor: ThemeProvider.primary),
                                  ],
                                ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Text(translate('crop.harvest')),
                                  ),
                                  Switch.adaptive(
                                      value: orchardCropRelations[index]
                                          .harvestNotification,
                                      onChanged: (value) {
                                        orchardCropRelations[index]
                                            .harvestNotification = value;
                                        setState(() {});
                                      },
                                      activeColor: ThemeProvider.primary),
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

  MaterialButton _addCropButton(
      BuildContext context,
      CropsService cropsService,
      Size screenSize,
      List<OrchardCropRelation> orchardCropRelations,
      Orchard orchard) {
    return MaterialButton(
      color: ThemeProvider.primary,
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
                title: Text(translate('feedback.chooseCrop')),
                actions: [
                  MaterialButton(
                    onPressed: () => Navigator.of(context).pop(),
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(translate('titles.cancel'),
                        style: const TextStyle(color: Colors.white)),
                  ),
                ],
                content: SizedBox(
                  height: 400,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (Crop crop in cropsService.crops)
                          CardItem(
                            title: crop.name[Preferences.lang]!,
                            trailingIcon: FadeInImage(
                                placeholder:
                                    const AssetImage('assets/images/icon.png'),
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
                                  wateringNotification: false,
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
      child: Text(
        translate('titles.add'),
        style: const TextStyle(color: Colors.white),
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
            isRequired: false, labelText: translate('titles.description')),
        keyboardType: TextInputType.multiline,
        maxLength: 250,
        initialValue: orchard.description,
        onChanged: (description) => orchard.description = description,
        validator: (description) {
          if (description != null && description.length > 250) {
            return translate('validation.charLimit', args: {
              "value": 250
            }); // 'Este campo no debe superar los 250 caracteres'
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
            isRequired: true, labelText: translate('titles.name')),
        maxLines: 1,
        initialValue: orchard.name,
        onChanged: (name) => orchard.name = name,
        validator: (name) {
          if (name == null || name.isEmpty) {
            return translate('validation.required');
          }
          if (name.length > 32) {
            return translate('validation.charLimit', args: {
              "value": 32
            });
          }
          return null;
        },
      ),
    );
  }
}
