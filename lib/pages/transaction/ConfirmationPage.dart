import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import '../../class/Client.dart';
import '../../class/TransactionNotification.dart';
import '../../styles/style.dart';
import 'SuccessPage.dart';

class Confirmer extends StatefulWidget {
  final int clientID;
  final TransactionNotification transaction;
  const Confirmer({super.key, required this.clientID, required this.transaction});

  @override
  State<Confirmer> createState() => _ConfirmerState();
}

class _ConfirmerState extends State<Confirmer> {
  final _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColorWhite,
      appBar: AppBar(
          elevation: 10,
          backgroundColor: Colors.green[800],
          title: const Text("Confirmation du virement")),
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.all(5)),
              ListTile(
                leading: const Icon(Icons.credit_card, size: 35, color: Colors.green),
                title: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("De", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                    Padding(padding: EdgeInsets.only(top: 10)),
                  ],
                ),
                subtitle: Text(
                    'COMPTE : ${widget.transaction.expediteur_card_id}',
                    style: const TextStyle(color: Colors.black)
                ),
              ),
              const Padding(padding: EdgeInsets.all(8)),
              ListTile(
                leading: const Icon(Icons.account_box_rounded, size: 35, color: Colors.green),
                title: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Vers", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                    Padding(padding: EdgeInsets.only(top: 10)),
                  ],
                ),
                subtitle: Text('${widget.transaction.destinataire_card_id}', style: const TextStyle(color: Colors.black)),
              ),
              const Padding(padding: EdgeInsets.all(8)),
              ListTile(
                leading: const Icon(Icons.euro, size: 35, color: Colors.green),
                title: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Montant", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                    Padding(padding: EdgeInsets.only(top: 10)),
                  ],
                ),
                subtitle: Text(
                    '${widget.transaction.montant.toString().replaceAll('.', ',')} €',
                    style: const TextStyle(color: Colors.black)
                ),
              ),
              const Padding(padding: EdgeInsets.all(8)),
              ListTile(
                leading: const Icon(Icons.comment, size: 35, color: Colors.green),
                title: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                        "Communication",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                  ],
                ),
                subtitle: Text('\"${widget.transaction.communication}\"', style: const TextStyle(color: Colors.black)),
              )
            ],
          )
        ),
      ),
      persistentFooterButtons: [
        Builder(
            builder: (BuildContext contextBuild) {
              return Container(
                height: 50,
                alignment: Alignment.center,
                child: SizedBox(
                  width: 200,
                  height: 32,
                  child: ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Colors.green)
                      ),
                      onPressed: () async {
                        // POP UP NEED CODE
                        //print('On pressed confirmer');

                        String? clientCode = await showDialog<String>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Entrez votre code secret'),
                              content: TextFormField(
                                obscureText: true,
                                keyboardType: TextInputType.number,
                                controller: _codeController,
                                decoration: const InputDecoration(
                                  hintText: 'Code',
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.green,
                                        width: 2.0,
                                      )
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.green,
                                        width: 2.0,
                                      )
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.green,
                                        width: 2.0,
                                      )
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.green,
                                        width: 2.0,
                                      )
                                  ),
                                  errorStyle: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255,1, 205, 117)
                                  ),
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Ferme le popup sans rien faire
                                  },
                                  child: const Text('Annuler', style: TextStyle(color: Colors.green),),
                                ),
                                ElevatedButton(
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(Colors.green)
                                  ),
                                  onPressed: () {
                                    String clientCode = _codeController.text;
                                    Navigator.of(context).pop(clientCode); // Ferme le popup et renvoie le code du client
                                  },
                                  child: const Text('Valider'),
                                ),
                              ],
                            );
                          },
                        );
                        //print("Verif validation");
                        if (clientCode != null && clientCode.isNotEmpty) {
                          // VERIF CODE EN FIREBASE
                          if (await checkCode(clientCode)) {
                            try
                            {
                              await pushTransaction(widget.transaction);
                              if (await debitCompte(widget.transaction) && await creditCompte(widget.transaction))
                                {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => SuccessPage(clientID: widget.clientID)));
                                }
                            }
                            catch (error) {
                              //print('Erreur lors de l\'envoi de la transaction : $error');
                            }
                          }
                        }
                      },
                      child: const Text("Confirmer",
                        style: TextStyle(fontSize: 22),
                      )
                  ),
                ),
              );
            }
        ),
      ],
    );
  }

  Future<bool> checkCode(String code) async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('Client')
        .where('id', isEqualTo: widget.clientID)
        .get();

    var bytes = utf8.encode(code);
    var digest = sha256.convert(bytes);

    if (snap.docs.isNotEmpty) {
      var data = snap.docs.first.data();
      Client dataClient = Client.fromMap(data as Map<String, dynamic>);
      if (dataClient.code == digest.toString()) {
        return true;
      }
    }
    return false;
  }

  Future<void> pushTransaction(TransactionNotification tr) async
  {
    Map<String, dynamic> transactionMap = tr.toMap();

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      CollectionReference collectionNotif = FirebaseFirestore.instance.collection('Notification');
      DocumentReference newNotif = collectionNotif.doc();

      transaction.set(newNotif, transactionMap);
    });
  }

  Future<bool> debitCompte(TransactionNotification transac) async
  {
    bool transactionSuccessful = false;
    //print('EXP CARD = ${transac.expediteur_card_id}');
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('Client')
          .where('card_id', isEqualTo: transac.expediteur_card_id)
          .get();

      QuerySnapshot snap2 = await FirebaseFirestore.instance
          .collection('Client')
          .where('card_id_2', isEqualTo: transac.expediteur_card_id)
          .get();

      if (snap.docs.isEmpty)
      {
        // COMPTE EPARGNE
        var data = snap2.docs.first.data();
        Client dataClient = Client.fromMap(data as Map<String, dynamic>);
        DocumentSnapshot document = snap2.docs[0];
        DocumentReference docRef = document.reference;

        await docRef.update({'balance_2': dataClient.balance_2 - num.parse(transac.montant)});
        //print("Compte epargne : Transaction debit effectuée");
        transactionSuccessful = true;
      }
      else if (snap2.docs.isEmpty)
      {
        // COMPTE COURANT / A VUE
        var data = snap.docs.first.data();
        Client dataClient = Client.fromMap(data as Map<String, dynamic>);
        DocumentSnapshot document = snap.docs[0];
        DocumentReference docRef = document.reference;

        await docRef.update({'balance': dataClient.balance - num.parse(transac.montant)});
        //print("Compte à vue : Transaction debit effectuée");
        transactionSuccessful = true;
      }
    });
    return transactionSuccessful;
  }

  Future<bool> creditCompte(TransactionNotification transac) async
  {
    bool creditSuccessful = false;
    //print('DEST CARD = ${transac.expediteur_card_id}');
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('Client')
          .where('card_id', isEqualTo: transac.destinataire_card_id)
          .get();

      QuerySnapshot snap2 = await FirebaseFirestore.instance
          .collection('Client')
          .where('card_id_2', isEqualTo: transac.destinataire_card_id)
          .get();

      if (snap.docs.isEmpty)
      {
        // COMPTE EPARGNE
        var data = snap2.docs.first.data();
        Client dataClient = Client.fromMap(data as Map<String, dynamic>);
        DocumentSnapshot document = snap2.docs[0];
        DocumentReference docRef = document.reference;

        await docRef.update({'balance_2': dataClient.balance_2 + num.parse(transac.montant)});
        //print("Compte epargne : Credit effectué");
        creditSuccessful = true;
      }
      else if (snap2.docs.isEmpty)
      {
        // COMPTE COURANT / A VUE
        var data = snap.docs.first.data();
        Client dataClient = Client.fromMap(data as Map<String, dynamic>);
        DocumentSnapshot document = snap.docs[0];
        DocumentReference docRef = document.reference;

        await docRef.update({'balance': dataClient.balance + num.parse(transac.montant)});
        //print("Compte à vue : Credit effectué");
        creditSuccessful = true;
      }
    });
    return creditSuccessful;
  }
}
