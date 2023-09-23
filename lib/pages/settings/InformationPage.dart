import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../class/Client.dart';
import '../../styles/style.dart';

class InformationPage extends StatelessWidget {
  final int clientID;
  const InformationPage({Key? key, required this.clientID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: kBackgroundColorGreen,
        title: const Text("Vos informations"),
      ),
      backgroundColor: kBackgroundColorWhite,
      body: Container(
        margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20),
        child: FutureBuilder<Client>(
          future: getDataClient(clientID),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            } else {
              Client client = snapshot.data!;
              return ListView(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.account_circle, color: kBackgroundColorGreen, size: 100),
                        const Padding(padding: EdgeInsets.all(5)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              client.nom,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Padding(padding: EdgeInsets.all(2)),
                            Text(
                              client.prenom,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    buildInfoCard("Email :", client.email,Icons.email),
                    buildInfoCard("Compte Courant :", client.card_id.toString(),Icons.credit_card),
                    buildInfoCard("Compte Épargne :", client.card_id_2.toString(),Icons.home),
                  ]
              );
            }
          },
        ),
      ),
    );
  }

  Future<Client> getDataClient(int id) async
  {
    CollectionReference clientsCollection = FirebaseFirestore.instance.collection('Client');
    try {
      QuerySnapshot snapshot = await clientsCollection.where('id', isEqualTo: id).get();
      Client client = Client.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
      //print('Data du client connecté info page : ${client.id} ; ${client.prenom} ; ${client.nom} ; ${client.email} ; ${client.card_id} ; ${client.balance}');
      return client;
    } catch (e) {
      //print('Error: $e');
      return Client.empty();
    }
  }

  Widget buildInfoCard(String title, String value, IconData iconData) {
    return Container(
      child: Card(
        child: ListTile(
            leading: Container(
              width: 40,
              alignment: Alignment.center,
              child: Icon(
                iconData,
                color: kBackgroundColorGreen,
                size: 28,
              ),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
    );
  }
}
