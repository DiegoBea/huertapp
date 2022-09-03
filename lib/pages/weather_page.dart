import 'package:flutter/material.dart';
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
          children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://i.pinimg.com/originals/26/71/25/267125bb5d2996966de68e3c213e36aa.jpg'),
                      fit: BoxFit.cover,
                      opacity: 0.9)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  const Text('Valbona',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const Text('32º',
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const Text('Despejado',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 30),
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(children: const [
                        _DailyPredictionCard(),
                        _DailyPredictionCard(),
                        _DailyPredictionCard(),
                        _DailyPredictionCard(),
                        _DailyPredictionCard(),
                        _DailyPredictionCard(),
                        _DailyPredictionCard(),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(children: const [
                        _HourlyPredictionCard(),
                        _HourlyPredictionCard(),
                        _HourlyPredictionCard(),
                        _HourlyPredictionCard(),
                        _HourlyPredictionCard(),
                        _HourlyPredictionCard(),
                        _HourlyPredictionCard(),
                        _HourlyPredictionCard(),
                        _HourlyPredictionCard(),
                        _HourlyPredictionCard(),
                        _HourlyPredictionCard(),
                        _HourlyPredictionCard(),
                        _HourlyPredictionCard(),
                        _HourlyPredictionCard(),
                        _HourlyPredictionCard(),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 150),
                  const Text('Datos obtenidos de: © AEMET.',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.end),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HourlyPredictionCard extends StatelessWidget {
  const _HourlyPredictionCard({
    Key? key,
  }) : super(key: key);

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
                  const Text('12:00',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Text('32º',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                              SizedBox(
                          height: 20,
                          child: Image(
                            image: NetworkImage(
                                'https://cdn-icons-png.flaticon.com/512/169/169367.png'),
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

class _DailyPredictionCard extends StatelessWidget {
  const _DailyPredictionCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 130,
      child: Card(
        color: Colors.grey.withOpacity(0.09),
        child: Column(
          children: [
            const Text('Sábado',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 8),
            const SizedBox(
                height: 40,
                child: Image(
                  image: NetworkImage(
                      'https://cdn-icons-png.flaticon.com/512/169/169367.png'),
                  fit: BoxFit.cover,
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('14º',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue)),
                Text(' - ',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text('29º',
                    style: TextStyle(
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
                  children: const [
                    Image(
                      image: NetworkImage(
                          'https://cdn-icons-png.flaticon.com/512/263/263883.png'),
                      fit: BoxFit.cover,
                    ),
                    Text('0%',
                        style: TextStyle(
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