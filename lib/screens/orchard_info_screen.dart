import 'package:flutter/material.dart';
import 'package:huertapp/helpers/helpers.dart';
import 'package:huertapp/models/models.dart';
import 'package:huertapp/themes/app_theme.dart';

class OrchardInfoScreen extends StatelessWidget {
  const OrchardInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Orchard orchard = ModalRoute.of(context)!.settings.arguments as Orchard;
    PrintHelper.printValue("${orchard.toMap()}");
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: orchard.imageUrl == null ? AppBar(
          title: Text(orchard.name),
          backgroundColor: AppTheme.primary,
        ) : null,
        body: orchard.imageUrl == null ? Padding(
          padding: const EdgeInsets.all(15),
          child: _InfoColumn(orchard: orchard),
        ) : _InfoWithImage(orchard: orchard));
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
    return Column(
      children: [
        _InfoCard(title: 'Información general', rows: [
          _InfoRow(
              title: 'Nombre',
              image: 'assets/images/icons/name.png',
              value: orchard.name),
              if (orchard.description != null)
          _InfoRow(
              title: 'Descripción',
              image: 'assets/images/icons/description.png',
              value: orchard.description!),
        ]),
        const SizedBox(
          height: 10,
        ),
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
    required this.orchard,
  }) : super(key: key);

  final Orchard orchard;

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
                image: NetworkImage(orchard.imageUrl!),
                fit: BoxFit.fill)
            ,
      ),
    );
  }
}
