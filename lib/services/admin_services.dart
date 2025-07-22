import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradmate_core/models/user_model.dart';

final db = FirebaseFirestore.instance.collection('users');
final firestore = FirebaseFirestore.instance;

// Method to add user a role
//* Roles: admin , editor , student (default) , (owner !!)
Future<void> addUserRole(UserModel user, List<String> roles) async {
  db.doc(user.id).update({'roles': roles});
}

// Method to fetch all users
Future<List<UserModel>> fetchAllUsers() async {
  List<UserModel> users = [];
  final snapshot = await firestore.collection('users').get();
  for (var doc in snapshot.docs) {
    if (doc['signedIn'] == true) {
      users.add(
        UserModel(
          id: doc.id,
          name: doc['name'],
          profileUrl: doc['profileUrl'],
          roles: doc['roles'],
          birthday: (doc['birthday'] as Timestamp).toDate(),
        ),
      );
    }
  }
  return users;
}
