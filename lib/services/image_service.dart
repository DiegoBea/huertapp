import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huertapp/helpers/helpers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageService extends ChangeNotifier {
  Future<XFile?> selectImage() async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? image;

    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        ToastHelper.showToast('Imagen no seleccionada');
        return null;
      }
    } else {
      ToastHelper.showToast('Permiso a la galería denegado');
      print('Permiso denegado');
    }
    return image;
  }

  Future<String> uploadImage(File image, String uid) async {
    PrintHelper.printInfo("Subiendo imagen con uid $uid");
    final firebaseStorage = FirebaseStorage.instance;
    var snapshot =
        await firebaseStorage.ref().child('orchards/$uid').putFile(image);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    PrintHelper.printValue(downloadUrl);
    PrintHelper.printInfo('Imagen añadida correctamente');

    return downloadUrl;
  }

  removeImage(String uid) async {
    PrintHelper.printInfo("Eliminando imagen con uid $uid");
    final firebaseStorage = FirebaseStorage.instance;
    try {
      await firebaseStorage.ref().child('orchards/$uid').delete();
    } catch (e) {
      print(e);
    }

    PrintHelper.printInfo('Imagen eliminada correctamente');
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
}
