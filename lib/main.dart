import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:huertapp/providers/theme_provider.dart';
import 'package:huertapp/screens/screens.dart';
import 'package:huertapp/services/services.dart';
import 'package:huertapp/shared_preferences/preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]); // Bloquear rotación de pantalla

  // Cargar las sharedPreferences
  await Preferences.init();

  // Inicializar i18n
  var delegate = await LocalizationDelegate.create(
      fallbackLocale: 'es', supportedLocales: ['es']);

  initializeDateFormatting('es');

  await Firebase.initializeApp(); // Iniciar Firebase
  NotificationService();
  runApp(LocalizedApp(delegate, const AppState()));
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => CropsService()),
        ChangeNotifierProvider(create: (_) => OrchardService()),
        ChangeNotifierProvider(create: (_) => ImageService()),
        ChangeNotifierProvider(
          create: (_) => WeatherService(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => UserService(),
          lazy: false,
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider(isDarkMode: Preferences.isDarkMode))
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Huertapp',
      initialRoute: '/checkLogin',
      routes: {
        '/checkLogin': (_) => const ChechAuthScreen(),
        '/main': (_) => const MainScreen(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/cropInfo': (_) => const CropInfoScreen(),
        '/orchardForm': (_) => const OrchardFormScreen(),
        '/orchardInfo': (_) => const OrchardInfoScreen(),
      },
      theme: Provider.of<ThemeProvider>(context).currentTheme,
    );
  }
}
