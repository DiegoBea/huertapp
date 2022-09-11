import 'package:flutter/material.dart';
import 'package:huertapp/models/models.dart';
import 'package:huertapp/providers/theme_provider.dart';
import 'package:huertapp/screens/screens.dart';
import 'package:huertapp/services/crops_service.dart';
import 'package:huertapp/shared_preferences/preferences.dart';
import 'package:huertapp/widgets/card_item.dart';
import 'package:provider/provider.dart';

class CropsPage extends StatelessWidget {
  const CropsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cropsService = Provider.of<CropsService>(context);

    if (cropsService.isLoading) return const LoadingScreen();

    return SafeArea(
        child: Scaffold(
      backgroundColor: ThemeProvider.primary,
      body: Container(
        margin: const EdgeInsets.all(10),
        child: ListView(
          children: [
            for (Crop crop in cropsService.crops)
              CardItem(
                title: crop.name[Preferences.lang]!,
                onTap: () {
                  Navigator.pushNamed(context, '/cropInfo', arguments: crop);
                },
                leadingIcon: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: FadeInImage(
                    image: NetworkImage(crop.iconUrl),
                    placeholder: const AssetImage('assets/images/icon.png'),
                  ),
                ),
              ),
          ],
        ),
      ),
    ));
  }
}
