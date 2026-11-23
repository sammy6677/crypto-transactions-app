import 'package:flutter/material.dart';

import '../../models/crypto_transaction.dart';

class AddTransactionSheet extends StatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final _form = GlobalKey<FormState>();
  final _coin = TextEditingController(text: 'BTC');
  final _amount = TextEditingController();
  final _price = TextEditingController();
  final _note = TextEditingController();
  TxType _type = TxType.buy;
  DateTime _date = DateTime.now();

  String? _positive(String? v) {
    final n = double.tryParse((v ?? '').replaceAll(',', ''));
    return (n == null || n <= 0) ? 'Enter a number above 0' : null;
  }

  void _save() {
    if (!_form.currentState!.validate()) return;
    Navigator.pop(
      context,
      CryptoTransaction(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        type: _type,
        coin: _coin.text.trim().toUpperCase(),
        amount: double.parse(_amount.text.replaceAll(',', '')),
        priceUsd: double.parse(_price.text.replaceAll(',', '')),
        date: _date,
        note: _note.text.trim().isEmpty ? null : _note.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('New transaction', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            SegmentedButton<TxType>(
              segments: [for (final t in TxType.values) ButtonSegment(value: t, label: Text(t.label))],
              selected: {_type},
              onSelectionChanged: (s) => setState(() => _type = s.first),
            ),
            TextFormField(
              controller: _coin,
              decoration: const InputDecoration(labelText: 'Coin (e.g. BTC, ETH)'),
              textCapitalization: TextCapitalization.characters,
              validator: (v) => (v ?? '').trim().isEmpty ? 'Enter a coin' : null,
            ),
            TextFormField(
              controller: _amount,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: _positive,
            ),
            TextFormField(
              controller: _price,
              decoration: const InputDecoration(labelText: 'Price per coin (USD)'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: _positive,
            ),
            TextFormField(controller: _note, decoration: const InputDecoration(labelText: 'Note (optional)')),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date'),
              subtitle: Text(MaterialLocalizations.of(context).formatMediumDate(_date)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final d = await showDatePicker(
                    context: context, initialDate: _date, firstDate: DateTime(2009), lastDate: DateTime.now());
                if (d != null) setState(() => _date = d);
              },
            ),
            FilledButton(onPressed: _save, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
