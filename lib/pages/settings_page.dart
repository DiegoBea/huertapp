import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:huertapp/models/firestore_user.dart';
import 'package:huertapp/providers/theme_provider.dart';
import 'package:huertapp/services/services.dart';
import 'package:huertapp/shared_preferences/preferences.dart';
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
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    List<Map> langJson = [
      {
        'value': 'es',
        'image': 'assets/images/langs/es.png',
        'text': translate('langs.es')
      },
      {
        'value': 'en_UK',
        'image': 'assets/images/langs/en.png',
        'text': translate('langs.en')
      },
      {
        'value': 'fr',
        'image': 'assets/images/langs/fr.png',
        'text': translate('langs.fr')
      },
    ];

    return Scaffold(
      backgroundColor: ThemeProvider.primary,
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
                  Container(
                    margin: const EdgeInsets.all(15),
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
                        Row(
                          children: [
                            Expanded(
                              child:
                                Text(
                                  user.name,
                                  style: const TextStyle(
                                      fontSize: 25, fontWeight: FontWeight.bold),
                                ),
                            ),
                            IconButton(onPressed: (){}, icon: const Icon(FontAwesomeIcons.edit))
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          user.email,
                          style:
                              const TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Container(
                    margin: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          translate('titles.darkmode'),
                          style: const TextStyle(fontSize: 17),
                        ),
                        // Switch para cambiar el valor
                        Switch.adaptive(
                          // El valor por defecto es el de las sharedPreferences
                          value: Preferences.isDarkMode,
                          onChanged: (value) {
                            // se activa/desactiva el modo oscuro
                            // dependiendo de cual esté activo
                            Preferences.isDarkMode = value;

                            value
                                ? themeProvider.setDarkMode()
                                : themeProvider.setLightMode();
                            
                            // Actualizar el estado de los widgets
                            setState(() {});
                          },
                          activeColor: ThemeProvider.primary,
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  Container(
                    margin: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          translate('titles.lang'),
                          style: const TextStyle(fontSize: 17),
                        ),
                        DropdownButtonHideUnderline(
                            child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<dynamic>(
                            menuMaxHeight: 200,
                            items: List.generate(
                                langJson.length,
                                (index) => DropdownMenuItem(
                                      value: langJson[index]["value"],
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(translate(
                                              langJson[index]["text"])),
                                          Image(
                                            image: AssetImage(
                                                langJson[index]['image']),
                                            fit: BoxFit.cover,
                                            width: 25,
                                          ),
                                        ],
                                      ),
                                    )),
                            onChanged: (value) {
                              if (value != null) Preferences.lang = value;
                              changeLocale(context, Preferences.lang);
                              setState(() {});
                            },
                            value: Preferences.lang,
                            hint: Text(translate('hints.lang')),
                          ),
                        ))
                      ],
                    ),
                  ),
                  Container(
                    width: 200,
                    height: MediaQuery.of(context).size.height * 0.2,
                    margin: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Colors.red,
                            onPressed: () async {
                              final authService = Provider.of<AuthService>(
                                  context,
                                  listen: false);

                              await authService.logOut();

                              // ignore: use_build_context_synchronously
                              Navigator.popAndPushNamed(context, '/login');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(translate('titles.logout'),
                                    style:
                                        const TextStyle(color: Colors.white)),
                                const SizedBox(
                                  width: 20,
                                ),
                                const Icon(Icons.logout, color: Colors.white),
                              ],
                            )),
                      ],
                    ),
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
