import 'package:examen_dam_info_debarsywilliamchapelierbasile/class/Client.dart';
import 'package:examen_dam_info_debarsywilliamchapelierbasile/pages/transaction/DonnerPage.dart';
import 'package:examen_dam_info_debarsywilliamchapelierbasile/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'transaction/RecevoirPage.dart';
import 'transaction/ScanPage.dart';

class WelcomePage extends StatefulWidget {
  final int clientID;

  const WelcomePage({Key? key, required this.clientID}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _controllerCenter = ConfettiController(duration: const Duration(seconds: 7));
  late int expediteur_cardid;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConfettiPlay(widget.clientID);
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Scaffold(
          backgroundColor: kBackgroundColorWhite,
          body: Container(
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ButtonBar(
                  buttonPadding: EdgeInsets.zero,
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => Donner(clientID: widget.clientID)));
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                        padding: const EdgeInsets.all(20),
                        foregroundColor: Colors.green,
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.arrow_upward_rounded, color: Colors.black, size: 45),
                          Padding(padding: EdgeInsets.all(2)),
                          Text("Donner", style: TextStyle(color: Colors.black, fontSize: 18)),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ScanPage(clientID : widget.clientID, expediteur_cardid : expediteur_cardid)));
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                        padding: const EdgeInsets.all(20),
                        foregroundColor: Colors.green,
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.qr_code, color: Colors.black, size: 45),
                          Padding(padding: EdgeInsets.all(2)),
                          Text("Scanner", style: TextStyle(color: Colors.black, fontSize: 18)),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => RecevoirPage(clientID: widget.clientID)));
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                        padding: const EdgeInsets.all(20),
                        foregroundColor: Colors.green,
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.arrow_downward_rounded, color: Colors.black, size: 45),
                          Padding(padding: EdgeInsets.all(2)),
                          Text("Recevoir", style: TextStyle(color: Colors.black, fontSize: 18)),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.green,
                  thickness: 2,
                ),
                const Padding(padding: EdgeInsets.all(5)),
                const Padding(padding: EdgeInsets.only(left: 5), child: Text("Vos cartes :", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                const Padding(padding: EdgeInsets.all(2)),
                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('Client')
                      .where('id', isEqualTo: widget.clientID)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return const Text('Client not found');
                    } else {
                      var data = snapshot.data!.docs.first.data();
                      if (data != null) {
                        Client dataClient = Client.fromMap(data as Map<String, dynamic>);
                        expediteur_cardid = dataClient.card_id;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                child: Card(
                                  elevation: 8,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                dataClient.nom,
                                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                  dataClient.prenom,
                                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Padding(padding: EdgeInsets.all(5)),
                                        Container(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'À vue ',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              Text(
                                                  '${dataClient.card_id.toString()}',
                                                  style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Padding(padding: EdgeInsets.all(10)),
                                        Container(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                '${dataClient.balance.toDouble() ?? "N/A"} EUR',
                                                style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                child: Card(
                                  elevation: 8,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                dataClient.nom,
                                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                  dataClient.prenom,
                                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Padding(padding: EdgeInsets.all(5)),
                                        Container(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Épargne ',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              Text(
                                                  '${dataClient.card_id_2.toString()}',
                                                  style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Padding(padding: EdgeInsets.all(10)),
                                        Container(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                '${dataClient.balance_2.toDouble() ?? "N/A"} EUR',
                                                style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const Text('Client not found');
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        ConfettiWidget(
          confettiController: _controllerCenter,
          blastDirectionality: BlastDirectionality.explosive,
          emissionFrequency: 0.10,
          numberOfParticles: 5,
          gravity: 0.10,

        ),
      ],
    );
  }

  void ConfettiPlay(int clientID) async
  {
    QuerySnapshot snap = await FirebaseFirestore.instance.collection('Client').where('id', isEqualTo: clientID).get();
    var data = snap.docs.first.data();
    if (data != null) {
      Client dataClient = Client.fromMap(data as Map<String, dynamic>);
      if (dataClient.first_connection)
      {
        _controllerCenter.play();
        // TO DO : POP UP DE BIENVENUE 50€ OFFERT
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.green[400],
              title: const Text('Bienvenue !', style: TextStyle(fontWeight: FontWeight.bold)),
              content: RichText(
                text: const TextSpan(
                    children: [
                    TextSpan(text: 'Profitez pleinement de notre offre spéciale de ', style: TextStyle(color: Colors.black)),
                    TextSpan(text: '50€', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                    TextSpan(text: ' pour nos nouveaux membres. C\'est notre manière de vous souhaiter un excellent départ !', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
              actions: const <Widget>[
              ],
            );
          },
        );
        DocumentSnapshot docSnap = snap.docs[0];
        DocumentReference docRef = docSnap.reference;
        await docRef.update({'first_connection': false});
      }
    }
  }
}