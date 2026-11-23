import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

import '../../../models/crypto_transaction.dart';
import '../../../services/transaction_service.dart';
import '../../widgets/add_transaction_sheet.dart';
import 'home_viewmodel.dart';

final _usd = NumberFormat.currency(symbol: '\$');
final _date = DateFormat('d MMM yyyy');

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.service});
  final TransactionService service;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(service),
      onViewModelReady: (vm) => vm.init(),
      builder: (context, vm, _) => Scaffold(
        appBar: AppBar(title: const Text('Crypto Transactions')),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final tx = await showModalBottomSheet<CryptoTransaction>(
              context: context,
              isScrollControlled: true,
              builder: (_) => const AddTransactionSheet(),
            );
            if (tx != null) await vm.add(tx);
          },
          icon: const Icon(Icons.add),
          label: const Text('Add'),
        ),
        body: vm.isBusy
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                children: [
                  _Summary(vm: vm),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(label: const Text('All'), selected: vm.filter == null, onSelected: (_) => vm.setFilter(null)),
                      for (final t in TxType.values)
                        ChoiceChip(label: Text(t.label), selected: vm.filter == t, onSelected: (_) => vm.setFilter(t)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (vm.transactions.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('No transactions yet. Tap Add to record your first one.', textAlign: TextAlign.center),
                    ),
                  for (final t in vm.transactions)
                    Dismissible(
                      key: ValueKey(t.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.red.shade400,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) => vm.remove(t.id),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: t.type.direction > 0 ? Colors.green.shade100 : Colors.orange.shade100,
                          child: Icon(t.type.direction > 0 ? Icons.south_west : Icons.north_east,
                              color: t.type.direction > 0 ? Colors.green.shade800 : Colors.orange.shade900),
                        ),
                        title: Text('${t.type.label} ${t.amount} ${t.coin}'),
                        subtitle: Text('${_date.format(t.date)} · @ ${_usd.format(t.priceUsd)}${t.note == null ? '' : ' · ${t.note}'}'),
                        trailing: Text(_usd.format(t.totalUsd), style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.vm});
  final HomeViewModel vm;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Net invested', style: TextStyle(color: scheme.onPrimaryContainer)),
            Text(_usd.format(vm.netInvested),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            Text('${vm.count} transactions'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final e in vm.holdings.entries)
                  Chip(label: Text('${e.key}: ${e.value.toStringAsFixed(e.value % 1 == 0 ? 0 : 6)}')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
