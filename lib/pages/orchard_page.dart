import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:huertapp/helpers/helpers.dart';
import 'package:huertapp/models/orchard.dart';
import 'package:huertapp/models/orchard_crop_relation.dart';
import 'package:huertapp/providers/theme_provider.dart';
import 'package:huertapp/screens/screens.dart';
import 'package:huertapp/services/services.dart';
import 'package:huertapp/shared_preferences/preferences.dart';
import 'package:huertapp/widgets/widgets.dart';
import 'package:provider/provider.dart';

class OrchardPage extends StatelessWidget {
  const OrchardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orchardService = Provider.of<OrchardService>(context);

    if (orchardService.isLoading) return const LoadingScreen();

    return SafeArea(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            orchardService.isEditing = false;
            orchardService.selectedOrchard = Orchard(
              name: '',
              owners: [],
            );
            orchardService.selectedImageUrl = null;
            orchardService.selectedRelations = [];
            Navigator.pushNamed(context, '/orchardForm');
          },
          backgroundColor: ThemeProvider.withoutColor,
          child: Icon(
            Icons.add,
            color: ThemeProvider.primary,
          )),
      backgroundColor: ThemeProvider.primary,
      body: Container(
        margin: const EdgeInsets.all(10),
        child: ListView(
          children: [
            for (Orchard orchard in orchardService.orchards)
              FocusedMenuHolder(
                menuWidth: MediaQuery.of(context).size.width * 0.50,
                blurSize: 5.0,
                menuItemExtent: 45,
                menuBoxDecoration: BoxDecoration(
                    color: ThemeProvider.withoutColor,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(25.0))),
                duration: const Duration(milliseconds: 300),
                animateMenuItems: true,
                blurBackgroundColor: Colors.black54,
                openWithTap: true,
                menuOffset: 10.0,
                bottomOffsetHeight: 80.0,
                menuItems: [
                  FocusedMenuItem(
                      backgroundColor: ThemeProvider.withoutColor,
                      title: Text(translate('titles.info'),
                          style: TextStyle(
                              color: Preferences.isDarkMode
                                  ? Colors.white
                                  : Colors.black)),
                      trailingIcon: Icon(FontAwesomeIcons.info,
                          color: ThemeProvider.primary),
                      onPressed: () {
                        Navigator.pushNamed(context, '/orchardInfo',
                            arguments: orchard);
                      }),
                  if (orchard.owner)
                    FocusedMenuItem(
                        backgroundColor: ThemeProvider.withoutColor,
                        title: Text(
                          translate('titles.edit'),
                          style: TextStyle(
                              color: Preferences.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        trailingIcon: Icon(FontAwesomeIcons.edit,
                            color: ThemeProvider.primary),
                        onPressed: () {
                          List<OrchardCropRelation> relations = orchardService
                              .relations
                              .where((element) =>
                                  element.orchardUid == orchard.uid)
                              .toList();
                          orchardService.selectedRelations =
                              orchardService.cloneListRelations(relations);
                          orchardService.selectedOrchard = orchard.copy();
                          orchardService.isEditing = true;
                          orchardService.selectedImageUrl = orchard.imageUrl;
                          Navigator.pushNamed(context, '/orchardForm');
                        }),
                  if (orchard.owner)
                    FocusedMenuItem(
                        backgroundColor: ThemeProvider.withoutColor,
                        title: Text(
                          translate('titles.share'),
                          style: TextStyle(
                              color: Preferences.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        trailingIcon: Icon(
                          Icons.share,
                          color: ThemeProvider.primary,
                        ),
                        onPressed: () {
                          PrintHelper.printInfo("TODO: Añadir shareView");
                        }),
                  FocusedMenuItem(
                      backgroundColor: ThemeProvider.withoutColor,
                      title: Text(
                        translate('titles.delete'),
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                      trailingIcon: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  scrollable: true,
                                  elevation: 5,
                                  // content: Text(
                                  //     '¿Deseas eliminar "${orchard.name}"? Esta acción es irreversible',
                                  //     style: const TextStyle(fontSize: 15)),
                                  content: Text(
                                      translate('feedback.removeOrchard',
                                          args: {"name": orchard.name}),
                                      style: const TextStyle(fontSize: 15)),
                                  title: Center(
                                      // child: Text('Eliminar ${orchard.name}')),
                                      child: Text(translate(
                                          'feedback.removeItem',
                                          args: {"name": orchard.name}))),
                                  actions: [
                                    MaterialButton(
                                      onPressed: () {
                                        orchardService.deleteOrchard(orchard);
                                        Navigator.pop(context);
                                      },
                                      color: Colors.red,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Text(translate('titles.delete'),
                                          style:
                                              const TextStyle(color: Colors.white)),
                                    ),
                                    MaterialButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      color: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: const Text('Cancelar',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ));
                      }),
                ],
                onPressed: () {},
                child: CardItem(
                  title: orchard.name,
                  description: orchard.description,
                  imageUrl: orchard.imageUrl,
                ),
              ),
          ],
        ),
      ),
    ));
  }
}
