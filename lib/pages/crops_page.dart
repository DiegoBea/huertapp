import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:huertapp/models/models.dart';
import 'package:huertapp/screens/screens.dart';
import 'package:huertapp/services/crops_services.dart';
import 'package:huertapp/themes/app_theme.dart';
import 'package:provider/provider.dart';

class CropsPage extends StatelessWidget {
  const CropsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cropsService = Provider.of<CropsService>(context);

    if (cropsService.isLoading) return const LoadingScreen();

    return SafeArea(
        child: Scaffold(
      backgroundColor: AppTheme.primary,
      body: Container(
        margin: const EdgeInsets.all(10),
        child: ListView(
          children: [
            // const Text('Cultivos personalizados'),
            // for (Crops crop in lstNewCrops)
            //   _cropCard(cropsName: crop.name, cropsIcons: crop.icon),
            const Center(
              child: Text('Cultivos',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.black54)),
            ),
            for (Crop crop in cropsService.crops)
              _CropCard(crop: crop),
          ],
        ),
      ),
      // body: ListView.builder(
      //     itemBuilder: (context, index) {
      // return Container(
      //   color: AppTheme.primary,
      //   child: _cropCard(cropsName: cropsName[index], cropsIcons: cropsIcons[index]),
      //   ),
      // );
      //     },
      //     itemCount: cropsName.length,
      //   )),
    ));
  }
}

class _CropCard extends StatelessWidget {
  const _CropCard({
    Key? key,
    required this.crop,
  }) : super(key: key);

  final Crop crop;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        title: Text(
          crop.name,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          Navigator.pushNamed(context, '/cropInfo', arguments: crop);
        },
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: crop.iconUrl != null
              ? FadeInImage(
                  image: NetworkImage(crop.iconUrl!),
                  placeholder: const AssetImage('assets/images/icon.png'),
                )
              : const Image(image: AssetImage('assets/images/icon.png')),
        ),
      ),
    );
  }
}
