import 'package:app_mntr_bt/views/login.dart';
import 'package:flutter/material.dart';
import 'package:app_mntr_bt/database/Json_model.dart';
import 'package:app_mntr_bt/database/databasesql.dart';
import '../database/share_reference.dart';

class ResetPass extends StatefulWidget {
  @override
  _ResetPassState createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  String? _username;
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final db = DatabaseHelper();

  
  Future<void> _loadUserData() async {
    String userName = _usernameController.text.trim();
     String? userExistente = await SessionManager.getUsername();
    if (userName==userExistente) {
     
      setState(() {
        _username = userExistente;
      });
      if (_username == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario no encontrado')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingrese un nombre de usuario')),
      );
    }
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
      Navigator.push(this.context,
          MaterialPageRoute(builder: (context) => Login()));
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
          title: Text("Editar contraseña"),
          backgroundColor: Colors.redAccent,
        ),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(children: <Widget>[
            Container(padding: EdgeInsets.only(bottom: 20,top: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 300, // Ancho específico para el TextField
                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Ingrese nombre de usuario',
                        labelStyle: const TextStyle(color: Colors.red),
                        prefixIcon: const Icon(Icons.person, color: Colors.red),
                        filled: true,
                        fillColor: Colors.red[50],
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.redAccent,
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: _loadUserData,
                    child: const Icon(
                      Icons.search_sharp,
                      color: Colors.white,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 50),
            // Si el usuario se encontró, muestra el campo de contraseña y el botón de actualización
            if (_username != null) ...[
              Container(
                  child: Column(children: <Widget>[
                      SizedBox(height: 20),
                Text(
                  "Usuario encontrado",
                  style: const TextStyle(
                    
                    fontFamily: AutofillHints.language,
                    color: Colors.black38,
                    fontSize: 20,
                  ),
                ),
                  SizedBox(height: 10),
                 Text(
                  " $_username",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: AutofillHints.language,
                    color: Colors.black38,
                    fontSize: 20,
                  ),
                ),
                  SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Ingrese la nueva contraseña',
                    labelStyle: const TextStyle(color: Colors.red),
                    prefixIcon: const Icon(Icons.lock, color: Colors.red),
                    filled: true,
                    fillColor: Colors.red[50],
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1.0),
                    ),
                  ),
                  style: TextStyle(color: Colors.red),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.redAccent,
                    textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onPressed: _updatePassword,
                  child: Text("Actualizar contraseña"),
                ),
              ]))
            ] else
              CircularProgressIndicator(), // Muestra un loader mientras se realiza la búsqueda
          ]),
        ));
  }
}
