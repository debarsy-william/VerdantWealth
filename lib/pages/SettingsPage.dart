import 'package:examen_dam_info_debarsywilliamchapelierbasile/pages/settings/ChangerMDP.dart';
import 'package:examen_dam_info_debarsywilliamchapelierbasile/pages/settings/ChangerMail.dart';
import 'package:examen_dam_info_debarsywilliamchapelierbasile/pages/settings/ChangerPin.dart';
import 'package:examen_dam_info_debarsywilliamchapelierbasile/pages/settings/InformationPage.dart';
import 'package:examen_dam_info_debarsywilliamchapelierbasile/pages/login/LoginPage.dart';
import 'package:examen_dam_info_debarsywilliamchapelierbasile/styles/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final int clientID;
  const SettingsPage({Key? key, required this.clientID}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool valNotify1 = true;

  onChangeFunction1(bool newValue1) {
    setState(() {
      valNotify1 = newValue1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Material(
            color: kBackgroundColorWhite,
            child: Container(
              margin : const EdgeInsets.only(left: 10.0, right: 10.0),
              child: ListView(
                children: [
                  const Padding(padding: EdgeInsets.all(10)),
                  const Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: kBackgroundColorGreen,
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      Text("Compte", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
                    ],
                  ),
                  const Divider(
                    height: 20,
                    color: Colors.green,
                    thickness: 2,
                  ),
                  modificationParametre("Vos informations"),
                  modificationParametre("Changer Adresse Mail"),
                  modificationParametre("Changer Mot de passe"),
                  modificationParametre("Changer Code Pin"),
                  const SizedBox(height: 30),
                  const Row(
                    children: [
                      Icon(Icons.notifications, color: kBackgroundColorGreen),
                      Padding(padding: EdgeInsets.all(5)),
                      Text("Notification", style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold
                      ))
                    ],
                  ),
                  const Divider(
                    height: 20,
                    color: Colors.green,
                    thickness: 2,
                  ),
                  paramOnOff("Notifications", valNotify1, onChangeFunction1),
                  const Padding(padding: EdgeInsets.all(50)),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.red[400] ?? Colors.transparent, width: 2.5)
                      ),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide.none,
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (contextBuild) => const LoginPage()
                          ));
                        },
                        child: const Text("Déconnexion", style: TextStyle(
                            fontSize: 20,
                            color: Colors.black
                        )),
                      ),
                    ),
                  )
                ],
              ),
            ),
        ),
    );
  }

  GestureDetector modificationParametre(String title) {
    return GestureDetector(
      onTap: () async {
          switch(title) {
            case "Changer Adresse Mail": {
                final result = await Navigator.push(context, MaterialPageRoute(
                builder: (context) => ChangerMail(clientID: widget.clientID)));

                if(!mounted) return;

                if (result!=null)
                {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('$result'),
                    duration: const Duration(seconds: 2),
                  ));
                }
            }
            break;

            case "Changer Mot de passe": {
              final result = await Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ChangerMDP(clientID: widget.clientID)));

              if(!mounted) return;

              if (result!=null)
              {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('$result'),
                  duration: const Duration(seconds: 2),
                ));
              }
            }
            break;

            case 'Changer Code Pin': {
              final result = await Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ChangerPin(clientID: widget.clientID)));

              if(!mounted) return;

              if (result!=null)
              {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('$result'),
                  duration: const Duration(seconds: 2),
                ));
              }
              break;
            }

            case "Vos informations": {
              await Navigator.push(context, MaterialPageRoute(
                  builder: (context) => InformationPage(clientID: widget.clientID)));
            }
            break;

            default: {
              //print("Aucun Choix correspondant");
            }
            break;
          }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]
            )),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Padding paramOnOff(String title, bool value, Function onChangeMethod) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600]
          )),
          Transform.scale(
            scale: 0.8,
            child: CupertinoSwitch(
              activeColor: Colors.green,
              trackColor: Colors.grey,
              value: value,
              onChanged: (bool newValue) {
                onChangeMethod(newValue);
              },
            ),
          )
        ],
      ),
    );
  }
}
