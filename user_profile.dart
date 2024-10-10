import 'package:flutter/material.dart';
import 'package:app_mntr_bt/database/Json_model.dart';
import 'package:app_mntr_bt/database/databasesql.dart';
import '../database/share_reference.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String? _username;
  final _passwordController = TextEditingController();
  final db = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Método para cargar el nombre de usuario desde SharedPreferences
  void _loadUserData() async {
    String? userName = await SessionManager.getUsername();
    setState(() {
      _username = userName;
      print(_username);
    });
  }

  // Método para actualizar la contraseña
  Future<void> _updatePassword() async {
    String newPassword = _passwordController.text.trim();
    if (newPassword.isNotEmpty && _username != null) {
      await db.updatePassword(_username!, newPassword);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contraseña actualizada correctamente')),
      );
      _passwordController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('La contraseña no puede estar vacía')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Usuario"),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_username != null) ...[
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.redAccent,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Usuario $_username",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: AutofillHints.language,
                  color: Colors.black38,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Ingrese la nueva contraseña',
                  labelStyle: const TextStyle(
                      color: Colors.red), // Texto del label rojo
                  prefixIcon:
                      const Icon(Icons.person, color: Colors.red), // Icono rojo
                  filled: true,
                  fillColor:
                      Colors.red[50], // Fondo del TextField ligeramente rojo
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.red, width: 2.0), // Borde rojo al enfocar
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.red,
                        width: 1.0), // Borde rojo cuando no está enfocado
                  ),
                  // Texto de sugerencia rojo
                ),
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // button's shape
                    ),
                    backgroundColor: Colors.redAccent,
                    textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                onPressed: _updatePassword,
                child: Text("Actualizar contraseña"),
              ),
            ] else
              CircularProgressIndicator(), // Muestra un loader mientras se cargan los datos del usuario
          ],
        ),
      ),
    );
  }
}
