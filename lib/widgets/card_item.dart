import 'package:flutter/material.dart';
import 'package:huertapp/themes/app_theme.dart';

class CardItem extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final String? imageUrl;
  final String? description;

  const CardItem(
      {Key? key,
      required this.title,
      this.onTap,
      this.leadingIcon,
      this.trailingIcon,
      this.imageUrl,
      this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return imageUrl == null
        ? _CardWithoutImage(
            title: title,
            description: description,
            onTap: onTap,
            leadingIcon: leadingIcon,
            trailingIcon: trailingIcon)
        : _CardWithImage(
            imageUrl: imageUrl,
            size: size,
            title: title,
            description: description);
  }
}

class _CardWithImage extends StatelessWidget {
  const _CardWithImage({
    Key? key,
    required this.imageUrl,
    required this.size,
    required this.title,
    required this.description,
  }) : super(key: key);

  final String? imageUrl;
  final Size size;
  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Card(
                elevation: 18.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.all(8.0),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/videos/loading.gif'),
                  image: NetworkImage(imageUrl!),
                  fit: BoxFit.cover,
                  height: size.height * 0.25,
                  width: size.width * 0.9,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 7.2,
                right: 7,
                child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25))),
                    child: ListTile(
                      title: Text(title, style: AppTheme.title2),
                      subtitle: description != null ? Text(description!) : null,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardWithoutImage extends StatelessWidget {
  const _CardWithoutImage({
    Key? key,
    required this.title,
    required this.description,
    required this.onTap,
    required this.leadingIcon,
    required this.trailingIcon,
  }) : super(key: key);

  final String title;
  final String? description;
  final Function()? onTap;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        subtitle: description != null ? Text(description!) : null,
        onTap: onTap,
        leading: leadingIcon,
        trailing: trailingIcon,
      ),
    );
  }
}
