import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionNotification {
  int id;
  int expediteur_id;
  int expediteur_card_id;
  int destinataire_card_id;
  dynamic montant;
  String communication;
  DateTime date;
  bool qr_code;
  bool read;

  TransactionNotification({
    required this.id,
    required this.expediteur_id,
    required this.expediteur_card_id,
    required this.destinataire_card_id,
    required this.montant,
    required this.communication,
    required this.date,
    required this.qr_code,
    required this.read,
  });

  // Méthode pour convertir un objet Transaction en Map (utile pour sauvegarder dans Firebase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expediteur_id': expediteur_id,
      'expediteur_card_id': expediteur_card_id,
      'destinataire_card_id': destinataire_card_id,
      'montant': montant,
      'communication': communication,
      'date': date,
      'qr_code': qr_code,
      'read': read,
    };
  }

  // Méthode pour créer un objet Transaction à partir d'un Map (par exemple, pour récupérer depuis Firebase)
  static TransactionNotification fromMap(Map<String, dynamic> map) {
    return TransactionNotification(
      id: map['id'] ?? 0,
      expediteur_id: map['expediteur_id'] ?? 0,
      expediteur_card_id: map['expediteur_card_id'] ?? 0,
      destinataire_card_id: map['destinataire_card_id'] ?? 0,
      montant: map['montant'] ?? 0.0,
      communication: map['communication'] ?? '',
      date: map['date'] != null ? (map['date'] as Timestamp).toDate() : DateTime.now(),
      qr_code: map['qr_code'] ?? false,
      read: map['read'] ?? false,
    );
  }
}