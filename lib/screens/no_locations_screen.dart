import 'package:flutter/material.dart';
import 'package:huertapp/providers/theme_provider.dart';
import 'package:huertapp/themes/app_theme.dart';

class NoLocationsScreen extends StatelessWidget {
   
  const NoLocationsScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.primary,
      body:Center(
         child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
           children: const [
            SizedBox(height: 200, child: Image(image: AssetImage('assets/images/no_location.png'), fit: BoxFit.cover)),
            Text('Aún no has añadido ninguna ubicación, pulse "+" para añadir', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 25)),
           ],
         ),
      ),
    );
  }
}