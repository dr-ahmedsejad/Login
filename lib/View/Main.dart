import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login/View/LoginPage.dart';
import 'package:login/View/Home.dart';
import 'package:login/Controller/AuthController.dart';
import 'package:login/Middleware/AuthMiddleware.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initServices();

  runApp(MyApp());
}

initServices() {
  // Initialise  AuthController
  AuthController authController = Get.put(AuthController());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Définir la route initiale
      initialRoute: '/login',
      // Définir les routes
      getPages: [
        GetPage(
            name: '/login',
            page: () => LoginPage(),
            middlewares: [AuthMiddleware()]),
        GetPage(
          name: '/main',
          page: () => Home(),
          // Utiliser un middleware pour vérifier l'authentification
        ),
      ],
    );
  }
}
