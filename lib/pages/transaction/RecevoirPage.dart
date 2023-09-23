import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examen_dam_info_debarsywilliamchapelierbasile/pages/HomePage.dart';
import 'package:examen_dam_info_debarsywilliamchapelierbasile/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../class/Client.dart';
import 'SuccessPage.dart';

class RecevoirPage extends StatefulWidget {
  final int clientID;
  const RecevoirPage({super.key, required this.clientID});

  @override
  _RecevoirPageState createState() => _RecevoirPageState();
}

class _RecevoirPageState extends State<RecevoirPage> {
  final _generateQrFormKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _commuController = TextEditingController();
  String _qrData = '';
  String amount = '';
  String commu = '';
  Timer? _notificationTimer;
  bool waitingTimer = true;
  int counter = 0;

  @override
  void dispose() {
    _notificationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColorWhite,
      appBar: AppBar(
        title: const Text('Recevoir un paiement'),
        backgroundColor: kBackgroundColorGreen,
        elevation: 10,
      ),
      body: Form(
        key: _generateQrFormKey,
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
                              TextSpan(text: "Montant ", style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black)),
                              WidgetSpan(
                                child: Icon(
                                    Icons.euro, size: 20, color: Colors.green),
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
                      cursorColor: Colors.green,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value
                            .trim()
                            .isEmpty) {
                          return "Montant manquant";
                        } else if (!RegExp(r'^\d+(,\d{1,2})?$').hasMatch(value)) {
                          return "Mauvais format";
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _amountController,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12, horizontal: 0),
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
                            color: Color.fromARGB(255, 1, 205, 117)
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        text: const TextSpan(
                            children: [
                              TextSpan(text: "Communication ", style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black)),
                              WidgetSpan(
                                child: Icon(Icons.comment, size: 20,
                                    color: Colors.green),
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
                      cursorColor: Colors.green,
                      controller: _commuController,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12, horizontal: 0),
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
                            color: Color.fromARGB(255, 1, 205, 117)
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              if (_qrData.isNotEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.green,
                            width: 4,
                          )
                      ),
                      child: QrImageView(
                        data: _qrData,
                        version: QrVersions.auto,
                        size: 200.0,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
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
                  width: 300,
                  height: 32,
                  child: ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Colors.green)
                      ),
                      onPressed: () {
                        if (_generateQrFormKey.currentState!.validate()) {
                          _generateQRCode();
                        }
                      },
                      child: const Text("Générer le QR code",
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

  Future<void> _generateQRCode() async {
    amount = _amountController.text;
    commu = _commuController.text;
    int carteCli = await InfoClient(widget.clientID);

    String additionalInfo = 'VW;$amount;$carteCli;$commu;SCAN';
    //print(additionalInfo);
    setState(() {
      _qrData = additionalInfo;
    });

    startNotificationCheckLoop();
  }

  Future<int> InfoClient(int ClientId) async {
    QuerySnapshot snap = await FirebaseFirestore.instance.collection('Client')
        .where('id', isEqualTo: ClientId)
        .get();
    var data = snap.docs.first.data();
    if (data != null) {
      Client dataClient = Client.fromMap(data as Map<String, dynamic>);
      int carteId = dataClient.card_id;
      return carteId;
    }
    return 0;
  }

  Future<bool> checkForNewNotification() async {
    counter++;
    //print('CHECK NOTIF, counter = $counter');
    int cardID = await InfoClient(widget.clientID);
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Notification')
        .where('destinataire_card_id', isEqualTo: cardID)
        .where('montant', isEqualTo: amount)
        .where('communication', isEqualTo: commu)
        .where('qr_code', isEqualTo: true)
        .where('read', isEqualTo: false)
        .get();

    if (snapshot.docs.isNotEmpty) {
      _notificationTimer?.cancel();
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => SuccessPage(clientID: widget.clientID)));
      return true;
    }
    if (counter == 12) {
        _notificationTimer?.cancel();
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => HomePage(clientID: widget.clientID)));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Délai dépassé'),
          duration: Duration(seconds: 4),
        ));
    }
    return false;
  }

  void startNotificationCheckLoop() async {
    //print('Lancement timer');
    _notificationTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await checkForNewNotification();
    });
  }
}