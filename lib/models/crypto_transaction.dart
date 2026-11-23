enum TxType { buy, sell, send, receive }

extension TxTypeX on TxType {
  String get label => name[0].toUpperCase() + name.substring(1);

  /// +1 when the transaction adds coins to the wallet, -1 when it removes them.
  int get direction => (this == TxType.buy || this == TxType.receive) ? 1 : -1;
}

class CryptoTransaction {
  final String id;
  final TxType type;
  final String coin; // e.g. BTC
  final double amount; // coins
  final double priceUsd; // price per coin at the time
  final DateTime date;
  final String? note;

  const CryptoTransaction({
    required this.id,
    required this.type,
    required this.coin,
    required this.amount,
    required this.priceUsd,
    required this.date,
    this.note,
  });

  double get totalUsd => amount * priceUsd;

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'coin': coin,
        'amount': amount,
        'priceUsd': priceUsd,
        'date': date.toIso8601String(),
        'note': note,
      };

  factory CryptoTransaction.fromJson(Map<String, dynamic> j) => CryptoTransaction(
        id: j['id'] as String,
        type: TxType.values.byName(j['type'] as String),
        coin: j['coin'] as String,
        amount: (j['amount'] as num).toDouble(),
        priceUsd: (j['priceUsd'] as num).toDouble(),
        date: DateTime.parse(j['date'] as String),
        note: j['note'] as String?,
      );
}
