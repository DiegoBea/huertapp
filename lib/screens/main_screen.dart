import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:huertapp/pages/pages.dart';
import 'package:huertapp/services/services.dart';
import 'package:huertapp/themes/app_theme.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static final List<Widget> _widgetOptions = <Widget>[
    const CropsPage(),
    const OrchardPage(),
    const Text(
      'Search',
      style: optionStyle,
    ),
    const SettingsPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.green,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: AppTheme.primary,
              tabs: const [
                GButton(
                  icon: FontAwesomeIcons.carrot,
                  text: 'Cultivos',
                ),
                GButton(
                  icon: FontAwesomeIcons.seedling,
                  text: 'Huertos',
                ),
                GButton(
                  icon: FontAwesomeIcons.cloudSun,
                  text: 'Tiempo',
                ),
                GButton(
                  icon: FontAwesomeIcons.cog,
                  text: 'Ajustes',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
      // body: Center(
      //   child: MaterialButton(
      //       onPressed: () async {
      //         final authService =
      //             Provider.of<AuthService>(context, listen: false);

      //         await authService.logOut();

      //         Navigator.pushReplacementNamed(context, '/login');
      //       },
      //       child: const Text('Log out')),
      // ),
    );
  }
}
