import 'dart:io';

import 'package:crud_flutter/services/alerts.dart';
import 'package:crud_flutter/services/firebase_firestore_service.dart';
import 'package:crud_flutter/services/firebase_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home_page.dart';

class TrayPersonPage extends StatefulWidget {
  const TrayPersonPage({super.key});

  @override
  State<TrayPersonPage> createState() => _TrayPersonPageState();
}

class _TrayPersonPageState extends State<TrayPersonPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyNavigationDrawer(),
      appBar: AppBar(
        title: Text('Person tray'),
      ),
      body: FutureBuilder(
          future: find(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              // If it doesn't have registers
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text('There is not register to show'),
                );
              } else {
                return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 0,
                        top: 20,
                        right: 0,
                        bottom: 0,
                      ),
                      child: DataTable(
                        border: TableBorder.all(),
                        sortColumnIndex: 0,
                        sortAscending: true,
                        headingRowColor: MaterialStateColor.resolveWith(
                            (states) => Colors.blue),
                        headingTextStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        columns: [
                          DataColumn(label: Text('PHOTO')),
                          DataColumn(label: Text('NAME')),
                          DataColumn(label: Text('AGE'), numeric: true),
                          DataColumn(label: Text('ACTIONS')),
                        ],
                        rows: snapshot.data!
                            .map<DataRow>(
                                (e) => DataRow(selected: true, cells: [
                                      DataCell(e.photoUrl.isEmpty
                                          ? CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Colors.white,
                                              backgroundImage: AssetImage(
                                                'assets/images/person.png',
                                              ),
                                            )
                                          : CircleAvatar(
                                              radius: 20,
                                              backgroundImage: NetworkImage(
                                                e.photoUrl,
                                              ),
                                            )),
                                      DataCell(Text(e.name)),
                                      DataCell(Text(e.age.toString())),
                                      DataCell(Row(
                                        children: [
                                          // Edit button
                                          IconButton(
                                            icon: new Icon(Icons.edit),
                                            onPressed: () async {
                                              await Navigator.pushNamed(
                                                context,
                                                '/add',
                                                arguments: {
                                                  "title": "Edit person",
                                                  "person": {
                                                    "id": e.id,
                                                    "name": e.name,
                                                    "age": e.age,
                                                    "photoUrl": e.photoUrl,
                                                  }
                                                },
                                              );
                                              setState(() {});
                                            },
                                          ),

                                          // Delete button
                                          IconButton(
                                            icon: new Icon(Icons.delete),
                                            onPressed: () async {
                                              await confirmAlert(context,
                                                  "Do you want to delete it?",
                                                  () async {
                                                showLoadingAlert(context, null);
                                                await deletePerson(e.id);
                                                // Delete photo
                                                if (e.photoUrl.isNotEmpty)
                                                  await deleteFile(e.id);
                                                hideLoadingAlert();
                                                setState(() {});
                                              });
                                            },
                                          )
                                        ],
                                      ))
                                    ]))
                            .toList(),
                      ),
                    ));
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          })),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(
            context,
            '/add',
            arguments: {
              "title": "Create person",
            },
          );
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
