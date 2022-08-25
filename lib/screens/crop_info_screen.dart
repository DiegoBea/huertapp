import 'package:flutter/material.dart';
import 'package:huertapp/helpers/helpers.dart';
import 'package:huertapp/models/models.dart';
import 'package:huertapp/themes/app_theme.dart';

class CropInfoScreen extends StatelessWidget {
  const CropInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Crop crop = ModalRoute.of(context)!.settings.arguments as Crop;
    PrintHelper.printValue("${crop.toMap()}");
    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            _Image(crop: crop),
            SliverList(
                delegate: SliverChildListDelegate([
              Container(
                padding: const EdgeInsets.all(20),
                child: _InfoColumn(crop: crop),
              )
            ])),
          ],
        ));
  }
}

class _InfoColumn extends StatelessWidget {
  const _InfoColumn({
    Key? key,
    required this.crop,
  }) : super(key: key);

  final Crop crop;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InfoCard(title: 'Cultivo', rows: [
          _InfoRow(
              title: 'Nombre',
              image: 'assets/images/icons/name.png',
              value: crop.name),
          _InfoRow(
              title: 'Descripción',
              image: 'assets/images/icons/description.png',
              value: crop.description),
        ]),
        const SizedBox(
          height: 10,
        ),
        _InfoCard(title: 'Información del cultivo', rows: [
          _InfoRow(
              title: 'Recogida',
              image: 'assets/images/icons/harvest.png',
              value: crop.harvest != null
                  ? crop.harvest!
                  : crop.harvestNotification > 30
                      ? "${DaysHelper.daysToMonths(crop.harvestNotification)} ${DaysHelper.daysToMonths(crop.harvestNotification) == 1 ? 'mes' : 'meses'}"
                      : "${crop.harvestNotification} ${crop.harvestNotification == 1 ? 'día' : 'días'}"),
          _InfoRow(
              title: 'Germinación',
              image: 'assets/images/icons/germination.png',
              value: crop.germination > 30
                  ? "${DaysHelper.daysToMonths(crop.germination)} ${DaysHelper.daysToMonths(crop.germination) == 1 ? 'mes' : 'meses'}"
                  : "${crop.germination} ${crop.germination == 1 ? 'día' : 'días'}"),
          _InfoRow(
              title: 'Regadío',
              image: 'assets/images/icons/watered.png',
              value: crop.watering),
        ]),
        const SizedBox(
          height: 10,
        ),
        _InfoCard(title: 'Temperatura', rows: [
          _InfoRow(
              title: 'Temperatura mínima',
              image: 'assets/images/icons/cool.png',
              value: "${crop.minTemperature}º"),
          _InfoRow(
              title: 'Temperatura máxima',
              image: 'assets/images/icons/heat.png',
              value: "${crop.maxTemperature}º"),
          _InfoRow(
              title: 'Temperatura óptima',
              image: 'assets/images/icons/thermometer.png',
              value: "${crop.optimalTemperature}º"),
        ]),
        const SizedBox(
          height: 10,
        ),
        _InfoCard(title: 'Sembrado', rows: [
          if (crop.sown != null)
            _InfoRow(
                title: 'Fecha de cultivo',
                image: 'assets/images/icons/calendar.png',
                value: crop.sown!),
          if (crop.sownType != null)
            _InfoRow(
                title: 'Tipo de siembra',
                image: 'assets/images/icons/sown_type.png',
                value: crop.sownType!),
          if (crop.seedsNumber != null)
            _InfoRow(
                title: 'Número de semillas',
                image: 'assets/images/icons/seeds.png',
                value: "${crop.seedsNumber}"),
          if (crop.transplant != null || crop.transplantNotification != null)
            _InfoRow(
                title: 'Transplantar',
                image: 'assets/images/icons/transplant.png',
                value: crop.transplant != null
                    ? crop.transplant!
                    : crop.transplantNotification! > 30
                        ? "${DaysHelper.daysToMonths(crop.transplantNotification!)} ${DaysHelper.daysToMonths(crop.transplantNotification!) == 1 ? 'mes' : 'meses'}"
                        : "${crop.transplantNotification!} días"),
          if (crop.depth != null)
            _InfoRow(
                title: 'Profundidad',
                image: 'assets/images/icons/depth.png',
                value: "${crop.depth} cm"),
          if (crop.container != null)
            _InfoRow(
                title: 'Recipiente',
                image: 'assets/images/icons/container.png',
                value: "${crop.container}l en adelante"),
          if (crop.plantingFrame != null)
            _InfoRow(
                title: 'Marco de plantación',
                image: 'assets/images/icons/planting_frame.png',
                value: "${crop.plantingFrame} en adelante"),
        ]),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<_InfoRow> rows;

  const _InfoCard({
    Key? key,
    required this.title,
    required this.rows,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 15,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headline5,
              ),
              for (_InfoRow row in rows)
                Column(
                  children: [
                    const Divider(thickness: 1),
                    row,
                  ],
                ),
            ],
          ),
        ));
  }
}

class _InfoRow extends StatelessWidget {
  final String image;
  final String title;
  final String value;

  const _InfoRow({
    Key? key,
    required this.image,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Image(image: AssetImage(image))),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      subtitle: Text(value),
    );
  }
}

class _Image extends StatelessWidget {
  const _Image({
    Key? key,
    required this.crop,
  }) : super(key: key);

  final Crop crop;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppTheme.primary,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: FadeInImage(
                placeholder: const AssetImage('assets/videos/loading.gif'),
                image: NetworkImage(crop.imageUrl),
                fit: BoxFit.fill)
            ,
      ),
    );
  }
}
