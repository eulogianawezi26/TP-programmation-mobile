import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:twitter_login/twitter_login.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookAuth _facebookAuth = FacebookAuth.instance;
  // final TwitterLogin _twitterLogin = TwitterLogin(
  //   apiKey: 'YOUR_TWITTER_API_KEY',
  //   apiSecretKey: 'YOUR_TWITTER_API_SECRET',
  //   redirectURI: 'YOUR_REDIRECT_URI',
  // );

  // Connexion avec email et mot de passe
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  // Inscription avec email et mot de passe
  Future<UserCredential?> createUserWithEmailAndPassword(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user?.updateDisplayName(name);
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Connexion avec Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      rethrow;
    }
  }

  // Connexion avec Facebook
  Future<UserCredential?> signInWithFacebook() async {
    try {
      final LoginResult result = await _facebookAuth.login();
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final AuthCredential credential = FacebookAuthProvider.credential(accessToken.tokenString);
        return await _auth.signInWithCredential(credential);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Connexion avec Twitter
  // Future<UserCredential?> signInWithTwitter() async {
  //   try {
  //     final authResult = await _twitterLogin.login();
  //     if (authResult.status == TwitterLoginStatus.loggedIn) {
  //       final AuthCredential credential = TwitterAuthProvider.credential(
  //         accessToken: authResult.authToken!,
  //         secret: authResult.authTokenSecret!,
  //       );
  //       return await _auth.signInWithCredential(credential);
  //     }
  //     return null;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await _facebookAuth.logOut();
  }

  // Utilisateur actuel
  User? get currentUser => _auth.currentUser;

  // Stream d'état d'authentification
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}