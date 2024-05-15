import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login/Controller/AuthController.dart';


class MainPage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page d\'accueil'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bienvenue, ${authController.userEmail} !'),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                AuthController authController = Get.find<AuthController>();
                await authController.logout();
              },
              child: Text('Déconnexion', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}