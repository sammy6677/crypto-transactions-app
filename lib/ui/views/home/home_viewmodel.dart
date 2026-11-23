import 'package:stacked/stacked.dart';

import '../../../models/crypto_transaction.dart';
import '../../../services/transaction_service.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel(this._service);

  final TransactionService _service;
  TxType? filter;

  List<CryptoTransaction> get transactions =>
      filter == null ? _service.all : _service.all.where((t) => t.type == filter).toList();
  Map<String, double> get holdings => _service.holdings();
  double get netInvested => _service.netInvested();
  int get count => _service.all.length;

  Future<void> init() => runBusyFuture(_service.load());

  void setFilter(TxType? value) {
    filter = value;
    notifyListeners();
  }

  Future<void> add(CryptoTransaction tx) async {
    await _service.add(tx);
    notifyListeners();
  }

  Future<void> remove(String id) async {
    await _service.remove(id);
    notifyListeners();
  }
}
