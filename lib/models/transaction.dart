class Transaction {
  String id;
  String nipd;
  num total;
  DateTime date;

  Transaction({
    required this.id,
    required this.nipd,
    required this.total,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
        id: json['_id'],
        nipd: json['nipd'],
        total: json['total'],
        date: json['createdAt']);
  }
}
