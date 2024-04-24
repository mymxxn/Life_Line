import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:lifeline/Controller/login_controller.dart';
import 'package:lifeline/Utils/constants.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});
  final controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          padding: const EdgeInsets.all(30),
          alignment: Alignment.center,
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(Constants.bgImage), fit: BoxFit.fill)),
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text(
                "Sign In",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              const SizedBox(
                height: 6,
              ),
              const Text(
                "Hi! Welcome back you have been missed.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 19,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Phone Number",
                    style: const TextStyle(color: Colors.black87, fontSize: 15),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  TextField(
                    controller: controller.phoneController.value,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        isCollapsed: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.black87,
                          ),
                        )),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Obx(() => ElevatedButton(
                    onPressed: () async {
                      controller.verifyPhoneNumber(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.primaryColor,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      fixedSize: Size(size.width, 50),
                    ),
                    child: controller.isLoading.value
                        ? CircularProgressIndicator()
                        : Text(
                            "Sign In",
                            style: TextStyle(color: Colors.white),
                          ),
                  )),
              SizedBox(height: size.height * 0.1),
            ]),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Constants.mutedColor,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Or SignUp with",
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Divider(
                  color: Constants.mutedColor,
                ))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                controller.googleLogin();
              },
              child: CircleAvatar(
                backgroundColor: Constants.lightGrey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(Constants.google),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
