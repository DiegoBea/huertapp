import 'package:flutter/material.dart';
import 'package:huertapp/models/models.dart';
import 'package:huertapp/services/services.dart';
import 'package:provider/provider.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});
  @override
  Widget build(BuildContext context) {
    final weatherService = Provider.of<WeatherService>(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                for (Aemet prediction in weatherService.predictions)
                  Card(
                    margin: const EdgeInsets.all(8),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            Text('Municipio: ${prediction.nombre}'),
                          ],
                        ),
                        const Divider(thickness: 2),
                        Column(
                          children: [
                            const Text('Temperaturas máximas y mínimas: '),
                            const SizedBox(height: 10),
                            Column(
                              children:
                                  prediction.tempMinMaxValues.entries.map((e) {
                                return Text(
                                    "${e.key}: Mínima: ${e.value[0]} | Máxima: ${e.value[1]}");
                              }).toList(),
                            ),
                          ],
                        ),
                        const Divider(thickness: 2),
                        Column(
                          children: [
                            const Text('Estado cielo: '),
                            const SizedBox(height: 10),
                            Column(
                                children:
                                    prediction.skyStateValues.entries.map((e) {
                              return Container(
                                margin: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Text(e.key),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: e.value.values
                                              .asMap()
                                              .entries
                                              .map((skyValue) {
                                                return Text("Hora: ${skyValue.key}:00");
                                              })
                                              .toList(),
                                        ),
                                        // Column(
                                        //   children: e.value.imageUrl
                                        //       .asMap()
                                        //       .entries
                                        //       .map((image) => Image(
                                        //           image: NetworkImage(image.value)))
                                        //       .toList(),
                                        // ),
                                        Column(
                                          children: e.value.description
                                              .asMap()
                                              .entries
                                              .map((description) => Text(description.value))
                                              .toList(),
                                        ),
                                        Column(
                                          children: e.value.values
                                              .asMap()
                                              .entries
                                              .map((skyValue) => Text("Valor: ${skyValue.value}"))
                                              .toList(),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            }).toList()),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class WeatherPage extends StatelessWidget {
//   const WeatherPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final weatherService = Provider.of<WeatherService>(context);
//     final township = weatherService.provinces[43].townships[213];
//     weatherService.getWeather(township.code);
//     return weatherService.isloading
//         ? const LoadingScreen()
//         : Scaffold(
//             body: Container(),
//           );
//   }
// }
