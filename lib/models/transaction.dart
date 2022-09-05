class Transaction {
  String id;
  num total;
  String createdAt;

  Transaction({
    required this.id,
    required this.total,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
        id: json['_id'], total: json['total'], createdAt: json['createdAt']);
  }
}
