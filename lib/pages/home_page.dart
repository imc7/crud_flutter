import 'package:crud_flutter/services/alerts.dart';
import 'package:crud_flutter/services/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crud_flutter/services/firebase_service.dart';

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
      ),
      body: FutureBuilder(
          future: find(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  sortColumnIndex: 0,
                  sortAscending: true,
                  columns: [
                    DataColumn(label: Text('PHOTO')),
                    DataColumn(label: Text('NAME')),
                    DataColumn(label: Text('AGE'), numeric: true),
                    DataColumn(label: Text('ACTIONS')),
                  ],
                  rows: snapshot.data!
                      .map<DataRow>((e) => DataRow(selected: true, cells: [
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
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: const Center(
                                                  child: Text('Confirm')),
                                              content: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      'Do you want to delete it?')
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  child: Text("Yes"),
                                                  style: TextButton.styleFrom(
                                                    foregroundColor: Colors.red,
                                                  ),
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                    showLoadingAlert(context);
                                                    await deletePerson(e.id);
                                                    // Delete photo
                                                    if (e.photoUrl.isNotEmpty)
                                                      await deleteFile(e.id);
                                                    hideLoadingAlert();
                                                    setState(() {});
                                                  },
                                                ),
                                                TextButton(
                                                    child: Text("No"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    }),
                                              ],
                                            ));
                                  },
                                )
                              ],
                            ))
                          ]))
                      .toList(),
                ),
              );
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
