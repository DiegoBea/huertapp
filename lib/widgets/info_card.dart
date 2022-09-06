import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final List<InfoRow> rows;

  const InfoCard({
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
              for (InfoRow row in rows)
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

class InfoRow extends StatelessWidget {
  final Image image;
  final Widget title;
  final Widget value;

  const InfoRow({
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
          child: image),
      title: title,
      subtitle: value,
    );
  }
}