import 'package:flutter/material.dart';
import 'package:huertapp/helpers/helpers.dart';
import 'package:huertapp/services/services.dart';
import 'package:huertapp/themes/app_theme.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orchardService = Provider.of<OrchardService>(context);
    PrintHelper.printInfo('Cargando...');
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: const Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}
