import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../controllers/account.dart';
import '../controllers/secured.dart';
import '../models/settings.dart';

enum ResetPassowrdStatus { success, error, accountDoesNotExist, none }

class AuthService extends GetxService {
  final firebaseInstance = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn(scopes: ['email']);

  // Rx<String> jwt = ''.obs;
  Rx<User?> firebaseUser = RxNullable<User?>().setNull();
  Rx<bool> signinIn = false.obs;

  final securedController = Get.find<SecuredController>();
  final accountController = Get.find<AccountController>();

  Rx<String> verificationId = ''.obs;
  Rx<String> usedPhoneNumber = ''.obs;

  @override
  void onInit() async {
    super.onInit();

    firebaseInstance.authStateChanges().map((user) {
      if (user == null) {
        return;
      }
      firebaseUser.value = user;
    });
  }

  Future<bool> validatePhoneNumber(String phoneNumber) async {
    var codeSent = false;
    usedPhoneNumber.value = phoneNumber;

    Completer<bool> codeCompleter = Completer<bool>();

    await firebaseInstance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        signInWithPhoneNumber(credential.verificationId!, credential.smsCode!);
      },
      verificationFailed: (FirebaseAuthException exception) {
        if (!codeCompleter.isCompleted) {
          codeCompleter.completeError('verification_failed');
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        this.verificationId.value = verificationId;
        if (!codeCompleter.isCompleted) {
          codeCompleter.complete(true);
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        if (!codeCompleter.isCompleted) {
          codeCompleter.completeError('retrieval_timeout');
        }
      },
    );

    codeSent = await codeCompleter.future;
    return codeSent;
  }

  Future<void> submitPhoneNumberOtp(String code) async {
    await signInWithPhoneNumber(verificationId.value, code);
  }

  Future<bool> resendEmailVerification() async {
    try {
      await firebaseInstance.currentUser?.sendEmailVerification();
      return true;
    } catch (e) {
      return false;
    }
  }

  bool userHasPhoneNumber() {
    return firebaseInstance.currentUser?.phoneNumber != null;
  }

  bool userHasEmailVerified(BiddoSettings settings) {
    if (!settings.emailValidationEnabled) {
      return true;
    }

    if (firebaseInstance.currentUser?.emailVerified == true) {
      return true;
    }

    return firebaseInstance.currentUser?.emailVerified ?? false;
  }

  Future<void> signInWithPhoneNumber(
    String verificationId,
    String code,
  ) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      );
      var result = await firebaseInstance.signInWithCredential(credential);
      firebaseUser.value = result.user;
    } catch (e) {
      print('Error signing in with phone number: $e');
    }
  }

  Future reloadFirebaseAccount() async {
    await firebaseInstance.currentUser?.reload();
  }

  Future<void> signInAnonymous() async {
    var result = await firebaseInstance.signInAnonymously();
    firebaseUser.value = result.user;
  }

  Future<void> signInWithEmailAndPass(String email, String password) async {
    var result = await firebaseInstance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    firebaseUser.value = result.user;
  }

  Future<ResetPassowrdStatus> sendForgotPasswordEmail(String email) async {
    try {
      await firebaseInstance.sendPasswordResetEmail(email: email);
      return ResetPassowrdStatus.success;
    } catch (error) {
      if (error.toString().contains('[firebase_auth/user-not-found]')) {
        return ResetPassowrdStatus.accountDoesNotExist;
      }
      return ResetPassowrdStatus.error;
    }
  }

  Future<void> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
      accessToken: appleCredential.authorizationCode,
    );

    final authResult =
        await firebaseInstance.signInWithCredential(oauthCredential);
    firebaseUser.value = authResult.user;
  }

  Future<void> signInWithGoogle() async {
    GoogleSignInAccount? googleAccount;
    googleAccount = await googleSignIn.signIn();
    if (googleAccount == null) {
      throw Exception('Could not sign in with google. Please try again.');
    }

    var googleSignInAuthentication = await googleAccount.authentication;

    var credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    var result = await firebaseInstance.signInWithCredential(credential);
    firebaseUser.value = result.user;
  }

  Future<void> signUp(
    String email,
    String password,
    BuildContext context,
  ) async {
    var result = await firebaseInstance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    firebaseUser.value = result.user;

    await firebaseUser.value?.sendEmailVerification();
  }

  Future signOut() async {
    try {
      firebaseUser.value = null;
      await firebaseInstance.signOut();
      await googleSignIn.signOut();
    } catch (error) {
      // ignore: avoid_print
      print(error.toString());
    }
  }

  /// credential request.
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
