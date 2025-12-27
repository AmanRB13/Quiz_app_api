import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  Future<void> signup(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print('/////// Signup Success ////////');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else {
        print('Firebase Auth Error: ${e.code}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Email/Password Sign-In
  Future<void> signin(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print('/////// Signin Success ////////');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        print('Firebase Auth Error: ${e.code}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Google Sign-In – Fixed for v7+ (no constructor needed)
  Future<bool> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // Web: Firebase popup (unchanged – works perfectly)
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.setCustomParameters({'prompt': 'select_account'});

        await FirebaseAuth.instance.signInWithPopup(googleProvider);
        print('/////// Google Sign-In Success (Web) ////////');
        return true;
      } else {
        // Mobile: Use singleton + authenticate() (correct for v7+)
        final GoogleSignInAccount? googleUser =
            await GoogleSignIn.instance.authenticate();

        if (googleUser == null) {
          print('Google Sign-In cancelled');
          return false;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        if (googleAuth.idToken == null) {
          print('No idToken received');
          return false;
        }

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
        print('/////// Google Sign-In Success (Mobile) ////////');
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code}');
      return false;
    } catch (e) {
      print('Google Sign-In Error: $e');
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    if (!kIsWeb) {
      await GoogleSignIn.instance.signOut();
    }
    print('/////// Signed Out ////////');
  }
}
