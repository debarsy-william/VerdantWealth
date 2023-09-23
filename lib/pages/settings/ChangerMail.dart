import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:examen_dam_info_debarsywilliamchapelierbasile/styles/style.dart';

class ChangerMail extends StatefulWidget {
  final int clientID;
  const ChangerMail({Key? key, required this.clientID}) : super(key: key);

  @override
  State<ChangerMail> createState() => _ChangerMailState();
}

class _ChangerMailState extends State<ChangerMail> {
  final _changeMailFormKey = GlobalKey<FormState>();
  final emailController1 = TextEditingController();
  final emailController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double widthScreenSize = MediaQuery.of(context).size.width - 20;
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: kBackgroundColorGreen,
          title: const Text("Changer Mail"),
      ),
      body: Center(child :
        Form(
          key: _changeMailFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                controller: emailController1,
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
                    labelText: "Email actuel",
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
                    return "L'email est obligatoire";
                  } else if (!EmailValidator.validate(value.trim())) {
                    return "L'email n'est pas au bon format";
                  }
                  return null;
                },
                controller: emailController2,
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
                    labelText: "Nouvel Email",
                    labelStyle: kLoginInputTextStyle,
                    // hintText: "jDupont@test.com",
                    hintStyle: kLoginInputTextStyle,
                    prefixIcon: Icon(Icons.mail, color: kMainTextColor,)
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
                          if (_changeMailFormKey.currentState!.validate())
                          {
                            bool boolSignUp = await ChangementEmail(emailController1.text, emailController2.text,widget.clientID);
                            if (boolSignUp) {
                              Navigator.pop(contextBuild,'Email changé avec succès !');
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

  Future<bool> ChangementEmail(String oldEmail, String newEmail, int id) async {
    CollectionReference clientsBD = FirebaseFirestore.instance.collection('Client');
    // CHECK EMAIL
    try {
      QuerySnapshot snapshot = await clientsBD
          .where('email', isEqualTo: oldEmail)
          .where('id', isEqualTo : id)
          .get();

      if(snapshot.size == 1) {
        DocumentSnapshot document = snapshot.docs[0];
        DocumentReference docRef = document.reference;

        await docRef.update({'email': newEmail});

        //print("E-mail mis à jour avec succès !");
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("L'email entré est incorrect"),
          duration: Duration(seconds: 2),
        ));
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Erreur lors de la mise à jour de l'email"),
        duration: Duration(seconds: 2),
      ));
      return false;
    }
  }
}