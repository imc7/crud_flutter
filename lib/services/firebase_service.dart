import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_flutter/models/PersonModel.dart';
import 'package:crud_flutter/tools/Constants.dart';
import 'package:uuid/uuid.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

// Save data
Future<String> save(String id, String name, int age) async {
  // Create a new user with a first and last name
  final user = <String, dynamic>{
    "name": name,
    "age": age,
    "photoUrl": "",
  };

  // Para generar el id, si no es edición
  if (id == null || id.isEmpty) {
    id = Uuid().v4().toString();
    await db.collection(Constants.collectionPerson).doc(id).set(user);
  } else {
    await db
        .collection(Constants.collectionPerson)
        .doc(id)
        .update(user); // Edit document
  }
  return id;
}

// Find data
Future<List<PersonModel>> find() async {
  List<PersonModel> response = [];

  CollectionReference collectionReference =
      db.collection(Constants.collectionPerson);
  QuerySnapshot querySnapshot = await collectionReference.get();

  for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
    PersonModel person = PersonModel();
    person.id = docSnapshot.id;
    person.name = docSnapshot.get('name');
    person.age = docSnapshot.get('age');
    person.photoUrl = docSnapshot.get('photoUrl') ?? '';
    response.add(person);
    print('PERSON FROM FIREBASE ${docSnapshot.id} => ${docSnapshot.data()}');
  }

  return response;
}

// Delete
Future<void> deletePerson(String id) async {
  await db.collection(Constants.collectionPerson).doc(id).delete();
}

// Upload photo
Future<void> uploadPhoto(String id, String photoUrl) async {
  final washingtonRef = db.collection(Constants.collectionPerson).doc(id);
  await washingtonRef.update({"photoUrl": photoUrl}).then(
      (value) => print("DocumentSnapshot successfully updated!"),
      onError: (e) => print("Error updating document"));
}
