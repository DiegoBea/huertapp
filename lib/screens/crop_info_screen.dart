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
            _InfoRow(
                title: 'Recogida',
                image: 'assets/images/icons/harvest.png',
                value: crop.harvest > 30
                    ? "${DaysHelper.daysToMonths(crop.harvest)} ${DaysHelper.daysToMonths(crop.harvest) == 1 ? 'mes' : 'meses'}"
                    : "${crop.harvest} ${crop.harvest == 1 ? 'día' : 'días'}"),
            _InfoRow(
                title: 'Germinación',
                image: 'assets/images/icons/germination.png',
                value: crop.germination > 30
                    ? "${DaysHelper.daysToMonths(crop.germination)} ${DaysHelper.daysToMonths(crop.germination) == 1 ? 'mes' : 'meses'}"
                    : "${crop.germination} ${crop.germination == 1 ? 'día' : 'días'}"),
          if (crop.minWatering != null || crop.maxWatering != null)
            _InfoRow(
                title: 'Regadío',
                image: 'assets/images/icons/watered.png',
                // TODO: Probar en null
                value: "${crop.minWatering} - ${crop.maxWatering} días"),
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
        if (crop.seedbed)
          _InfoCard(title: 'Semillero', rows: [
            if (crop.seedbedSeedsNumber != null)
            _InfoRow(
                title: 'Número de semillas',
                image: 'assets/images/icons/seeds.png',
                value: "${crop.seedbedSeedsNumber}"),
            if (crop.seedbedTransplant != null)
              _InfoRow(
                  title: 'Transplantar',
                  image: 'assets/images/icons/transplant.png',
                  value: crop.seedbedTransplant! > 30
                      ? "${DaysHelper.daysToMonths(crop.seedbedTransplant!)} ${DaysHelper.daysToMonths(crop.seedbedTransplant!) == 1 ? 'mes' : 'meses'}"
                      : "${crop.seedbedTransplant!} días"),
            if (crop.seedbedDepth != null)
              _InfoRow(
                  title: 'Profundidad',
                  image: 'assets/images/icons/depth.png',
                  value: "${crop.seedbedDepth} cm"),
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
      // TODO: Buscar gif de carga
      flexibleSpace: FlexibleSpaceBar(
        background: crop.imageUrl != null
            ? FadeInImage(
                placeholder: const NetworkImage(
                    'https://i.pinimg.com/originals/e8/88/d4/e888d4feff8fd5ff63a965471a94b874.gif'),
                image: NetworkImage(crop.imageUrl),
                fit: BoxFit.cover)
            : const FadeInImage(
                placeholder: NetworkImage(
                    'https://i.pinimg.com/originals/e8/88/d4/e888d4feff8fd5ff63a965471a94b874.gif'),
                image: AssetImage('assets/images/icon.png'),
                fit: BoxFit.cover),
      ),
    );
  }
}
