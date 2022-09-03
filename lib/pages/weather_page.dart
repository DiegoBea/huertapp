import 'package:flutter/material.dart';
import 'package:huertapp/helpers/helpers.dart';
import 'package:huertapp/models/models.dart';
import 'package:huertapp/services/services.dart';
import 'package:provider/provider.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weatherService = Provider.of<WeatherService>(context);
    return Scaffold(
      body: Container(
        child: PageView(
            children: weatherService.predictions.entries
                .map((e) => _WeatherBody(
                      prediction: e.value,
                      weatherService: weatherService,
                    ))
                .toList()),
      ),
    );
  }
}

class _WeatherBody extends StatelessWidget {
  const _WeatherBody({
    Key? key,
    required this.prediction,
    required this.weatherService,
  }) : super(key: key);

  final Map<String, dynamic> prediction;
  final WeatherService weatherService;

  @override
  Widget build(BuildContext context) {
    HourlyPrediction hourly = prediction["hourly"];
    DailyPrediction daily = prediction["daily"];
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                  'assets/images/weather/${hourly.isDay ? 'day' : 'night'}.jpg'),
              fit: BoxFit.cover,
              opacity: 0.9)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          Center(
            child: Text(hourly.nombre,
                style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
          Text('${hourly.currentTemperature}º',
              style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          Text(weatherService.getSkyType(hourly.currentSkyValue),
              style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 30),
          Container(
            margin: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: daily.prediccion.dia
                      .asMap()
                      .entries
                      .map((e) => _DailyPredictionCard(
                        skyValue: daily.skyValue[e.key],
                            prediction: e.value,
                            precipitation: daily.probPrecipitation[e.key],
                            day: e.key == 0
                                ? 'Hoy'
                                : e.key == 1
                                    ? 'Mañana'
                                    : DateHelper.getDynamicDayName(
                                        DateTime.now()
                                            .add(Duration(days: e.key))
                                            .weekday),
                          ))
                      .toList()),
            ),
          ),
          const SizedBox(height: 25),
          Container(
            margin: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: hourly.prediccion.dia
                      .asMap()
                      .entries
                      .map((e) => _HourlyPredictionCard(
                            prediccion: hourly,
                            dia: e.value,
                          ))
                      .toList()),
            ),
          ),
          const SizedBox(height: 150),
          const Text('Datos obtenidos de: © AEMET.',
              style: TextStyle(color: Colors.white), textAlign: TextAlign.end),
        ],
      ),
    );
  }
}

class _DailyPredictionCard extends StatelessWidget {
  const _DailyPredictionCard({
    Key? key,
    required this.prediction,
    required this.day,
    required this.precipitation, required this.skyValue,
  }) : super(key: key);

  final int precipitation;
  final DiaDiaria prediction;
  final String day;
  final String skyValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 130,
      child: Card(
        color: Colors.grey.withOpacity(0.09),
        child: Column(
          children: [
            Text(day,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 8),
            SizedBox(
                height: 40,
                child: Image(
                  image: AssetImage(
                      'assets/images/weather/icons/$skyValue.png'),
                  fit: BoxFit.cover,
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${prediction.temperatura.minima}º',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue)),
                const Text(' - ',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text('${prediction.temperatura.maxima}º',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red)),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Image(
                      image: NetworkImage(
                          'https://cdn-icons-png.flaticon.com/512/263/263883.png'),
                      fit: BoxFit.cover,
                    ),
                    Text('$precipitation%',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class _HourlyPredictionCard extends StatelessWidget {
  const _HourlyPredictionCard({
    Key? key,
    required this.dia,
    required this.prediccion,
  }) : super(key: key);

  final Dia dia;
  final HourlyPrediction prediccion;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      for (var i = 0; i < dia.temperatura.length; i++)
        _HourCard(
          skyValue: dia.estadoCielo[i].value,
          hour: int.parse(dia.temperatura[i].periodo),
          temperture: int.parse(dia.temperatura[i].value),
        ),
    ]);
  }
}

class _HourCard extends StatelessWidget {
  const _HourCard({
    Key? key,
    required this.hour,
    required this.temperture,
    required this.skyValue,
  }) : super(key: key);

  final int hour;
  final int temperture;
  final String skyValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          SizedBox(
            height: 100,
            width: 70,
            child: Card(
              color: Colors.grey.withOpacity(0.09),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('$hour:00',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('$tempertureº',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      SizedBox(
                          height: 20,
                          child: Image(
                            image: AssetImage(
                                'assets/images/weather/icons/$skyValue.png'),
                            fit: BoxFit.cover,
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class BackGround extends StatelessWidget {
  const BackGround({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color.fromARGB(255, 75, 225, 255),
        height: double.infinity,
        alignment: Alignment.topCenter,
        child: const Image(
          image: NetworkImage(
              'https://www.xtrafondos.com/wallpapers/vertical/cielo-con-nubes-2934.jpg'),
          fit: BoxFit.cover,
        ));
  }
}
