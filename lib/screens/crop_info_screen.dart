import 'package:flutter/material.dart';
import 'package:huertapp/helpers/helpers.dart';
import 'package:huertapp/models/models.dart';
import 'package:huertapp/themes/app_theme.dart';
import 'package:huertapp/widgets/widgets.dart';

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
        InfoCard(title: 'Cultivo', rows: [
          InfoRow(
              title: Text('Nombre', style: Theme.of(context).textTheme.titleLarge,),
              image: const Image(image: AssetImage('assets/images/icons/name.png')),
              value: Text(crop.name)),
          InfoRow(
              title: Text('Descripción', style: Theme.of(context).textTheme.titleLarge,),
              image: const Image(image: AssetImage('assets/images/icons/description.png')),
              value: Text(crop.description)),
        ]),
        const SizedBox(
          height: 10,
        ),
        InfoCard(title: 'Información del cultivo', rows: [
          InfoRow(
              title: Text('Recogida', style: Theme.of(context).textTheme.titleLarge,),
              image: const Image(image: AssetImage('assets/images/icons/harvest.png')),
              value: crop.harvest != null
                  ? Text(crop.harvest!)
                  : crop.harvestNotification > 30
                      ? Text("${DaysHelper.daysToMonths(crop.harvestNotification)} ${DaysHelper.daysToMonths(crop.harvestNotification) == 1 ? 'mes' : 'meses'}")
                      : Text("${crop.harvestNotification} ${crop.harvestNotification == 1 ? 'día' : 'días'}")),
          InfoRow(
              title: Text('Germ inación', style: Theme.of(context).textTheme.titleLarge,),
              image: const Image(image: AssetImage('assets/images/icons/germination.png')),
              value: crop.germination > 30
                  ? Text("${DaysHelper.daysToMonths(crop.germination)} ${DaysHelper.daysToMonths(crop.germination) == 1 ? 'mes' : 'meses'}")
                  : Text("${crop.germination} ${crop.germination == 1 ? 'día' : 'días'}")),
          InfoRow(
              title: Text('Regadío', style: Theme.of(context).textTheme.titleLarge,),
              image: const Image(image: AssetImage('assets/images/icons/watered.png')),
              value: Text(crop.watering)),
        ]),
        const SizedBox(
          height: 10,
        ),
        InfoCard(title: 'Temperatura', rows: [
          InfoRow(
              title: Text('Temperatura mínima', style: Theme.of(context).textTheme.titleLarge,),
              image: const Image(image: AssetImage('assets/images/icons/cool.png')),
              value: Text("${crop.minTemperature}º")),
          InfoRow(
              title: Text('Temperatura máxima', style: Theme.of(context).textTheme.titleLarge,),
              image: const Image(image: AssetImage('assets/images/icons/heat.png')),
              value: Text("${crop.maxTemperature}º")),
          InfoRow(
              title: Text('Temperatura óptima', style: Theme.of(context).textTheme.titleLarge,),
              image: const Image(image: AssetImage('assets/images/icons/thermometer.png')),
              value: Text("${crop.optimalTemperature}º")),
        ]),
        const SizedBox(
          height: 10,
        ),
        InfoCard(title: 'Sembrado', rows: [
          if (crop.sown != null)
            InfoRow(
                title: Text('Fecha de cultivo', style: Theme.of(context).textTheme.titleLarge,),
                image: const Image(image: AssetImage('assets/images/icons/calendar.png')),
                value: Text(crop.sown!)),
          if (crop.sownType != null)
            InfoRow(
                title: Text('Tipo de siembra', style: Theme.of(context).textTheme.titleLarge,),
                image: const Image(image: AssetImage('assets/images/icons/sown_type.png')),
                value: Text(crop.sownType!)),
          if (crop.seedsNumber != null)
            InfoRow(
                title: Text('Número de semillas', style: Theme.of(context).textTheme.titleLarge,),
                image: const Image(image: AssetImage('assets/images/icons/seeds.png')),
                value: Text("${crop.seedsNumber}")),
          if (crop.transplant != null || crop.transplantNotification != null)
            InfoRow(
                title: Text('Transplantar', style: Theme.of(context).textTheme.titleLarge,),
                image: const Image(image: AssetImage('assets/images/icons/transplant.png')),
                value: crop.transplant != null
                    ? Text(crop.transplant!)
                    : crop.transplantNotification! > 30
                        ? Text("${DaysHelper.daysToMonths(crop.transplantNotification!)} ${DaysHelper.daysToMonths(crop.transplantNotification!) == 1 ? 'mes' : 'meses'}")
                        : Text("${crop.transplantNotification!} días")),
          if (crop.depth != null)
            InfoRow(
                title: Text('Profundidad', style: Theme.of(context).textTheme.titleLarge,),
                image: const Image(image: AssetImage('assets/images/icons/depth.png')),
                value: Text("${crop.depth} cm")),
          if (crop.container != null)
            InfoRow(
                title: Text('Recipiente', style: Theme.of(context).textTheme.titleLarge,),
                image: const Image(image: AssetImage('assets/images/icons/container.png')),
                value: Text("${crop.container}l en adelante")),
          if (crop.plantingFrame != null)
            InfoRow(
                title: Text('Marco de plantación', style: Theme.of(context).textTheme.titleLarge,),
                image: const Image(image: AssetImage('assets/images/icons/planting_frame.png')),
                value: Text("${crop.plantingFrame} en adelante")),
        ]),
        const SizedBox(
          height: 10,
        ),
      ],
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
