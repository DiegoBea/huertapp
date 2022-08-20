import 'package:flutter/material.dart';
import 'package:huertapp/services/services.dart';
import 'package:provider/provider.dart';

class OrchardPage extends StatelessWidget {
  const OrchardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orchardService = Provider.of<OrchardService>(context, listen: true);

    return Scaffold(
      body: Center(
        child: Text('a'),
      ),
    );
  }
}
