import 'package:flutter/material.dart';
import 'package:huertapp/helpers/helpers.dart';
import 'package:huertapp/screens/loading_screen.dart';
import 'package:huertapp/services/services.dart';
import 'package:huertapp/themes/app_theme.dart';
import 'package:provider/provider.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weatherService = Provider.of<WeatherService>(context);
    return weatherService.isloading
        ? const LoadingScreen()
        : SafeArea(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  DropdownButton(
                      onChanged: (value) {
                        PrintHelper.printValue("$value");
                      },
                      items: weatherService.provinces
                          .map<DropdownMenuItem<String>>((e) {
                        return DropdownMenuItem(
                            value: e.provCod, child: Text(e.provinceName));
                      }).toList()),
                  MaterialButton(
                    onPressed: () {},
                    color: AppTheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: const Text('Realizar petición'),
                  ),
                ],
              ),
            ),
          );
  }
}
