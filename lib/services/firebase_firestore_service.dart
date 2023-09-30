import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_flutter/models/PersonModel.dart';
import 'package:crud_flutter/tools/Constants.dart';
import 'package:uuid/uuid.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

// Save data
Future<String> save(PersonModel person) async {
  // Create a new user with a first and last name
  String id = person.id;
  final user = <String, dynamic>{
    "name": person.name,
    "age": person.age,
    "photoUrl": "",
  };

  // Generate id, if it's not create mode
  if (id == null || id.isEmpty) {
    id = Uuid().v4().toString();
    await db
        .collection(Constants.collectionPerson)
        .doc(id)
        .set(user); // Save document
  } else {
    await db.collection(Constants.collectionPerson).doc(id).update({
      "name": person.name,
      "age": person.age,
    }); // Edit document
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
    PersonModel person = PersonModel(docSnapshot.id, docSnapshot.get('name'),
        docSnapshot.get('age'), docSnapshot.get('photoUrl') ?? '');
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
Future<void> updatePhotoUrl(String id, String photoUrl) async {
  final washingtonRef = db.collection(Constants.collectionPerson).doc(id);
  await washingtonRef.update({"photoUrl": photoUrl}).then(
      (value) => print("DocumentSnapshot successfully updated!"),
      onError: (e) => print("Error updating document"));
}
