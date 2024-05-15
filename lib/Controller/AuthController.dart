import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    if (email == 'ahmed.sejad@esp.mr' && password == '12345') {
      isLoggedIn.value = true;
      userEmail.value = email;
      saveLoginStatus(true, email);
      // Utiliser la méthode Get.offNamed pour naviguer vers la page principale
      Get.offNamed('/main');
    } else {
      Get.snackbar('Erreur', 'Identifiants invalides');
    }
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

}