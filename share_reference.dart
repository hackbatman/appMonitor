import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
   static Future<void> saveLoginState(bool isLoggedIn, String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', isLoggedIn);
     prefs.setString('username', username);
  }

  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('isLoggedIn'); 
  }

  static Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  // Obtener la contraseña del usuario logueado
  static Future<String?> getPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userpassword');
  } 

  // Actualizar el nombre de usuario y la contraseña en SharedPreferences
  static Future<void> updateUserData( String newPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('password', newPassword);
  }

}