import 'dart:convert';
import 'package:examen_dam_info_debarsywilliamchapelierbasile/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _SignUpPageFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  final prenomController = TextEditingController();
  final nomController = TextEditingController();
  final codeController = TextEditingController();
  final codeConfirmationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double widthScreenSize = MediaQuery.of(context).size.width - 20;
    return Scaffold(
      backgroundColor: kBackgroundColorGreen,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green[800],
        title: const Text("Creation de votre compte")),
        body: Center(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Form(
                key: _SignUpPageFormKey,
                child: Column(
                  children: [
                    Container(
                      child: Image.asset("images/leaf.png", width: 120, height: 120),
                    ),
                    const LoginHeader(),
                    const Padding(padding: EdgeInsets.all(10)),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const Padding(padding: EdgeInsets.all(5)),
                              SizedBox(
                                width: (widthScreenSize/2)-5,
                                child: TextFormField(
                                  validator: (value){
                                    if(value == null || value.trim().isEmpty){
                                      return "Prenom obligatoire";
                                    }
                                    return null;
                                  },
                                  controller: prenomController,
                                  cursorColor: Colors.green,
                                  style: const TextStyle(color: kMainTextColor),
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
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
                                      labelText: "Prenom",
                                      labelStyle: kLoginInputTextStyle,
                                      // hintText: "Jean",
                                      hintStyle: kLoginInputTextStyle,
                                      prefixIcon: Icon(Icons.account_circle, color: kMainTextColor,)
                                  ),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.all(5)),
                              SizedBox(
                                width: (widthScreenSize/2)-5,
                                child: TextFormField(
                                  validator: (value){
                                    if(value == null || value.trim().isEmpty){
                                      return "Nom obligatoire";
                                    }
                                    return null;
                                  },
                                  controller: nomController,
                                  cursorColor: Colors.green,
                                  style: const TextStyle(color: kMainTextColor),
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
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
                                      labelText: "Nom",
                                      labelStyle: kLoginInputTextStyle,
                                      // hintText: "Jean",
                                      hintStyle: kLoginInputTextStyle,
                                      prefixIcon: Icon(Icons.account_circle, color: kMainTextColor,)
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.all(5)),
                          SizedBox(
                            width: widthScreenSize,
                            child: TextFormField(
                              validator: (value){
                                if(value == null || value.trim().isEmpty){
                                  return "L'email est obligatoire";
                                } else if (!EmailValidator.validate(value.trim())) {
                                  return "L'email n'est pas au bon format";
                                }
                                return null;
                              },
                              controller: emailController,
                              cursorColor: Colors.green,
                              style: const TextStyle(color: kMainTextColor),
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
                                  return "Mot de passe obligatoire";
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
                                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
                          const Padding(padding: EdgeInsets.all(5)),
                          SizedBox(
                            width: widthScreenSize,
                            child: TextFormField(
                              validator: (value){
                                if(value == null || value.trim().isEmpty || value!=passwordController.text){
                                  return "Le mot de passe ne correspond pas";
                                }
                                return null;
                              },
                              controller: passwordConfirmationController,
                              cursorColor: Colors.green,
                              style: const TextStyle(color: kMainTextColor),
                              obscureText: true,
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
                                  labelText: "Confirmer mot de passe",
                                  labelStyle: kLoginInputTextStyle,
                                  hintStyle: kLoginInputTextStyle,
                                  prefixIcon: Icon(Icons.lock, color: kMainTextColor,)
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.all(5)),
                          Row(
                            children: [
                              const Padding(padding: EdgeInsets.all(5)),
                              SizedBox(
                                width: (widthScreenSize/2)-5,
                                child: TextFormField(
                                  validator: (value){
                                    if(value == null || value.trim().isEmpty){
                                      return "Code manquant";
                                    } else if (!RegExp(r'^[0-9]{4}$').hasMatch(value)) {
                                      return "Mauvais format";
                                    }
                                    return null;
                                  },
                                  controller: codeController,
                                  keyboardType: TextInputType.number,
                                  cursorColor: Colors.green,
                                  style: const TextStyle(color: kMainTextColor),
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
                                      labelText: "Code",
                                      labelStyle: kLoginInputTextStyle,
                                      hintStyle: kLoginInputTextStyle,
                                      prefixIcon: Icon(Icons.numbers, color: kMainTextColor,)
                                  ),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.all(5)),
                              SizedBox(
                                width: (widthScreenSize/2)-5,
                                child: TextFormField(
                                  validator: (value){
                                    if(value == null || value.trim().isEmpty || value!=codeController.text){
                                      return "Le code ne correspond pas";
                                    }
                                    return null;
                                  },
                                  controller: codeConfirmationController,
                                  keyboardType: TextInputType.number,
                                  cursorColor: Colors.green,
                                  style: const TextStyle(color: kMainTextColor),
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
                                      labelText: "Confirmer code",
                                      labelStyle: kLoginInputTextStyle,
                                      hintStyle: kLoginInputTextStyle,
                                      prefixIcon: Icon(Icons.numbers, color: kMainTextColor,)
                                  ),
                                ),
                              ),
                            ],
                          )
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
                                  if (_SignUpPageFormKey.currentState!.validate())
                                  {
                                    if (await _onSignUpAccount(emailController.text))
                                    {
                                      //print('Création de compte : succès');
                                      Navigator.pop(contextBuild,'Compte enregistré, veuillez vous connecter');
                                    }
                                  }
                                },
                                child: const Text("S'enregistrer",
                                    style: TextStyle(
                                        fontSize: 22
                                    )
                                )
                            ),
                          );
                        }
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }

  Future<bool> _onSignUpAccount(String email) async {
    CollectionReference clientsBD = FirebaseFirestore.instance.collection('Client');
    DocumentReference usefulDataRef = FirebaseFirestore.instance.collection('UsefulData').doc('LastIDs');

    // CHECK EMAIL
    QuerySnapshot snapshot = await clientsBD.where('email', isEqualTo: email).get();
    if (snapshot.docs.isEmpty) {
      // SHA256 PASSWORD
      var bytes = utf8.encode(passwordController.text);
      var bytes2 = utf8.encode(codeController.text);
      var digest = sha256.convert(bytes);
      var digest2 = sha256.convert(bytes2);
      //print('HEX CODE = ${digest2.toString()}');

      // MISE A JOUR ID ET CARD_ID VIA TRANSACTION
      try {
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot usefulDataDoc = await transaction.get(usefulDataRef);
          int lastClientId = usefulDataDoc.get('last_id');
          int lastCardId = usefulDataDoc.get('last_card_id');
          int lastCardId2 = usefulDataDoc.get('last_card_id_2');
          int newClientId = lastClientId + 1;
          int newCardId = lastCardId + 1;
          int newCardId2 = lastCardId2 + 1;

          transaction.update(usefulDataRef, {
            'last_id': newClientId,
            'last_card_id': newCardId,
            'last_card_id_2': newCardId2,
          });

          // AJOUT NOUVEAU CLIENT
          clientsBD.add({
            'id': newClientId,
            'nom': nomController.text,
            'prenom': prenomController.text,
            'email': emailController.text,
            'password': digest.toString(),
            'code': digest2.toString(),
            'first_connection': true,
            'card_id': newCardId,
            'card_id_2': newCardId2,
            'balance': 50.0,
            'balance_2': 0.0,
          });
        });
        return true;
      } catch (e) {
        return false;
        //print("Transaction échouée: $e");
      }
    }
    return false;
  }
}