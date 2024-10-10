import 'package:app_mntr_bt/database/Json_model.dart';
import 'package:app_mntr_bt/database/databasesql.dart';
import 'package:app_mntr_bt/views/login.dart';
import 'package:flutter/material.dart';

@override
class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: register_signup(),
      ),
    );
  }
}

class register_signup extends StatefulWidget {
  const register_signup({Key? key}) : super(key: key);

  @override
  State<register_signup> createState() => _register_signupState();
}

class _register_signupState extends State<register_signup> {
  final db = DatabaseHelper();
  final email = TextEditingController();
  final pass = TextEditingController();
  bool showProgress = false;
  bool visible = false;
  bool _isObscure = true;
  bool _isObscure2 = true;

  final _formkey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  signup() {
    if (_formkey.currentState!.validate()) {
      var response = db
          .signup(Users(
              userName: emailController.text,
              userPassword: passwordController.text))
          .whenComplete(() {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        // margin: const EdgeInsets.only(top: 90,),
        child: ListView(children: <Widget>[
          Image.asset("assets/images/image_logo.png",
           height: 250.0,
     fit: BoxFit.fitHeight,),
          Container(
            margin: const EdgeInsets.all(12),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const ListTile(
                    title: Text(
                      "Registrate!",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: AutofillHints.language,
                        color: Colors.black38,
                        fontSize: 40,
                      ),
                    ),
                    subtitle: Text(
                      "Ingresa correctamente tus datos",
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(height: 70),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Ingrese un usuario',
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.person, color: Colors.red),
                      enabled: true,
                      contentPadding:
                          EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Debe Ingresar los un usuario";
                      } else {
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
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
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
                      hintText: 'Ingrese una contraseña',
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.lock, color: Colors.red),
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
                      if (value == null || value.isEmpty) {
                        return "Debe Ingresar los un usuario";
                      } else {
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
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    elevation: 5.0,
                    height: 40,
                    minWidth: double.infinity,
                    onPressed: () {
                      setState(() {
                        showProgress = true;
                      });
                      signup();
                    },
                    color: Colors.red,
                    child: const Text(
                      "Registrase",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Checkbox(
                          value: true,
                          onChanged: (bool? value) {
                            value = true;
                          },
                          activeColor: Colors.red,
                          checkColor: Colors.white,
                        ),
                        const Text(
                          'Acepto los términos y condiciones',
                          style: TextStyle(color: Colors.red),
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
    );
  }
}
