import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:huertapp/providers/theme_provider.dart';

class NoLocationsScreen extends StatelessWidget {
   
  const NoLocationsScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.primary,
      body:Center(
         child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
           children: [
            const SizedBox(height: 100, child: Image(image: AssetImage('assets/images/no_location.png'), fit: BoxFit.cover)),
            Text(translate('feedback.noLocation'), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 25)), //  
           ],
         ),
      ),
    );
  }
}