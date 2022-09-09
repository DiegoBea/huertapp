import 'package:flutter/material.dart';
import 'package:huertapp/helpers/helpers.dart';
import 'package:huertapp/providers/theme_provider.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PrintHelper.printInfo('Cargando...');
    return Scaffold(
      backgroundColor: ThemeProvider.primary,
      body: const Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}
