import 'package:flutter/material.dart';
import 'package:huertapp/services/auth_service.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
            onPressed: () async {
              final authService =
                  Provider.of<AuthService>(context, listen: false);

              await authService.logOut();

              Navigator.popAndPushNamed(context, '/login');

              // Navigator.pushAndRemoveUntil(context, '/login');
            },
            child: const Text('Log out')),
      ),
    );
  }
}
