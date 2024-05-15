import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise les services, y compris AuthController
  await initServices();

  runApp(MyApp());
}

Future<void> initServices() async {
  // Utilise Get.putAsync pour initialiser AuthController de manière asynchrone
  await Get.putAsync(() async {
    return await AuthController.create();
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Définir la route initiale
      initialRoute: '/login',
      // Définir les routes
      getPages: [
        GetPage(name: '/login', page: () => LoginPage(),middlewares: [AuthMiddleware()]),
        GetPage(
          name: '/main',
          page: () => MainPage(),
          // Utiliser un middleware pour vérifier l'authentification
        ),
      ],
    );
  }
}

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

class AuthController extends GetxController {
  RxBool isLoggedIn = false.obs;
  RxString userEmail = ''.obs;

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  Future<void> _init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getBool('isLoggedIn') ?? false;
    userEmail.value = prefs.getString('userEmail') ?? '';
  }

  Future<void> login(String email, String password) async {
    if (isValidCredentials(email, password)) {
      isLoggedIn.value = true;
      userEmail.value = email;
      saveLoginStatus(true, email);
      // Utiliser la méthode Get.offNamed pour naviguer vers la page principale
      Get.offNamed('/main');
    } else {
      Get.snackbar('Erreur', 'Identifiants invalides');
    }
  }

  bool isValidCredentials(String email, String password) {
    return email == 'ahmed.sejad@esp.mr' && password == '12345';
  }

  void saveLoginStatus(bool isLoggedIn, String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', isLoggedIn);
    prefs.setString('userEmail', userEmail);
  }

  Future<void> logout() async {
    isLoggedIn.value = false;
    userEmail.value = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('isLoggedIn');
    prefs.remove('userEmail');
    Get.offNamed('/login');
  }

  static Future<AuthController> create() async {
    AuthController controller = AuthController();
    await controller._init();
    return controller;
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Bienvenue !',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                AuthController authController = Get.find<AuthController>();
                await authController.login(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );
              },
              child: Text('Connexion'),
            ),
            SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }
}

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
