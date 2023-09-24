import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PersonPage extends StatelessWidget {
  const PersonPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Full name'),
      ),
      body: Image.asset('assets/images/person.png'));
}
