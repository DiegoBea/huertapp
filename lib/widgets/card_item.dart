import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  const CardItem(
      {Key? key,
      required this.title,
      this.onTap,
      this.leadingIcon,
      this.trailingIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(3),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          onTap: onTap,
          leading: leadingIcon,
          trailing: trailingIcon,
        ),
      ),
    );
  }
}
