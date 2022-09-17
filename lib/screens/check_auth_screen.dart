import 'package:flutter/material.dart';
import 'package:huertapp/helpers/helpers.dart';
import 'package:huertapp/screens/loading_screen.dart';
import 'package:huertapp/screens/main_screen.dart';
import 'package:huertapp/screens/login_screen.dart';
import 'package:huertapp/services/services.dart';
import 'package:provider/provider.dart';

class ChechAuthScreen extends StatelessWidget {
  const ChechAuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtener el servicio de autenticación
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          // Leer el token de inicio de sesión
          future: authService.readToken(),
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData) {
              return const LoadingScreen();
            }

            // Si no se obtiene un token se envía al login
            if (snapshot.data == '') {
              Future.microtask(() {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const LoginScreen(),
                        transitionDuration: const Duration(seconds: 0)));
              });
              // En caso contrario se inicia sesión
            } else {
              Future.microtask(() {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const MainScreen(),
                        transitionDuration: const Duration(seconds: 0)));
              });
            }

            return Container();
          },
        ),
      ),
    );
  }
}
