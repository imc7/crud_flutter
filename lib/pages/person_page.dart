import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/firebase_auth_service.dart';

class PersonPage extends StatefulWidget {
  const PersonPage({super.key});

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  late User? user;

  @override
  void initState() {
    super.initState();
    user = firebaseAuthService.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(user?.displayName ?? 'Full name'),
      ),
      body: user != null && user!.photoURL != null
          ? Image.network(user!.photoURL!)
          : Image.asset('assets/images/person.png'));
}
