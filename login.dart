import 'package:app_mntr_bt/database/Json_model.dart';
import 'package:app_mntr_bt/database/databasesql.dart';
import 'package:app_mntr_bt/views/home.dart';
import 'package:app_mntr_bt/views/resetPassword.dart';
import 'package:app_mntr_bt/views/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import '../database/share_reference.dart';

@override
class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: MyStatefulWidget(
          
        ),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final db = DatabaseHelper();
  final email = TextEditingController();
  final pass = TextEditingController();

  bool showProgress = false;
  bool visible = false;
  bool _isObscure = true;
  bool _isObscure2 = true;
  bool isLogin = false;

  final _formkey = GlobalKey<FormState>();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  login() async {
    var response = await db.login(Users(
        userName: emailController.text, userPassword: passwordController.text));
         if (_formkey.currentState!.validate()) {
    if (response == true) {
         await SessionManager.saveLoginState(true, emailController.text);
      // ignore: use_build_context_synchronously
      Navigator.push(this.context,
          MaterialPageRoute(builder: (context) => Home_Monitor()));
    } else {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ingrese un usuario y contraseña correctamente"),  backgroundColor: Colors.red,));
        
      setState(() {
        isLogin = true;
      });
    }
         }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: <Widget>[
      
       Container(
           // padding: const EdgeInsets.all(10),
           //  color: Color.fromARGB(255, 11, 40, 51),
            child: Column(children: <Widget>[
              Container(
                margin: const EdgeInsets.all(15),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/image_logo.png",
                       height: 300.0,
     fit: BoxFit.fitHeight,
                      ),
                      const ListTile(
                        title: Text(
                          "Ingresa!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: AutofillHints.language,
                            color: Colors.black26,
                            fontSize: 40,
                          ),
                        ),
                        subtitle: Text(
                          "Usa tu usuario e ingresa tu contraseña",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Correo Electronico',
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.person,
                              color: Colors
                                  .red), 
                          enabled: true,
                          contentPadding: EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        validator: (value) {
                            if (value==null || value.isEmpty) {
                            return "Debe Ingresar un usuario";
                          }
                           else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          emailController.text = value!;
                        },
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        obscureText: _isObscure,
                        controller: passwordController,
                        style: TextStyle(fontSize: 18, color: Colors.red),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                              icon: Icon(_isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              }),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Contraseña',
                          hintStyle: TextStyle(color: Colors.grey),
                          
                          enabled: true,
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 15.0),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                          ),
                        ),
                        validator: (value) {
                            if (value==null || value.isEmpty) {
                            return "Debe Ingresar la contraseña";
                          }
                           else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          passwordController.text = value!;
                        },
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MaterialButton(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        elevation: 5.0,
                        height: 40,
                        minWidth: double.infinity,
                        onPressed: () {
                          setState(() {
                            showProgress = true;
                          });
                          login();
                        },
                        color: Colors.red,
                        child: const Text(
                          "Iniciar sesion",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextButton(
                              child: const Text(
                                '¿Aun no tienes cuenta? Registrate',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterPage()));
                              },
                            ),
                            TextButton(
                              onPressed: () {
                                  Navigator.push(
                                     context,
                                    MaterialPageRoute(
                                       builder: (context) => ResetPass()));
                              },
                              child: const Text(
                                '¿Olvidaste tu contraseña?',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ]
        ),
        
      );
      

    
    ;
  }
}
