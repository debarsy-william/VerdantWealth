import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:examen_dam_info_debarsywilliamchapelierbasile/styles/style.dart';

class ChangerPin extends StatefulWidget {
  final int clientID;
  const ChangerPin({Key? key, required this.clientID}) : super(key: key);

  @override
  State<ChangerPin> createState() => _ChangerPinState();
}

class _ChangerPinState extends State<ChangerPin> {
  final _changerPinPageFormKey = GlobalKey<FormState>();
  final oldPinController = TextEditingController();
  final pinController = TextEditingController();
  final pinConfirmationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double widthScreenSize = MediaQuery.of(context).size.width - 20;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kBackgroundColorGreen,
        title: const Text("Changer Code Pin"),
      ),
      body: Center(child :
      Form(
        key: _changerPinPageFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                controller: oldPinController,
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
                    labelText: "Code pin actuel",
                    labelStyle: kLoginInputTextStyle,
                    hintStyle: kLoginInputTextStyle,
                    prefixIcon: Icon(Icons.numbers, color: kMainTextColor,)
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(5)),
            SizedBox(
              width: widthScreenSize,
              child: TextFormField(
                validator: (value){
                  if(value == null || value.trim().isEmpty){
                    return "Code pin obligatoire";
                  } else if (!RegExp(r'^[0-9]{4}$').hasMatch(value)) {
                    return "Mauvais format";
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: pinController,
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
                    labelText: "Nouveau code pin",
                    labelStyle: kLoginInputTextStyle,
                    hintStyle: kLoginInputTextStyle,
                    prefixIcon: Icon(Icons.numbers, color: kMainTextColor,)
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(5)),
            SizedBox(
              width: widthScreenSize,
              child: TextFormField(
                validator: (value){
                  if(value == null || value.trim().isEmpty || value!=pinController.text){
                    return "Correspond pas";
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: pinConfirmationController,
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
                    labelText: "Confirmer nouveau code pin",
                    labelStyle: kLoginInputTextStyle,
                    hintStyle: kLoginInputTextStyle,
                    prefixIcon: Icon(Icons.numbers, color: kMainTextColor,)
                ),
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
                          if (_changerPinPageFormKey.currentState!.validate())
                          {
                            bool boolSignUp = await ChangementCodePin(oldPinController.text, pinController.text,widget.clientID);
                            if (boolSignUp) {
                              Navigator.pop(contextBuild,'Code pin changé avec succes !');
                            }
                          }
                        },
                        child: const Text("Sauvegarder",
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
    );
  }
  Future<bool> ChangementCodePin(String oldMDP, String newMDP, int id) async {
    CollectionReference clientsBD = FirebaseFirestore.instance.collection('Client');
    // CHECK OLD MDP

    var bytes = utf8.encode(oldMDP);
    var oldDigest = sha256.convert(bytes);

    var bytes2 = utf8.encode(newMDP);
    var newDigest = sha256.convert(bytes2);

    try {
      QuerySnapshot snapshot = await clientsBD
          .where('code', isEqualTo: oldDigest.toString())
          .where('id', isEqualTo : id)
          .get();

      if(snapshot.size == 1) {
        DocumentSnapshot document = snapshot.docs[0];

        DocumentReference docRef = document.reference;

        await docRef.update({'code': newDigest.toString()});

        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Mauvais code pin"),
          duration: Duration(seconds: 2),
        ));
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Erreur lors de la modification du code pin"),
        duration: Duration(seconds: 2),
      ));
      return false;
    }
  }
}