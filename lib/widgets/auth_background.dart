import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(169, 180, 254, 219),
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          const _BackgroundImage(),
          child,
        ],
      ),
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: double.infinity,
      height: size.height * 0.35,
      child: const Image(
          image: AssetImage("assets/images/background_login.jpg"),
          fit: BoxFit.cover),
    );
  }
}
