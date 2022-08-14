import 'package:flutter/material.dart';
import 'package:huertapp/themes/app_theme.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: const Center(child: CircularProgressIndicator(
        color: Colors.white
      )),
    );
  }
}