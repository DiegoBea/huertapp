import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:huertapp/helpers/helpers.dart';
import 'package:huertapp/models/models.dart';
import 'package:huertapp/providers/theme_provider.dart';
import 'package:huertapp/services/crops_service.dart';
import 'package:huertapp/services/notification_service.dart';
import 'package:huertapp/services/orchards_service.dart';
import 'package:huertapp/themes/app_theme.dart';
import 'package:huertapp/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrchardInfoScreen extends StatelessWidget {
  const OrchardInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Orchard orchard =
        ModalRoute.of(context)!.settings.arguments as Orchard;
    PrintHelper.printValue("${orchard.toMap()}");
    return Scaffold(
        appBar: orchard.imageUrl == null
            ? AppBar(
                title: Text(orchard.name),
                backgroundColor: ThemeProvider.primary,
              )
            : null,
        body: orchard.imageUrl == null
            ? Padding(
                padding: const EdgeInsets.all(15),
                child: _InfoColumn(orchard: orchard),
              )
            : _InfoWithImage(orchard: orchard));
  }
}

class _InfoWithImage extends StatelessWidget {
  const _InfoWithImage({
    Key? key,
    required this.orchard,
  }) : super(key: key);

  final Orchard orchard;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _Image(orchard: orchard),
        SliverList(
            delegate: SliverChildListDelegate([
          Container(
            padding: const EdgeInsets.all(20),
            child: _InfoColumn(orchard: orchard),
          )
        ])),
      ],
    );
  }
}

class _InfoColumn extends StatelessWidget {
  const _InfoColumn({
    Key? key,
    required this.orchard,
  }) : super(key: key);

  final Orchard orchard;

  @override
  Widget build(BuildContext context) {
    final orchardService = Provider.of<OrchardService>(context);
    final cropsService = Provider.of<CropsService>(context);
    final orchardNotification = NotificationService();
    return Column(
      children: [
        InfoCard(title: translate('titles.generalInfo'), rows: [
          InfoRow(
              title: Text(
                translate('titles.name'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              image: const Image(
                  image: AssetImage('assets/images/icons/name.png')),
              value: Text(orchard.name)),
          if (orchard.description != null)
            InfoRow(
                title: Text(
                  translate('titles.description'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                image: const Image(
                    image: AssetImage('assets/images/icons/description.png')),
                value: Text(orchard.description!)),
        ]),
        const SizedBox(
          height: 10,
        ),
        if (orchardService.relations.isNotEmpty)
        InfoCard(
          title: translate('titles.crops'),
          rows: orchardService.relations.where((element) => element.orchardUid == orchard.uid).toList().asMap().entries.map((e) {
            Crop crop = cropsService.crops
                .firstWhere((element) => element.uid == e.value.cropUid);

            OrchardNotification notification =
                OrchardNotification(relationUid: e.value.uid!, uid: '');

            DateFormat formatter = DateFormat("dd/MM/yyyy");
            notification.dateGermination = formatter.format(
                e.value.sownDate.add(Duration(days: e.value.germinationDays)));
            notification.dateHarvest = formatter.format(
                e.value.sownDate.add(Duration(days: e.value.harvestDays)));
            if (e.value.transplantDays != null) {
              notification.dateTransplant = formatter.format(e.value.sownDate
                  .add(Duration(days: e.value.transplantDays!)));
            }
            if (e.value.wateringIntervalDays != null) {
              notification.nextWatering = formatter.format(
                  orchardNotification.nextWatering(
                      e.value.sownDate, e.value.wateringIntervalDays!));
            }
            // TODO: Convertir en FadeInImage
            return InfoRow(
              image:
                  Image(image: NetworkImage(crop.iconUrl), fit: BoxFit.cover),
              title: Text(crop.name),
              value: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(translate('orchard.dateGermination', args: {"value": notification.dateGermination})),
                  Text(translate('orchard.dateHarvest', args: {"value": notification.dateHarvest})),
                  if (notification.dateTransplant != null)
                  Text(translate('orchard.dateTransplant', args: {"value": notification.dateTransplant})),
                  if (notification.nextWatering != null &&
                      notification.nextWatering!.isNotEmpty)
                       Text(translate('orchard.nextWatering', args: {"value": notification.nextWatering})),
                ],
              ),
            );
          }).toList(),
        ),
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
    required this.orchard,
  }) : super(key: key);

  final Orchard orchard;

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
            image: NetworkImage(orchard.imageUrl!),
            fit: BoxFit.fill),
      ),
    );
  }
}
