import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../class/Client.dart';
import '../class/TransactionNotification.dart';

class TransactionPage extends StatefulWidget {
  final Client? client;
  const TransactionPage({super.key, required this.client});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  late CollectionReference _notificationCollection;
  final List<int> listTransactionDoublonID = [];

  @override
  void initState() {
    super.initState();
    _notificationCollection = FirebaseFirestore.instance.collection('Notification');
  }

  @override
  Widget build(BuildContext context) {
    listTransactionDoublonID.clear();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Material(
        child: Container(
          child: FutureBuilder<List<TransactionNotification>>(
            future: getTransactions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(child : Center( child : CircularProgressIndicator()));// Afficher un indicateur de chargement si nécessaire
              } else if (snapshot.hasError) {
                //print('${snapshot.error}');
                return Text('Une erreur s\'est produite. ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('Aucune transaction trouvée.');
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    TransactionNotification transaction = snapshot.data![index];

                    int compt = snapshot.data!.where((t) => t.id == transaction.id).length;
                    //print("Compteur : $compt data : ${transaction.communication}");

                    if (compt == 2 && !listTransactionDoublonID.contains(transaction.id))
                      {
                        //print("Premier doublon = ${transaction.id}");
                        listTransactionDoublonID.add(transaction.id);
                        // DEBIT POUR DOUBLON (INTER-COMPTE)
                        return ListTile(
                          leading: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: '${transaction.date.day}/${transaction.date.month}\n',
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)
                                ),
                                TextSpan(text: '${transaction.date.year}', style: const TextStyle(color: Colors.black)),
                              ]
                            ),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Vers ${transaction.destinataire_card_id}'),
                              Text('-${transaction.montant} EUR', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          subtitle: Text(transaction.communication),
                        );
                      }
                    if (transaction.destinataire_card_id == widget.client?.card_id || transaction.destinataire_card_id == widget.client?.card_id_2)
                    {
                      // CREDIT
                      return ListTile(
                        leading: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: '${transaction.date.day}/${transaction.date.month}\n',
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)
                                ),
                                TextSpan(text: '${transaction.date.year}', style: const TextStyle(color: Colors.black)),
                              ]
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('De ${transaction.expediteur_card_id}'),
                            Text('+${transaction.montant} EUR', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        subtitle: Text(transaction.communication),
                      );
                    }
                    else {
                      // DEBIT
                      return ListTile(
                        leading: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: '${transaction.date.day}/${transaction.date.month}\n',
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)
                                ),
                                TextSpan(text: '${transaction.date.year}', style: const TextStyle(color: Colors.black)),
                              ]
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Vers ${transaction.destinataire_card_id}'),
                            Text('-${transaction.montant} EUR', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        subtitle: Text(transaction.communication),
                      );
                    }
                  }
                );
              }
            },
          ),
        ),
      ),
    );
  }

  bool _containsTransaction(List<TransactionNotification> transactions, TransactionNotification transaction) {
    return transactions.any((element) =>
    element.id == transaction.id &&
        element.expediteur_id == transaction.expediteur_id &&
        element.expediteur_card_id == transaction.expediteur_card_id &&
        element.destinataire_card_id == transaction.destinataire_card_id &&
        element.montant == transaction.montant &&
        element.communication == transaction.communication &&
        element.date.isAtSameMomentAs(transaction.date) &&
        element.qr_code == transaction.qr_code &&
        element.read == transaction.read);
  }

  Future<List<TransactionNotification>> getTransactions() async {
    QuerySnapshot senderQuerySnapshot = await _notificationCollection
        .where('expediteur_id', isEqualTo: widget.client!.id)
        .get();

    QuerySnapshot recipientQuerySnapshot = await _notificationCollection
        .where('destinataire_card_id', isEqualTo: widget.client!.card_id)
        .get();

    QuerySnapshot recipient2QuerySnapshot = await _notificationCollection
        .where('destinataire_card_id', isEqualTo: widget.client!.card_id_2)
        .get();

    List<TransactionNotification> transactions = [];

    for (var doc in senderQuerySnapshot.docs) {
      TransactionNotification transaction = TransactionNotification.fromMap(doc.data() as Map<String, dynamic>);
      if (!_containsTransaction(transactions, transaction)) {
        transactions.add(transaction);
      }
    }

    for (var doc in recipientQuerySnapshot.docs) {
      TransactionNotification transaction = TransactionNotification.fromMap(doc.data() as Map<String, dynamic>);
      transactions.add(transaction);
      // Compte épargne -> Compte à vue (doublon autorisé)
    }

    for (var doc in recipient2QuerySnapshot.docs) {
      TransactionNotification transaction = TransactionNotification.fromMap(doc.data() as Map<String, dynamic>);
      transactions.add(transaction);
      // Compte à vue -> Compte épargne (doublon autorisé)
    }

    transactions.sort((a, b) => b.date.compareTo(a.date));

    return transactions;
  }
}
