import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:lifeline/Presentation/Pages/drawer/drawer.dart';
import 'package:lifeline/Utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void initState() {
    secureScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(""), actions: [
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.comment_outlined,
              color: Constants.primaryColor,
            ))
      ]),
      drawer: DrawerScreen(),
    );
  }
}
