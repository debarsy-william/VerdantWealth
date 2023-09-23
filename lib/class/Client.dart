class Client {
  int id;
  String nom;
  String prenom;
  String email;
  String password;
  String code;
  int card_id;
  int card_id_2;
  bool first_connection;
  dynamic balance;
  dynamic balance_2;

  Client({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.password,
    required this.code,
    required this.card_id,
    required this.card_id_2,
    required this.balance,
    required this.balance_2,
    required this.first_connection,
  });

  Client.empty()
      : id = 0,
        nom = '',
        prenom = '',
        email = '',
        password = '',
        code = '',
        card_id = 0,
        card_id_2 = 0,
        balance = 0.0,
        balance_2 = 0.0,
        first_connection = true;

  // Méthode pour convertir un objet Client en Map (utile pour sauvegarder dans Firebase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'password': password,
      'code': code,
      'card_id': card_id,
      'card_id_2': card_id_2,
      'balance': balance,
      'balance_2': balance_2,
      'first_connection': first_connection,
    };
  }

  // Méthode pour créer un objet Client à partir d'un Map (par exemple, pour récupérer depuis Firebase)
  static Client fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'] ?? 0,
      nom: map['nom'] ?? '',
      prenom: map['prenom'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      code: map['code'] ?? '',
      card_id: map['card_id'] ?? 0,
      card_id_2: map['card_id_2'] ?? 0,
      balance: map['balance'] ?? 0.0,
      balance_2: map['balance_2'] ?? 0.0,
      first_connection: map['first_connection'],
    );
  }
}