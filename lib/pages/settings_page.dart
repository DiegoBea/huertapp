import 'package:flutter/material.dart';
import 'package:huertapp/models/firestore_user.dart';
import 'package:huertapp/services/services.dart';
import 'package:huertapp/shared_preferences/preferences.dart';
import 'package:huertapp/themes/app_theme.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    FirestoreUser user = UserService.user!.copy();

    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  user.photoUrl != null
                      ? CircleAvatar(
                          radius: 45,
                          backgroundImage: NetworkImage(user.photoUrl!),
                        )
                      : const CircleAvatar(
                          radius: 45,
                          backgroundImage: AssetImage(
                              'assets/images/default_profile_icon.png'),
                        ),
                  const SizedBox(height: 20),
                  Text(
                    user.name,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    user.email,
                    style: const TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Modo oscuro',
                        style: TextStyle(fontSize: 17),
                      ),
                      Switch.adaptive(
                        value: Preferences.isDarkMode,
                        onChanged: (value) {
                          Preferences.isDarkMode = value;
                          setState(() {});
                        },
                        activeColor: AppTheme.primary,
                      )
                    ],
                  ),
                  Container(
                    width: 150,
                    child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.red,
                        onPressed: () async {
                          final authService =
                              Provider.of<AuthService>(context, listen: false);

                          await authService.logOut();

                          Navigator.popAndPushNamed(context, '/login');

                          // Navigator.pushAndRemoveUntil(context, '/login');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Cerrar sesión',
                                style: TextStyle(color: Colors.white)),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(Icons.logout, color: Colors.white),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogOutByutton extends StatelessWidget {
  const _LogOutByutton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        onPressed: () async {
          final authService = Provider.of<AuthService>(context, listen: false);

          await authService.logOut();

          Navigator.popAndPushNamed(context, '/login');

          // Navigator.pushAndRemoveUntil(context, '/login');
        },
        child: const Text('Log out'));
  }
}
