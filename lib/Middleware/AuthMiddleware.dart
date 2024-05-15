import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login/Controller/AuthController.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Vérifier si l'utilisateur est connecté avant d'accéder à la page principale
    AuthController authController = Get.find<AuthController>();
    if (authController.isLoggedIn.value ) {
      return RouteSettings(name: '/main');
    }
    return null;
  }
}