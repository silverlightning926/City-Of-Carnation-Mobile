import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with email and password
  static Future<UserCredential> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    return await _auth
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .catchError((error) {
      throw error;
    });
  }

  // Sign out
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  // Create user with email and password
  static Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _auth
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .catchError((error) {
      throw error;
    });
  }

  // Reauthenticate user
  static Future<void> reauthenticateUser({
    required String email,
    required String password,
  }) async {
    await _auth.currentUser!
        .reauthenticateWithCredential(
      EmailAuthProvider.credential(
        email: email.trim(),
        password: password.trim(),
      ),
    )
        .catchError((error) {
      throw error;
    });
  }

  // Send password reset email
  static Future<void> sendPasswordResetEmail({required String email}) async {
    await _auth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }

  // Update user email
  static Future<void> updateUserEmail({required String email}) async {
    await _auth.currentUser!
        .updateEmail(
      email.trim(),
    )
        .catchError((error) {
      throw error;
    });
  }

  // Update user password
  static Future<void> updateUserPassword({required String password}) async {
    await _auth.currentUser!
        .updatePassword(
      password.trim(),
    )
        .catchError((error) {
      throw error;
    });
  }

  // Delete user
  static Future<void> deleteUser() async {
    await _auth.currentUser!.delete();
  }

  // Get user
  static User? get user => _auth.currentUser;

  // Get user id
  static String? get userId => _auth.currentUser!.uid;

  // Get user email
  static String? get userEmail => _auth.currentUser!.email;

  // Get user photo url
  static String? get userPhotoURL => _auth.currentUser!.photoURL;
}
