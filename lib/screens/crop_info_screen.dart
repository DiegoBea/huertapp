import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:huertapp/helpers/helpers.dart';
import 'package:huertapp/models/models.dart';
import 'package:huertapp/providers/theme_provider.dart';
import 'package:huertapp/shared_preferences/preferences.dart';
import 'package:huertapp/widgets/widgets.dart';

class CropInfoScreen extends StatelessWidget {
  const CropInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Crop crop = ModalRoute.of(context)!.settings.arguments as Crop;
    PrintHelper.printValue("${crop.toMap()}");
    return Scaffold(
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
        InfoCard(title: translate('crop.title'), rows: [
          InfoRow(
              title: Text(
                translate('titles.name'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              image: const Image(
                  image: AssetImage('assets/images/icons/name.png')),
              value: Text(crop.name[Preferences.lang]!)),
          InfoRow(
              title: Text(
                translate('titles.description'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              image: const Image(
                  image: AssetImage('assets/images/icons/description.png')),
              value: Text(crop.description[Preferences.lang]!)),
        ]),
        const SizedBox(
          height: 10,
        ),
        InfoCard(title: translate('crop.info'), rows: [
          InfoRow(
              title: Text(
                translate('crop.harvest'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              image: const Image(
                  image: AssetImage('assets/images/icons/harvest.png')),
              value: crop.harvest != null
                  ? Text(crop.harvest![Preferences.lang]!)
                  : crop.harvestNotification > 30
                      ? Text(
                          "${DaysHelper.daysToMonths(crop.harvestNotification)} ${DaysHelper.daysToMonths(crop.harvestNotification) == 1 ? translate('titles.month') : translate('titles.months')}")
                      : Text(
                          "${crop.harvestNotification} ${crop.harvestNotification == 1 ? translate('titles.day') : translate('titles.days')}")),
          InfoRow(
              title: Text(
                translate('crop.germination'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              image: const Image(
                  image: AssetImage('assets/images/icons/germination.png')),
              value: crop.germination > 30
                  ? Text(
                      "${DaysHelper.daysToMonths(crop.germination)} ${DaysHelper.daysToMonths(crop.germination) == 1 ? translate('titles.month') : translate('titles.months')}")
                  : Text(
                      "${crop.germination} ${crop.germination == 1 ? translate('titles.day') : translate('titles.days')}")),
          InfoRow(
              title: Text(
                translate('crop.watering'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              image: const Image(
                  image: AssetImage('assets/images/icons/watered.png')),
              value: Text(crop.watering[Preferences.lang]!)),
        ]),
        const SizedBox(
          height: 10,
        ),
        InfoCard(title: translate('crop.temperature'), rows: [
          InfoRow(
              title: Text(
                translate('crop.min_temperature'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              image: const Image(
                  image: AssetImage('assets/images/icons/cool.png')),
              value: Text("${crop.minTemperature}º")),
          InfoRow(
              title: Text(
                translate('crop.max_temperature'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              image: const Image(
                  image: AssetImage('assets/images/icons/heat.png')),
              value: Text("${crop.maxTemperature}º")),
          InfoRow(
              title: Text(
                translate('crop.optimal_temperature'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              image: const Image(
                  image: AssetImage('assets/images/icons/thermometer.png')),
              value: Text("${crop.optimalTemperature}º")),
        ]),
        const SizedBox(
          height: 10,
        ),
        InfoCard(title: translate('crop.sown'), rows: [
          if (crop.sown != null)
            InfoRow(
                title: Text(
                  translate('crop.sownDate'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                image: const Image(
                    image: AssetImage('assets/images/icons/calendar.png')),
                value: Text(crop.sown![Preferences.lang]!)),
          if (crop.sownType != null)
            InfoRow(
                title: Text(
                  translate('crop.sownType'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                image: const Image(
                    image: AssetImage('assets/images/icons/sown_type.png')),
                value: Text(crop.sownType![Preferences.lang]!)),
          if (crop.seedsNumber != null)
            InfoRow(
                title: Text(
                  translate('crop.seedsNumber'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                image: const Image(
                    image: AssetImage('assets/images/icons/seeds.png')),
                value: Text("${crop.seedsNumber}")),
          if (crop.transplant != null || crop.transplantNotification != null)
            InfoRow(
                title: Text(
                  translate('crop.transplant'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                image: const Image(
                    image: AssetImage('assets/images/icons/transplant.png')),
                value: crop.transplant != null
                    ? Text(crop.transplant![Preferences.lang]!)
                    : crop.transplantNotification! > 30
                        ? Text(
                            "${DaysHelper.daysToMonths(crop.transplantNotification!)} ${DaysHelper.daysToMonths(crop.transplantNotification!) == 1 ? translate('titles.month') : translate('titles.months')}")
                        : Text(translate('crop.days',
                            args: {"value": crop.transplantNotification!}))),
          if (crop.depth != null)
            InfoRow(
                title: Text(
                  translate('crop.depth'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                image: const Image(
                    image: AssetImage('assets/images/icons/depth.png')),
                value: Text(
                    translate('crop.depthValue', args: {"value": crop.depth}))),
          if (crop.container != null)
            InfoRow(
                title: Text(
                  translate('crop.container'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                image: const Image(
                    image: AssetImage('assets/images/icons/container.png')),
                value: Text(translate('crop.containerValue', args: {
                  "value": crop.container
                }))), //"${crop.container}l en adelante"
          if (crop.plantingFrame != null)
            InfoRow(
                title: Text(
                  translate('crop.plantingFrame'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                image: const Image(
                    image:
                        AssetImage('assets/images/icons/planting_frame.png')),
                value: Text(translate('crop.plantingFrameValue', args: {
                  "value": crop.plantingFrame![Preferences.lang]!
                }))), //"${crop.plantingFrame} en adelante"
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
      backgroundColor: ThemeProvider.primary,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: FadeInImage(
            placeholder: const AssetImage('assets/videos/loading.gif'),
            image: NetworkImage(crop.imageUrl),
            fit: BoxFit.fill),
      ),
    );
  }
}
