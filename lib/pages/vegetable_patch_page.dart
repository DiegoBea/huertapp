import 'package:flutter/material.dart';
import 'package:huertapp/services/services.dart';
import 'package:provider/provider.dart';


class VegetablePatchPage extends StatelessWidget {
  const VegetablePatchPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final vegetablePatchService = Provider.of<VegetablePatchService>(context);

    return Scaffold(
      body: Center(
        child: Text('a'),
     ),
   );
  }
}