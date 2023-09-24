import 'package:crud_flutter/main.dart';
import 'package:crud_flutter/pages/notifications_page.dart';
import 'package:crud_flutter/pages/person_page.dart';
import 'package:crud_flutter/pages/tray_person_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
              children: const [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/person.png'),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  'Full name',
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
                Text(
                  'email@example.com',
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
          )
        ],
      );
}
