import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../class/Client.dart';
import '../../class/TransactionNotification.dart';
import 'ConfirmationPage.dart';
import '../../styles/style.dart';

class Donner extends StatefulWidget {
  final int clientID;
  final TransactionNotification? transaction;
  const Donner({super.key, required this.clientID, this.transaction});

  @override
  State<Donner> createState() => _DonnerState();
}

class _DonnerState extends State<Donner> {
  final _SignUpPageFormKey = GlobalKey<FormState>();
  String expediteurCardID = '';
  var destinataireCardID = TextEditingController();
  var montant = TextEditingController();
  var communication = TextEditingController();

  String selectedCard = '';
  List<String> dataCard = [];

  @override
  void initState() {
    super.initState();
    getAllCard(widget.clientID);
  }

  @override
  Widget build(BuildContext context) {
    bool isQRCodeMode = widget.transaction != null;
    if (isQRCodeMode)
    {
      destinataireCardID = TextEditingController(text: widget.transaction?.destinataire_card_id.toString());
      montant = TextEditingController(text: widget.transaction?.montant.toString().replaceAll('.', ','));
      communication = TextEditingController(text: widget.transaction?.communication.toString());
    }
    /*print("Qr code état : $isQRCodeMode");
    print('DEST CARD ID : ${widget.transaction?.destinataire_card_id.toString()}');
    print('Montant : ${widget.transaction?.montant.toString()}');
    print('COMMUNICATION : ${widget.transaction?.communication.toString()}');*/
    return Scaffold(
      backgroundColor: kBackgroundColorWhite,
      appBar: AppBar(
          elevation: 10,
          backgroundColor: kBackgroundColorGreen,
          title: const Text("Virement")),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _SignUpPageFormKey,
                child: Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(padding: EdgeInsets.all(10)),
                      ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                  text: const TextSpan(
                                      children: [
                                        TextSpan(text: "De ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                                        WidgetSpan(
                                          child: Icon(Icons.credit_card, size: 20, color: Colors.green),
                                        ),
                                      ]
                                  )
                              ),
                              const Padding(padding: EdgeInsets.all(5)),
                            ],
                          ),
                          subtitle: Column(
                            children: [
                              SizedBox(
                                height: 45,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isDense: true,
                                    focusColor: Colors.transparent,
                                    isExpanded: true,
                                    icon: const Icon(Icons.arrow_downward, size: 30),
                                    elevation: 16,
                                    value: selectedCard,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedCard = newValue!;
                                        expediteurCardID = extractNumber(newValue);
                                      });
                                    },
                                    items: dataCard.map((String tr) {
                                      return DropdownMenuItem<String>(
                                        value: tr,
                                        child: Text(tr),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              const Divider(
                                color: Colors.green,
                                thickness: 2,
                              ),
                            ],
                          )
                      ),
                      const Padding(padding: EdgeInsets.all(5)),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                                text: const TextSpan(
                                    children: [
                                      TextSpan(text: "Vers ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                                      WidgetSpan(
                                        child: Icon(Icons.account_box_rounded, size: 20, color: Colors.green),
                                      ),
                                    ]
                                )
                            ),
                            const Padding(padding: EdgeInsets.all(5)),
                          ],
                        ),
                        subtitle: Container(
                          height: 45,
                          child: SizedBox(
                            height: 50,
                            child: TextFormField(
                              enabled: !isQRCodeMode,
                              cursorColor: Colors.green,
                              validator: (value) {
                                if(value == null || value.trim().isEmpty){
                                  return "Destinataire manquant";
                                } else if (!RegExp(r'^[0-9]{9}$').hasMatch(value)) {
                                  return "Mauvais format";
                                }
                                return null;
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: destinataireCardID,
                              style: const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 0),
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
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(5)),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                                text: const TextSpan(
                                    children: [
                                      TextSpan(text: "Montant ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                                      WidgetSpan(
                                        child: Icon(Icons.euro, size: 20, color: Colors.green),
                                      ),
                                    ]
                                )
                            ),
                            const Padding(padding: EdgeInsets.all(5)),
                          ],
                        ),
                        subtitle: Container(
                          height: 45,
                          child: SizedBox(
                            height: 50,
                            child: TextFormField(
                              enabled: !isQRCodeMode,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.green,
                              validator: (value){
                                if(value == null || value.trim().isEmpty){
                                  return "Montant manquant";
                                } else if (!RegExp(r'^\d+(,\d{1,2})?$').hasMatch(value)) {
                                  return "Mauvais format";
                                }
                                return null;
                              },
                              controller: montant,
                              style: const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 0),
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
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(5)),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                                text: const TextSpan(
                                    children: [
                                      TextSpan(text: "Communication ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                                      WidgetSpan(
                                        child: Icon(Icons.comment, size: 20, color: Colors.green),
                                      ),
                                    ]
                                )
                            ),
                            const Padding(padding: EdgeInsets.all(5)),
                          ],
                        ),
                        subtitle: Container(
                          height: 45,
                          child: SizedBox(
                            height: 50,
                            child: TextFormField(
                              enabled: !isQRCodeMode,
                              cursorColor: Colors.green,
                              controller: communication,
                              style: const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 0),
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
                        if (_SignUpPageFormKey.currentState!.validate())
                        {
                          if (await verifCardExist(destinataireCardID.text)) {
                            if (await verifSolde(montant.text)) {
                              TransactionNotification tr = await CreateTransaction(isQRCodeMode);
                              Navigator.push(contextBuild, MaterialPageRoute(
                                  builder: (context) => Confirmer(clientID: widget.clientID,transaction: tr)));
                            }
                            else {
                              ScaffoldMessenger.of(contextBuild).showSnackBar(const SnackBar(
                                content: Text('Solde insuffisant'),
                                duration: Duration(seconds: 2),
                              ));
                              return;
                            }
                          }
                          else {
                            ScaffoldMessenger.of(contextBuild).showSnackBar(const SnackBar(
                              content: Text('Destinataire introuvable'),
                              duration: Duration(seconds: 2),
                            ));
                            return;
                          }
                        }
                      },
                      child: const Text("Suivant",
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

  Future getAllCard(int clientID) async {
    QuerySnapshot snap = await FirebaseFirestore.instance.collection('Client').where('id', isEqualTo: clientID).get();
    var data = snap.docs.first.data();
    if (data != null) {
      Client dataClient = Client.fromMap(data as Map<String, dynamic>);
      setState(() {
        dataCard.add('À vue : ${dataClient.card_id} (${dataClient.balance} €)');
        dataCard.add('Épargne : ${dataClient.card_id_2} (${dataClient.balance_2} €)');
        selectedCard = dataCard[0];
        expediteurCardID = extractNumber(dataCard[0]);
      });
      //print('card = ${dataCard[0].toString()} and ${dataCard[1].toString()}');
    }
  }

  Future<bool> verifCardExist(String card) async
  {
    //print('CARD = $card');
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('Client')
        .where('card_id', isEqualTo: int.parse(card))
        .get();

    QuerySnapshot snap2 = await FirebaseFirestore.instance
        .collection('Client')
        .where('card_id_2', isEqualTo: int.parse(card))
        .get();

    if (snap.docs.isNotEmpty || snap2.docs.isNotEmpty) {
      //print('CARD = $card (Exists = TRUE)');
        return true;
      }
    else {
      //print('CARD = $card (Exists = FALSE)');
      return false;
    }
  }

  Future<bool> verifSolde(String montant) async
  {
    //print('MONTANT = $montant');
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('Client')
        .where('card_id', isEqualTo: int.parse(expediteurCardID))
        .get();

    QuerySnapshot snap2 = await FirebaseFirestore.instance
        .collection('Client')
        .where('card_id_2', isEqualTo: int.parse(expediteurCardID))
        .get();

    if (snap.docs.isEmpty)
      {
        // COMPTE EPARGNE
        var data = snap2.docs.first.data();
        Client dataClient = Client.fromMap(data as Map<String, dynamic>);
        if (dataClient.balance_2 >= double.parse(montant.replaceAll(',', '.'))) {
          //print('MONTANT = $montant (Suffisant = TRUE)');
          return true;
        }
        else {
          //print('MONTANT = $montant (Suffisant = FALSE)');
          return false;
        }
      }
    else if (snap2.docs.isEmpty)
      {
        // COMPTE COURANT / A VUE
        var data = snap.docs.first.data();
        Client dataClient = Client.fromMap(data as Map<String, dynamic>);
        if (dataClient.balance >= double.parse(montant.replaceAll(',', '.'))) {
          //print('MONTANT = $montant (Suffisant = TRUE)');
          return true;
        }
        else {
          //print('MONTANT = $montant (Suffisant = FALSE)');
          return false;
        }
      }
    return false;
  }

  Future<TransactionNotification> CreateTransaction(bool isQRCodeMode) async
  {
    DocumentReference usefulDataRef = FirebaseFirestore.instance.collection('UsefulData').doc('LastTransactionIDs');

    return await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot usefulDataDoc = await usefulDataRef.get();
      int lastTransactionId = usefulDataDoc.get('last_id');
      int newTransactionId = lastTransactionId + 1;

      transaction.update(usefulDataRef, {
        'last_id': newTransactionId,
      });

      TransactionNotification transactionNotif = TransactionNotification(
        id: newTransactionId,
        expediteur_id: widget.clientID,
        expediteur_card_id: int.parse(expediteurCardID),
        destinataire_card_id: int.parse(destinataireCardID.text),
        montant: montant.text.replaceAll(',', '.'),
        communication: communication.text,
        date: DateTime.now(),
        qr_code: isQRCodeMode,
        read: false,
      );
      return transactionNotif;
    });
  }

  String extractNumber(String input)
  {
      RegExp regex = RegExp(r'\d+');
      Match? match = regex.firstMatch(input);

      if (match != null) {
        //print(match.group(0));
        return match.group(0) ?? '';
      }
      return '';
  }
}

