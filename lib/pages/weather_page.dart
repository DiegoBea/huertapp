import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:huertapp/helpers/helpers.dart';
import 'package:huertapp/models/models.dart';
import 'package:huertapp/screens/screens.dart';
import 'package:huertapp/services/services.dart';
import 'package:huertapp/themes/app_theme.dart';
import 'package:huertapp/widgets/card_item.dart';
import 'package:provider/provider.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  Widget build(BuildContext context) {
    final weatherService = Provider.of<WeatherService>(context);
    final userService = Provider.of<UserService>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) => _ProvinceDialog(
                    weatherService: weatherService, userService: userService));
          },
          backgroundColor: Colors.white,
          child: weatherService.isProvincesloading
              ? CircularProgressIndicator(color: AppTheme.primary)
              : Icon(
                  Icons.add,
                  color: AppTheme.primary,
                )),
      body: weatherService.isloading
          ? const LoadingScreen()
          : WeatherService.predictions.isEmpty
              ? const NoLocationsScreen()
              : PageView.builder(
                  itemCount: WeatherService.predictions.entries.length,
                  itemBuilder: (context, index) => _WeatherBody(
                      userService: userService,
                      prediction: WeatherService.predictions.entries
                          .toList()[index]
                          .value,
                      weatherService: weatherService,
                      code: WeatherService.predictions.entries
                          .toList()[index]
                          .key)),
    );
  }
}

class _ProvinceDialog extends StatelessWidget {
  const _ProvinceDialog({
    Key? key,
    required this.weatherService,
    required this.userService,
  }) : super(key: key);

  final WeatherService weatherService;
  final UserService userService;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      scrollable: true,
      elevation: 5,
      content: SizedBox(
        height: 300,
        child: SingleChildScrollView(
          child: Column(
            children: weatherService.provinces
                .map((e) => CardItem(
                      title: e.provinceName,
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (_) => _TownshipDialog(
                                province: e,
                                userService: userService,
                                weatherService: weatherService));
                      },
                    ))
                .toList(),
          ),
        ),
      ),
      title: const Center(child: Text('Selecciona una provincia')),
    );
  }
}

class _TownshipDialog extends StatelessWidget {
  const _TownshipDialog({
    Key? key,
    required this.userService,
    required this.weatherService,
    required this.province,
  }) : super(key: key);

  final UserService userService;
  final WeatherService weatherService;
  final Province province;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      scrollable: true,
      elevation: 5,
      content: SizedBox(
        height: 300,
        child: SingleChildScrollView(
          child: Column(
            children: province.townships
                .asMap()
                .entries
                .map((e) => CardItem(
                      title: e.value.nombre,
                      onTap: () {
                        Navigator.pop(context);
                        UserService.user!.weatherLocations != null
                            ? UserService.user!.weatherLocations!
                                .add(e.value.code)
                            : UserService.user!.weatherLocations = [
                                e.value.code
                              ];
                        userService.updateUser(UserService.user!);
                        weatherService.getWeather(e.value.code);
                      },
                    ))
                .toList(),
          ),
        ),
      ),
      title: const Center(child: Text('Selecciona un municipio')),
    );
  }
}

class _WeatherBody extends StatefulWidget {
  const _WeatherBody({
    Key? key,
    required this.prediction,
    required this.weatherService,
    required this.code,
    required this.userService,
  }) : super(key: key);

  final Map<String, dynamic> prediction;
  final String code;
  final WeatherService weatherService;
  final UserService userService;

  @override
  State<_WeatherBody> createState() => _WeatherBodyState();
}

class _WeatherBodyState extends State<_WeatherBody> {
  @override
  Widget build(BuildContext context) {
    HourlyPrediction hourly = widget.prediction["hourly"];
    DailyPrediction daily = widget.prediction["daily"];
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
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Container(
                margin: const EdgeInsets.all(15),
                child: MaterialButton(
                  onPressed: () {
                    WeatherService.predictions.removeWhere(
                      (key, value) => key == widget.code,
                    );
                    UserService.user!.weatherLocations
                        ?.removeWhere((element) => element == widget.code);
                    widget.userService.updateUser(UserService.user!);
                  },
                  child: Row(children: const [
                    Text('Eliminar  ',
                        style: TextStyle(color: Colors.red, fontSize: 17)),
                    Icon(
                      FontAwesomeIcons.trash,
                      size: 17,
                      color: Colors.red,
                    )
                  ]),
                ))
          ]),
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
          Text(widget.weatherService.getSkyType(hourly.currentSkyValue),
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
          const SizedBox(height: 100),
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
    required this.precipitation,
    required this.skyValue,
  }) : super(key: key);

  final int precipitation;
  final DiaDiaria prediction;
  final String day;
  final String skyValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      height: 185,
      width: 150,
      child: Card(
        color: Colors.grey.withOpacity(0.09),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(day,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 10),
            SizedBox(
                height: 40,
                child: Image(
                  image:
                      AssetImage('assets/images/weather/icons/$skyValue.png'),
                  fit: BoxFit.cover,
                )),
            const SizedBox(height: 10),
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
            const SizedBox(height: 10),
            SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Image(
                      image: AssetImage('assets/images/weather/icons/25.png'),
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
            width: 80,
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
                          height: 25,
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
