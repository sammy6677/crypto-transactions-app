import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/crypto_transaction.dart';

/// Stores transactions on the device (shared_preferences).
/// Swap this class for a Firestore-backed one to sync across devices.
class TransactionService {
  static const _key = 'transactions';
  final List<CryptoTransaction> _items = [];

  List<CryptoTransaction> get all =>
      List.unmodifiable(_items..sort((a, b) => b.date.compareTo(a.date)));

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    _items.clear();
    if (raw != null) {
      _items.addAll((jsonDecode(raw) as List)
          .map((e) => CryptoTransaction.fromJson(e as Map<String, dynamic>)));
    }
  }

  Future<void> add(CryptoTransaction tx) async {
    _items.add(tx);
    await _save();
  }

  Future<void> remove(String id) async {
    _items.removeWhere((t) => t.id == id);
    await _save();
  }

  /// Coins currently held per symbol (buys + receives − sells − sends).
  Map<String, double> holdings() {
    final map = <String, double>{};
    for (final t in _items) {
      map[t.coin] = (map[t.coin] ?? 0) + t.direction * t.amount;
    }
    map.removeWhere((_, v) => v.abs() < 1e-12);
    return map;
  }

  /// Net USD spent: buys minus sells.
  double netInvested() => _items.fold(0, (sum, t) {
        if (t.type == TxType.buy) return sum + t.totalUsd;
        if (t.type == TxType.sell) return sum - t.totalUsd;
        return sum;
      });

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(_items.map((t) => t.toJson()).toList()));
  }
}
