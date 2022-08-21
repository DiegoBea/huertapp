import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:huertapp/helpers/helpers.dart';
import 'package:huertapp/models/models.dart';
import 'package:huertapp/screens/screens.dart';
import 'package:huertapp/services/services.dart';
import 'package:huertapp/themes/app_theme.dart';
import 'package:huertapp/widgets/widgets.dart';
import 'package:provider/provider.dart';

class OrchardPage extends StatelessWidget {
  const OrchardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrchardService(),
      child: const OrchardBody(),
    );
  }
}

class OrchardBody extends StatelessWidget {
  const OrchardBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orchardService = Provider.of<OrchardService>(context);

    if (orchardService.isLoading) return const LoadingScreen();

    return SafeArea(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/orchardForm');
          },
          backgroundColor: Colors.white,
          child: Icon(
            Icons.add,
            color: AppTheme.primary,
          )),
      backgroundColor: AppTheme.primary,
      body: Container(
        margin: const EdgeInsets.all(10),
        child: ListView(
          children: [
            for (Orchard orchard in orchardService.orchards)
              CardItem(
                title: orchard.name,
                onTap: () {
                  Navigator.pushNamed(context, '/orchardForm', arguments: orchard);
                  PrintHelper.printValue(orchard.name);
                },
                trailingIcon: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/orchardForm',
                          arguments: orchard);
                    },
                    icon: Icon(
                      FontAwesomeIcons.edit,
                      color: AppTheme.primary,
                    )),
              ),
          ],
        ),
      ),
    ));
  }
}
