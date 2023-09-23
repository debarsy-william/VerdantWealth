import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examen_dam_info_debarsywilliamchapelierbasile/pages/SettingsPage.dart';
import 'package:examen_dam_info_debarsywilliamchapelierbasile/pages/WelcomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../class/Client.dart';
import '../class/TransactionNotification.dart';
import 'TransactionPage.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class HomePage extends StatefulWidget {
  final int clientID;
  const HomePage({Key? key, required this.clientID}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  Client? client;
  bool isLoading = true;
  int unreadNotifications = 0;
  setCurrentPage(int page)
  {
    setState(() {
      if (page == 1 || _currentIndex == 1)
        {
          unreadNotifications = 0;
        }
      _currentIndex = page;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await setDataClient(widget.clientID);
      getTransactionsClient();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body : IndexedStack(
            index: _currentIndex,
            children: [
              WelcomePage(clientID: widget.clientID),
              TransactionPage(client: client),
              SettingsPage(clientID: widget.clientID),
            ],
          ),
          appBar: AppBar(
            backgroundColor: Colors.green[800],
            automaticallyImplyLeading: false,
            title: _currentIndex == 0
                ? (isLoading
                ? const CircularProgressIndicator(
              color: Colors.green,
            )
                : Text('Bonjour ${client?.prenom}'))
                : Text(["Transactions", "Paramètres"][_currentIndex - 1]),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setCurrentPage(index),
            backgroundColor: Colors.green[800],
            elevation: 10,
            iconSize: 28,
            selectedItemColor: Colors.lightGreen[500],
            unselectedFontSize: 15,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 8), // Ajoutez une marge à droite pour éviter le chevauchement
                      child: Icon(Icons.monetization_on_outlined),
                    ),
                    if (unreadNotifications > 0)
                      Positioned(
                        top: 0,
                        right: 0, // Ajustez cette valeur pour faire de la place à gauche de l'icône
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                          ),
                          child: Center(
                            child: Text(
                              unreadNotifications.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                label: 'Transactions',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Paramètres',
              ),
            ],
          ),
        ),
    );
  }

  Future<void> setDataClient(int id) async
  {
    CollectionReference clientsCollection = FirebaseFirestore.instance.collection('Client');
    try {
      QuerySnapshot snapshot = await clientsCollection.where('id', isEqualTo: id).get();
      Client client2 = Client.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
      setState(() {
        client = client2;
        isLoading = false;
      });
      //print('Data du client connecté : ${client2.id} ; ${client2.prenom} ; ${client2.nom} ; ${client2.email} ; ${client2.card_id} ; ${client2.balance}');
    } catch (e) {
      //print('Error: $e');
    }
  }

  void showNotifications(TransactionNotification transaction) {

    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('001', 'Local Notification',
        channelDescription: 'To send local notification');

    const NotificationDetails details =
    NotificationDetails(android: androidNotificationDetails);
    flutterLocalNotificationsPlugin.show(
        transaction.id, 'Paiement reçu de ${transaction.expediteur_card_id}' , transaction.communication, details);
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

  Future<void> getTransactionsClient() async {
    Stream<QuerySnapshot<Map<String, dynamic>>> notificationStream = FirebaseFirestore.instance.collection("Notification").snapshots();

    notificationStream.listen((event) async {
      if(event.docs.isEmpty) {
        return;
      }

      CollectionReference notificationCollection = FirebaseFirestore.instance.collection('Notification');
      QuerySnapshot senderQuerySnapshot = await notificationCollection
          .where('expediteur_id', isEqualTo: client!.id)
          .where('qr_code', isEqualTo: false)
          .where('read', isEqualTo: false)
          .get();

      QuerySnapshot recipientQuerySnapshot = await notificationCollection
          .where('destinataire_card_id', isEqualTo: client!.card_id)
          .where('qr_code', isEqualTo: false)
          .where('read', isEqualTo: false)
          .get();

      QuerySnapshot recipient2QuerySnapshot = await notificationCollection
          .where('destinataire_card_id', isEqualTo: client!.card_id_2)
          .where('qr_code', isEqualTo: false)
          .where('read', isEqualTo: false)
          .get();

      List<TransactionNotification> transactions = [];

      for (var doc in senderQuerySnapshot.docs) {
        TransactionNotification transaction = TransactionNotification.fromMap(doc.data() as Map<String, dynamic>);
        // UPDATE DU CHAMP READ
        if (!transaction.read)
        {
          FirebaseFirestore.instance.runTransaction((transaction) async {
            DocumentSnapshot dataTransac = doc;
            transaction.update(dataTransac.reference, {
              'read': true,
            });
          });
          if (!_containsTransaction(transactions, transaction)) {
            transactions.add(transaction);
          }
        }
      }

      for (var doc in recipientQuerySnapshot.docs) {
        TransactionNotification transaction = TransactionNotification.fromMap(doc.data() as Map<String, dynamic>);
        // UPDATE DU CHAMP READ
        if (!transaction.read)
        {
          FirebaseFirestore.instance.runTransaction((transaction) async {
            DocumentSnapshot dataTransac = doc;
            transaction.update(dataTransac.reference, {
              'read': true,
            });
          });
          if (!_containsTransaction(transactions, transaction)) {
            transactions.add(transaction);
          }
        }
      }

      for (var doc in recipient2QuerySnapshot.docs) {
        TransactionNotification transaction = TransactionNotification.fromMap(doc.data() as Map<String, dynamic>);
        // UPDATE DU CHAMP READ
        if (!transaction.read)
        {
          FirebaseFirestore.instance.runTransaction((transaction) async {
            DocumentSnapshot dataTransac = doc;
            transaction.update(dataTransac.reference, {
              'read': true,
            });
          });
          if (!_containsTransaction(transactions, transaction)) {
            transactions.add(transaction);
          }
        }
      }

      for (int i=0;i<transactions.length;i++)
        {
          //print("${transactions[i].expediteur_id} et ${widget.clientID}");
          if(transactions[i].expediteur_id != widget.clientID) {
            showNotifications(transactions[i]);
          }
          setState(() {
            unreadNotifications++;
          });
        }
    });
  }
}