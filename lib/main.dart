import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huertapp/screens/screens.dart';
import 'package:huertapp/services/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]); // Bloquear rotación de pantalla

  await Firebase.initializeApp(); // Iniciar Firebase
  NotificationService();
  runApp(const AppState());
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
        ChangeNotifierProvider(create: (_) => WeatherService(), lazy: false,),
        ChangeNotifierProvider(create: (_) => UserService(), lazy: false,),
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
    );
  }
}
