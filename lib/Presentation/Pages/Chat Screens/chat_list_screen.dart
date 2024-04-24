import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifeline/Controller/chat_controller.dart';
import 'package:lifeline/Presentation/components.dart';
import 'package:lifeline/Utils/constants.dart';

class ChatListScreen extends StatelessWidget {
  ChatListScreen({super.key});
  final chatController = Get.put(ChatController());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Components.commonDialog(
                context,
                'Chat',
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Components.commonTextfield(
                        txt: 'name',
                        controller: chatController.userController.value,
                        inputtype: TextInputType.name),
                    ElevatedButton(
                      onPressed: () {
                        chatController.addChat();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.primaryColor,
                        shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        fixedSize: Size(size.width, 50),
                      ),
                      child: chatController.isLoading.value
                          ? CircularProgressIndicator()
                          : Text(
                              "ADD",
                              style: TextStyle(color: Colors.white),
                            ),
                    )
                  ],
                ));
          },
          child: Icon(Icons.comment)),
    );
  }
}
