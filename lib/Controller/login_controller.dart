import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lifeline/Utils/constants.dart';
import 'package:lifeline/Utils/router.dart';
import 'package:lifeline/Utils/snackbar_services.dart';
import 'package:lifeline/Utils/user_preferences.dart';

class LoginController extends GetxController {
  var phoneController = TextEditingController().obs;
  var isLoading = false.obs;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to verify phone number
  Future<void> verifyPhoneNumber(BuildContext context) async {
    try {
      isLoading.value = true;
      update();

      String phoneNumber = '+91${phoneController.value.text.trim()}';

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          signInWithPhoneAuthCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          isLoading.value = false;
          update();
          SnackBarServices.errorSnackBar(e.message.toString());
          print(e.message);
        },
        codeSent: (String verificationId, int? resendToken) {
          isLoading.value = false;
          update();
          showOtpDialog(context, verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          isLoading.value = false;
          update();
        },
      );
    } catch (e) {
      isLoading.value = false;
      update();
      print('Error verifying phone number: $e');
      SnackBarServices.errorSnackBar('Error verifying phone number');
    }
  }

  // Show OTP dialog for entering verification code
  void showOtpDialog(BuildContext context, String verificationId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      "PIN",
                      style: TextStyle(
                        color: Constants.mutedColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Constants.mutedColor,
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                color: Constants.lightGrey,
              ),
            ],
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: OtpTextField(
              numberOfFields: 6,
              borderColor: Color(0xFF512DA8),
              showFieldAsBox: true,
              onSubmit: (String verificationCode) {
                signInWithPhoneNumber(
                  verificationId: verificationId,
                  smsCode: verificationCode,
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Function to sign in with phone number using verification code
  Future<void> signInWithPhoneNumber({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      isLoading.value = true;
      update();

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      // Sign in with the credential
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // Check if the user already exists in the Firestore 'users' collection
        QuerySnapshot<Map<String, dynamic>> result = await _firestore
            .collection('users')
            .where('id', isEqualTo: firebaseUser.uid)
            .get();

        if (result.docs.isEmpty) {
          // User is new, so add them to the Firestore collection
          await _firestore.collection('users').doc(firebaseUser.uid).set({
            'nickname': firebaseUser.displayName ?? '',
            'photoUrl': firebaseUser.photoURL ?? '',
            'id': firebaseUser.uid,
          });
        }

        // Set user login status and phone number in preferences
        UserPreferences.setIsLoggedIn(true);

        // Navigate to home screen
        Get.toNamed(RouteManager.home);
      }

      isLoading.value = false;
      update();
    } catch (e) {
      isLoading.value = false;
      update();
      print('Error signing in with phone number: $e');
      SnackBarServices.errorSnackBar('Error signing in with phone number');
    }
  }

  // Function to handle verification completed with phone auth credential
  void signInWithPhoneAuthCredential(PhoneAuthCredential credential) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // Proceed with additional authentication logic or navigate to home
        // Here we can implement additional logic if needed
      }
    } catch (e) {
      print('Error signing in with phone auth credential: $e');
      // Handle error
    }
  }

  // Function to sign in with Google
  Future<void> googleLogin() async {
    try {
      isLoading.value = true;
      update();

      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with Google credentials
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // Check if the user already exists in the Firestore 'users' collection
        QuerySnapshot<Map<String, dynamic>> result = await _firestore
            .collection('users')
            .where('id', isEqualTo: firebaseUser.uid)
            .get();

        if (result.docs.isEmpty) {
          // User is new, so add them to the Firestore collection
          await _firestore.collection('users').doc(firebaseUser.uid).set({
            'nickname': firebaseUser.displayName ?? '',
            'photoUrl': firebaseUser.photoURL ?? '',
            'id': firebaseUser.uid,
          });
        }

        // Set user login status and phone number in preferences
        UserPreferences.setIsLoggedIn(true);

        // Navigate to home screen
        Get.toNamed(RouteManager.home);
      }

      isLoading.value = false;
      update();
    } catch (e) {
      isLoading.value = false;
      update();
      log('Error signing in with Google: $e');
      SnackBarServices.errorSnackBar('Error signing in with Google');
    }
  }
}
