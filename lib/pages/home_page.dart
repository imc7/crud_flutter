import 'package:crud_flutter/main.dart';
import 'package:crud_flutter/dtos/UserDTO.dart';
import 'package:crud_flutter/pages/notifications_page.dart';
import 'package:crud_flutter/pages/person_page.dart';
import 'package:crud_flutter/pages/sign_in_page.dart';
import 'package:crud_flutter/pages/tray_person_page.dart';
import 'package:crud_flutter/services/alerts_service.dart';
import 'package:crud_flutter/tools/preferences_tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dtos/response_dto.dart';
import '../services/firebase_auth_service.dart';
import '../tools/Constants.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase CRUD'),
        backgroundColor: Colors.blue.shade700,
      ),
      drawer: MyNavigationDrawer(),
      body: Center(
        child: Text('Welcome to home page'),
      ),
    );
  }
}

class MyNavigationDrawer extends StatelessWidget {
  // Main
  final FirebaseAuthService authService = FirebaseAuthService();
  AlertService alertService = AlertService();

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              builtMenuItems(context),
            ],
          ),
        ),
      );

  Widget buildHeader(BuildContext context) => Material(
        color: Colors.blue.shade700,
        child: InkWell(
          onTap: () {
            // close natigation drawer before
            Navigator.pop(context);

            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const PersonPage()));
          },
          child: Container(
            padding: EdgeInsets.only(
                top: 24 + MediaQuery.of(context).padding.top, bottom: 24),
            child: Column(
              children: [
                authService.getCurrentUser() != null &&
                        authService.getCurrentUser()!.photoURL != null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                            authService.getCurrentUser()!.photoURL!),
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/images/person.png'),
                      ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  authService.getCurrentUser()?.displayName ?? 'Fullname',
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
                Text(
                  authService.getCurrentUser()?.email ?? 'email@example.com',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                )
              ],
            ),
          ),
        ),
      );
  Widget builtMenuItems(BuildContext context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => const MyHomePage(title: '')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_outlined),
            title: const Text('Tray'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const TrayPersonPage()),
              );
            },
          ),
          const Divider(
            color: Colors.black54,
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notifications'),
            onTap: () {
              // Close navigation drawer before
              Navigator.pop(context);

              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const NotificationsPage()),
              );
            },
          ),

          // sign out
          const Divider(
            color: Colors.black54,
          ),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Sign out'),
            onTap: () async {
              // Close navigation drawer before
              bool answer = await alertService.confirmAlert(
                  context, "Are you sure sign out?");
              if (answer) {
                await removePreferences();
                ResponseDTO<String> response = await authService.signOut();

                int code = response.code;
                String message = response.message;
                if (code == Constants.code_warning ||
                    code == Constants.code_error) {
                  alertService
                      .successOrWarningOrErrorAlert(context, code, message, () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                } else if (code == Constants.code_success) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignInPage()));
                }
              }
            },
          )
        ],
      );
}
