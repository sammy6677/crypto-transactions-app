import 'package:crypto_transactions/models/crypto_transaction.dart';
import 'package:crypto_transactions/services/transaction_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

CryptoTransaction tx(String id, TxType type, double amount, double price) => CryptoTransaction(
    id: id, type: type, coin: 'BTC', amount: amount, priceUsd: price, date: DateTime(2025, 1, int.parse(id)));

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('holdings and net invested', () async {
    SharedPreferences.setMockInitialValues({});
    final s = TransactionService();
    await s.load();
    await s.add(tx('1', TxType.buy, 1.0, 40000));
    await s.add(tx('2', TxType.sell, 0.25, 60000));
    await s.add(tx('3', TxType.send, 0.25, 60000));
    expect(s.holdings()['BTC'], 0.5);
    expect(s.netInvested(), 40000 - 15000);
  });

  test('saved transactions load again', () async {
    SharedPreferences.setMockInitialValues({});
    final first = TransactionService();
    await first.load();
    await first.add(tx('1', TxType.buy, 2, 100));
    final again = TransactionService();
    await again.load();
    expect(again.all.single.totalUsd, 200);
  });
}
