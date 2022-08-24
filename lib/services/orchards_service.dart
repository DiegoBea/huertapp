import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:huertapp/helpers/helpers.dart';
import 'package:huertapp/models/models.dart';
import 'package:huertapp/services/services.dart';
import 'package:uuid/uuid.dart';

class OrchardService extends ChangeNotifier {
  final List<Orchard> orchards = [];
  final List<OrchardCropRelation> relations = [];
  late Orchard selectedOrchard;

  bool isLoading = true;
  bool isEditing = false;
  bool isSaving = false;

  OrchardService() {
    loadOrchards();
  }

  _refreshOrder() {
    orchards.sort((a, b) => a.name.compareTo(b.name));
  }

  Future<List<Orchard>> loadOrchards() async {
    PrintHelper.printInfo("Cargando huertos...");

    String? uid;
    await AuthService().readToken().then((value) => uid = value);

    PrintHelper.printInfo("Huertos del user_uid $uid");

    orchards.clear();

    if (uid == null) return [];

    final QuerySnapshot ownerOrchards = await FirebaseFirestore.instance
        .collection('orchards')
        .where('owners', arrayContains: uid!)
        .get();
    for (var element in ownerOrchards.docs) {
      Orchard orchard = Orchard(
        uid: element.get('uid'),
        name: element.get('name'),
        description: element.get('description'),
        owners: List<String>.from(element.get('owners')),
        onwer: true,
      );
      orchards.add(orchard);
    }

    final QuerySnapshot guestOrchards = await FirebaseFirestore.instance
        .collection('orchards')
        .where('guests', arrayContains: uid!)
        .get();

    for (var element in guestOrchards.docs) {
      Orchard orchard = Orchard(
        uid: element.get('uid'),
        name: element.get('name'),
        description: element.get('description'),
        owners: List<String>.from(element.get('owners')),
        onwer: false,
      );
      orchards.add(orchard);
    }

    for (Orchard orchard in orchards) {
      PrintHelper.printValue(orchard.name);
      await loadRelations(orchard.uid ?? '');
    }
    PrintHelper.printValue("Cultivos utilizados ${relations.toString()}");
    PrintHelper.printInfo(
        "********Final lectura de cultivos relacionados********");

    orchards.sort(
      (a, b) => a.name.compareTo(b.name),
    );

    PrintHelper.printInfo("********Final lectura de huertos********");

    isLoading = false;
    notifyListeners();

    return orchards;
  }

  loadRelations(String orchardUid) async {
    final QuerySnapshot relations = await FirebaseFirestore.instance
        .collection('orchard_crop_relations')
        .where('orchard_uid', isEqualTo: orchardUid)
        .get();
    relations.docs.forEach((relation) {
      PrintHelper.printValue(relation.data().toString());
      OrchardCropRelation cropRelation = OrchardCropRelation(
          cropUid: relation.get('crop_uid'),
          sownDate: DateTime.parse(relation.get('sown_date')),
          wateringNotification: relation.get('watering_notification'),
          wateringIntervalDays: relation.get('watering_interval_days'),
          seedbed: relation.get('seedbed'),
          transplantNotification: relation.get('transplant_notification'),
          germinationDays: relation.get('germination_days'),
          germiantionNotification: relation.get('germiantion_notification'),
          harvestDays: relation.get('harvest_days'),
          harvestNotification: relation.get('harvest_notification'),
          orchardUid: relation.get('orchard_uid'),
          transplantDays: relation.get('transplant_days'),
          uid: relation.get('uid'));

      this.relations.add(cropRelation);
    });
  }

  Future saveOrchard(
      Orchard orchard, List<OrchardCropRelation> relations) async {
    isSaving = true;
    notifyListeners();

    if (orchard.uid == null) {
      await addOrchard(orchard, relations);
    } else {
      await updateOrchard(orchard);
    }

    isSaving = false;
    notifyListeners();
  }

  Future addOrchard(
      Orchard orchard, List<OrchardCropRelation> relations) async {
    PrintHelper.printInfo('Añadiendo ${orchard.name}...');
    String? uid;
    await AuthService().readToken().then((value) => uid = value);

    if (uid == null) return;

    orchard.owners.add(uid!);
    orchard.guests = [];
    orchard.uid = const Uuid().v1();

    await FirebaseFirestore.instance
        .collection('orchards')
        .add(orchard.toMap());
    orchards.add(orchard);

    for (var relation in relations) {
      relation.orchardUid = orchard.uid;
      await saveCropRelations(relation);
    }
    _refreshOrder();
    PrintHelper.printInfo('${orchard.name} añadido correctamente');
    notifyListeners();
  }

  Future updateOrchard(Orchard orchard) async {
    PrintHelper.printInfo('Actualizando ${orchard.name}...');
    await FirebaseFirestore.instance
        .collection('orchards')
        .where('uid', isEqualTo: orchard.uid)
        .limit(1)
        .get()
        .then((value) {
      for (var element in value.docs) {
        element.reference.update({
          "name": orchard.name,
          "description": orchard.description,
          "owners": orchard.owners,
          "guests": orchard.guests
        });
      }
    });
    var index = orchards.indexWhere((element) => element.uid == orchard.uid);
    orchards[index] = orchard;
    _refreshOrder();
    PrintHelper.printInfo('${orchard.name} actualizado correctamente');
    notifyListeners();
  }

  Future deleteOrchard(Orchard orchard) async {
    PrintHelper.printInfo('Eliminando ${orchard.name}...');
    if (orchard.owners.length == 1) {
      await FirebaseFirestore.instance
          .collection('orchards')
          .where('uid', isEqualTo: orchard.uid)
          .get()
          .then((value) {
        for (var element in value.docs) {
          element.reference.delete();
        }
      });
    } else {
      String? uid;
      await AuthService().readToken().then((value) => uid = value);
      await FirebaseFirestore.instance
          .collection('orchards')
          .where('uid', isEqualTo: orchard.uid)
          .get()
          .then((value) {
        for (var element in value.docs) {
          var index = orchard.owners.indexOf(uid ?? '');
          orchard.owners.removeAt(index);
          element.reference.update({
            "owners": orchard.owners,
          });
        }
      });
    }
    orchards.remove(orchard);
    _refreshOrder();
    PrintHelper.printInfo('${orchard.name} eliminado correctamente');
    notifyListeners();
  }

  Future saveCropRelations(OrchardCropRelation relation) async {
    PrintHelper.printInfo('Guardando relaciones...');
    // TODO: Actualizar lista de relaciones
    if (relation.uid != null) {
      // Actualizar
    } else {
      // Añadir
      relation.uid = const Uuid().v1();
      await FirebaseFirestore.instance
          .collection('orchard_crop_relations')
          .add(relation.toMap());
      PrintHelper.printInfo('Relación añadida correctamente');
      notifyListeners();
    }
    PrintHelper.printValue(relation.toJson());
    PrintHelper.printInfo('Relaciones guardadas correctamente');
    // PrintHelper.printInfo('Añadiendo ${relations.}...');
    // String? uid;
    // await AuthService().readToken().then((value) => uid = value);

    // if (uid == null) return;

    // orchard.owners.add(uid!);
    // orchard.guests = [];
    // orchard.uid = const Uuid().v1();

    // await FirebaseFirestore.instance
    //     .collection('orchards')
    //     .add(orchard.toMap());
    // orchards.add(orchard);
    // _refreshOrder();
    // PrintHelper.printInfo('${orchard.name} añadido correctamente');
    // notifyListeners();
  }
}
