import 'package:flutter/material.dart';
import 'package:huertapp/services/auth_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
            onPressed: () async {
              final authService =
                  Provider.of<AuthService>(context, listen: false);

              await authService.logOut();

              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Log out')),
      ),
    );
  }
}
