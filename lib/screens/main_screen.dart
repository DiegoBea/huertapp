import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:huertapp/pages/pages.dart';
import 'package:huertapp/providers/theme_provider.dart';
import 'package:huertapp/shared_preferences/preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const CropsPage(),
    const OrchardPage(),
    const WeatherPage(),
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
          color: Preferences.isDarkMode ? Colors.black45 : Colors.white,
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
              rippleColor: Preferences.isDarkMode ? Colors.grey : Colors.grey[200]!,
              hoverColor: Preferences.isDarkMode ? Colors.grey : Colors.grey[100]!,
              gap: 8,
              activeColor: Preferences.isDarkMode ? Colors.green.shade700 : Colors.green,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Preferences.isDarkMode ? Colors.grey[500]! : Colors.grey[100]!,
              color: ThemeProvider.primary,
              tabs: [
                GButton(
                  icon: FontAwesomeIcons.carrot,
                  text: translate('titles.crops'),
                ),
                GButton(
                  icon: FontAwesomeIcons.seedling,
                  text: translate('gnav.orchards')
                ),
                GButton(
                  icon: FontAwesomeIcons.cloudSun,
                  text: translate('gnav.weather')
                ),
                GButton(
                  icon: FontAwesomeIcons.cog,
                  text: translate('gnav.settings')
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
    );
  }
}
