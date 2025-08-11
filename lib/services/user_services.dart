import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:gradmate_core/models/user_model.dart';
import 'package:gradmate_core/services/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserServices {
  final db = FirebaseFirestore.instance.collection('users');
  late SharedPreferences prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  // Method to get current user
  User getUser() {
    return FirebaseAuth.instance.currentUser!;
  }

  // Method to add new user
  Future<bool> addNewUser(UserCredential userCredential) async {
    // Crete a new user
    UserModel user = UserModel(
      id: userCredential.user!.uid,
      name: userCredential.user!.displayName!,
      profileUrl: userCredential.user!.photoURL!,
      roles: ['student'],
    );

    try {
      // Save new user to firebase
      await db.doc(userCredential.user!.uid).set({'signedIn': true});
      await db
          .doc(userCredential.user!.uid)
          .update(user.toJson())
          .onError((e, _) => throw Exception("Error writing document: $e"));

      // Save SignIn Done in shared Preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('signIn_done', true);

      return true;
    } catch (e) {
      return false;
    }
  }

  // Method to check new admin
  Future<bool> checkNewAdmin(UserCredential userCredential) async {
    try {
      final roles = await UserServices().getUserRoles();
      const allowedRoles = ["owner", "admin", "editor"];
      final normalizedRoles = roles.map((r) => r.toLowerCase().trim()).toList();
      final hasAccess = normalizedRoles.any(
        (role) => allowedRoles.contains(role),
      );

      if (hasAccess) {
        // Save SignIn Done in shared Preferences

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('signIn_done', true);
        return true;
      } else {
        try {
          AuthServices().signOut();
          return false;
        } catch (e) {
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }

  // Method to SignOut a user
  Future<void> signOut(User user) async {
    // Update user details as signout
    await db.doc(user.uid).update({'signedIn': false});
    // SignOut from firebase
    try {
      AuthServices().signOut();
    } catch (e) {
      // Update user details as signedIn
      await db.doc(user.uid).update({'signedIn': true});
      return;
    }
    // Clear All Data
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Method to save user's birthday
  Future<void> addBirthday(DateTime birthday) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('birthday', birthday.toIso8601String());
    await db.doc(getUser().uid).update({'birthday': birthday});
  }

  DateTime getBirthday() {
    final birthdayStr = prefs.getString('birthday')!;

    return DateTime.tryParse(birthdayStr)!;
  }

  // Method to get users roles
  Future<List<String>> getUserRoles() async {
    final user = getUser(); // Assuming this returns the current FirebaseUser
    final DocumentSnapshot doc = await db.doc(user.uid).get();

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      debugPrint('Got User Roles: ${data['roles'].toString()}');
      return List<String>.from(data['roles'] ?? ['student']);
    } else {
      return ['student'];
    }
  }

  // How to use this
  //
  // final roles = await UserServices().getUserRoles();
  // const allowedRoles = ["owner", "admin", "editor"];
  // final normalizedRoles = roles.map((r) => r.toLowerCase().trim()).toList();
  // final hasAccess = normalizedRoles.any((role) => allowedRoles.contains(role));
  //
  //

  // Method to save and update user name
  Future<void> saveAndUpdateUserName(String username) async {
    final trimmedUsername = username.trim();

    try {
      // Save username to local storage
      await prefs.setString('username', trimmedUsername);

      // Update username in Firestore
      final user = getUser();
      await db.doc(user.uid).update({'name': trimmedUsername});
    } catch (e) {
      debugPrint('Error saving/updating username: $e');
      rethrow; // Or handle the error as needed
    }
  }

  // Method to get saved username
  Future<String> getUserName() async {
    try {
      // Try to get the username from local storage
      final userName = prefs.getString('username');

      if (userName != null && userName.isNotEmpty) {
        return userName;
      }

      // If not found in local storage, try to get it from Firebase
      final user = getUser();
      if (user.displayName != null && user.displayName!.isNotEmpty) {
        return user.displayName!;
      }

      throw Exception("Username not found");
    } catch (e) {
      // Log error and rethrow or return fallback
      debugPrint("Error retrieving username: $e");
      rethrow;
    }
  }
}
