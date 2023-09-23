import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:examen_dam_info_debarsywilliamchapelierbasile/styles/style.dart';

class ChangerMDP extends StatefulWidget {
  final int clientID;
  const ChangerMDP({Key? key, required this.clientID}) : super(key: key);

  @override
  State<ChangerMDP> createState() => _ChangerMDPState();
}

class _ChangerMDPState extends State<ChangerMDP> {
  final _changerMdpPageFormKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double widthScreenSize = MediaQuery.of(context).size.width - 20;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kBackgroundColorGreen,
        title: const Text("Changer Mot de passe"),
      ),
      body: Center(child :
      Form(
        key: _changerMdpPageFormKey,
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
                controller: oldPasswordController,
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
                    labelText: "Mot de passe actuel",
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
                  if(value == null || value.trim().isEmpty){
                    return "Mot de passe obligatoire";
                  } else if (value.length<3) {
                    return "Mot de passe trop court";
                  }
                  return null;
                },
                controller: passwordController,
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
                    labelText: "Nouveau mot de passe",
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
                    return "Correspond pas";
                  }
                  return null;
                },
                controller: passwordConfirmationController,
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
                    labelText: "Confirmer nouveau mot de passe",
                    labelStyle: kLoginInputTextStyle,
                    hintStyle: kLoginInputTextStyle,
                    prefixIcon: Icon(Icons.lock, color: kMainTextColor,)
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
                          if (_changerMdpPageFormKey.currentState!.validate())
                          {
                            bool boolSignUp = await ChangementMDP(oldPasswordController.text, passwordController.text,widget.clientID);
                            if (boolSignUp) {
                              Navigator.pop(contextBuild,'Mot de passe changé avec succes !');
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
  Future<bool> ChangementMDP(String oldMDP, String newMDP, int id) async {
    CollectionReference clientsBD = FirebaseFirestore.instance.collection('Client');
    // CHECK OLD MDP

    var bytes = utf8.encode(oldMDP);
    var oldDigest = sha256.convert(bytes);

    var bytes2 = utf8.encode(newMDP);
    var newDigest = sha256.convert(bytes2);

    try {
      QuerySnapshot snapshot = await clientsBD
          .where('password', isEqualTo: oldDigest.toString())
          .where('id', isEqualTo : id)
          .get();

      if(snapshot.size == 1) {
        DocumentSnapshot document = snapshot.docs[0];

        DocumentReference docRef = document.reference;

        await docRef.update({'password': newDigest.toString()});

        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Le mot de passe n'est associé a aucun utilisateur"),
          duration: Duration(seconds: 2),
        ));
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Erreur lors de la modification du mot de passe"),
        duration: Duration(seconds: 2),
      ));
      return false;
    }
  }
}