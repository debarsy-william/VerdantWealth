import 'dart:async';
import 'dart:convert';
import 'package:examen_dam_info_debarsywilliamchapelierbasile/pages/HomePage.dart';
import 'package:examen_dam_info_debarsywilliamchapelierbasile/pages/login/SignUpPage.dart';
import 'package:examen_dam_info_debarsywilliamchapelierbasile/styles/style.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import '../../styles/Animation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
    final _loginFormKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    int idClient=0;

    @override
    Widget build(BuildContext context) {
      double widthScreenSize = MediaQuery.of(context).size.width - 20;
      return WillPopScope(
          onWillPop: () async => false,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Avenir',
              scaffoldBackgroundColor : kBackgroundColorGreen,
            ),
            home: Scaffold(
              body: SingleChildScrollView(
                child: SafeArea(
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(padding: EdgeInsets.all(100)),
                        Center(
                            child: DelayedAnimation(
                              delay: 250,
                              child: Container(
                                child: Image.asset("images/leaf.png", width: 120, height: 120),
                              ),
                            )
                        ),
                        const LoginHeader(),
                        const Padding(padding: EdgeInsets.all(10)),
                        Container(
                          child: Column(
                            children: [
                              SizedBox(
                                width: widthScreenSize,
                                child: TextFormField(
                                  validator: (value){
                                    if(value == null || value.trim().isEmpty){
                                      return "L'email est obligatoire !";
                                    } else if (!EmailValidator.validate(value.trim())) {
                                      return "L'email n'est pas au bon format";
                                    }
                                    return null;
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))
                                  ],
                                  controller: emailController,
                                  cursorColor: Colors.green,
                                  style: const TextStyle(color: kMainTextColor),
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                      errorStyle: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255,1, 205, 117)
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.green,
                                            width: 2.0,
                                          )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.green,
                                            width: 1.5,
                                          )
                                      ),
                                      errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 1, 66, 4),
                                            width: 2.0,
                                          )
                                      ),
                                      focusedErrorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 1, 66, 4),
                                            width: 2.0,
                                          )
                                      ),
                                      labelText: "Email",
                                      labelStyle: kLoginInputTextStyle,
                                      // hintText: "jDupont@test.com",
                                      hintStyle: kLoginInputTextStyle,
                                      prefixIcon: Icon(Icons.mail, color: kMainTextColor,)
                                  ),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.all(5)),
                              SizedBox(
                                width: widthScreenSize,
                                child: TextFormField(
                                  validator: (value){
                                    if(value == null || value.trim().isEmpty){
                                      return "Mot de passe obligatoire !";
                                    } else if (value.length<3) {
                                      return "Mot de passe trop court";
                                    }
                                    return null;
                                  },
                                  controller: passwordController,
                                  cursorColor: Colors.green,
                                  style: const TextStyle(color: kMainTextColor),
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10),
                                      errorStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold,color: Color.fromARGB(255,1, 205, 117)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.green,
                                            width: 2.0,
                                          )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.green,
                                            width: 1.5,
                                          )
                                      ),
                                      errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 1, 66, 4),
                                            width: 2.0,
                                          )
                                      ),
                                      focusedErrorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 1, 66, 4),
                                            width: 2.0,
                                          )
                                      ),
                                      labelText: "Mot de passe",
                                      labelStyle: kLoginInputTextStyle,
                                      hintStyle: kLoginInputTextStyle,
                                      prefixIcon: Icon(Icons.lock, color: kMainTextColor,)
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(5)),
                        Builder(
                            builder: (BuildContext contextBuild) {
                              return SizedBox(
                                width: 200,
                                height: 32,
                                child: ElevatedButton(
                                    style: const ButtonStyle(
                                        backgroundColor: MaterialStatePropertyAll(Colors.green)
                                    ),
                                    onPressed: () async {

                                      // FAST LOGIN
/*
                                      Navigator.push(contextBuild, MaterialPageRoute(
                                          builder: (contextBuild) => const HomePage(clientID: 2)
                                      ));
                                     */



                                      if (_loginFormKey.currentState!.validate())
                                      {

                                        // SLOW LOGIN (OFFICIAL)

                                        bool isPasswordCorrect = await _onVerifyPassword();
                                        if (isPasswordCorrect) {
                                          print('Mot de passe correct');
                                          ScaffoldMessenger.of(contextBuild).showSnackBar(const SnackBar(
                                            content: Text("Bienvenue sur votre application"),
                                            duration: Duration(seconds: 2),
                                          ));
                                          Navigator.push(contextBuild, MaterialPageRoute(
                                              builder: (contextBuild) => HomePage(clientID: idClient)
                                          ));
                                        } else {
                                          print('Email ou mot de passe incorrect');
                                          ScaffoldMessenger.of(contextBuild).showSnackBar(const SnackBar(
                                            content: Text("Email ou mot de passe incorrect"),
                                            duration: Duration(seconds: 2),
                                          ));
                                        }

                                      }
                                    },

                                    child: const Text("Se connecter",
                                        style: TextStyle(
                                            fontSize: 22
                                        )
                                    )
                                ),
                              );
                            }
                        ),
                        const Padding(padding: EdgeInsets.all(5)),
                        Builder(
                            builder: (BuildContext contextB) {
                              return RichText(
                                text: TextSpan(
                                    text: 'Créer un compte',
                                    style: linkStyle,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        final result = await Navigator.push(contextB, MaterialPageRoute(
                                            builder: (context) => SignUpPage()));

                                        if(!mounted) return;

                                        if (result!=null)
                                        {
                                          ScaffoldMessenger.of(contextB).showSnackBar(SnackBar(
                                            content: Text('$result'),
                                            duration: const Duration(seconds: 2),
                                          ));
                                        }
                                        print('Creation compte');
                                      }),
                              );
                            }
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      );
    }

    Future<bool> checkPassword(String email, String password) async {
      final CollectionReference clientsCollection = FirebaseFirestore.instance.collection('Client');
      var bytes = utf8.encode(password);
      var digest = sha256.convert(bytes);

      try {
        QuerySnapshot snapshot = await clientsCollection.where('email', isEqualTo: email).get();
        if (snapshot.docs.isNotEmpty) {
          final client = snapshot.docs.first;
          idClient = client.get('id');
          return client['password'] == digest.toString();
        }
      } catch (e) {
        print('Error: $e');
      }
      return false;
    }

    Future<bool> _onVerifyPassword() async {
      String email = emailController.text;
      String password = passwordController.text;
      bool isPasswordCorrect = await checkPassword(email, password);

      return isPasswordCorrect;
    }
}
