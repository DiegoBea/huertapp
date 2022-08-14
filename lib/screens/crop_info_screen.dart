import 'package:flutter/material.dart';
import 'package:huertapp/models/Crop.dart';
import 'package:huertapp/themes/app_theme.dart';

class CropInfoScreen extends StatelessWidget {
  const CropInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Crop crop = ModalRoute.of(context)!.settings.arguments as Crop;
    print(crop.toJson());
    return Scaffold(
        body: CustomScrollView(
          slivers: [
            _Image(crop: crop),
            SliverList(delegate: SliverChildListDelegate([
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text('Cultivo', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ])),
          ],
        ));
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
                image: NetworkImage(crop.imageUrl!),
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
