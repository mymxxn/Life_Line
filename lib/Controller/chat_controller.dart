import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var userController = TextEditingController().obs;
  var isLoading = false.obs;
  void addChat() async {
    String userName = userController.value.text;

    // Check if a document already exists with the specified user name
    bool documentExists = await _documentExists(userName);

    if (!documentExists) {
      // Document does not exist, so we can create a new one
      await _firestore
          .collection('message')
          .doc(userName)
          .set({'chat': [], 'image': ''});
      print('New chat document created for $userName');
    } else {
      // Document already exists, handle accordingly (e.g., display an error message)
      print('A chat document already exists for $userName');
    }
  }

  Future<bool> _documentExists(String userName) async {
    var documentSnapshot =
        await _firestore.collection('message').doc(userName).get();
    return documentSnapshot.exists;
  }
}
