import 'package:flutter/material.dart';

import 'services/transaction_service.dart';
import 'ui/views/home/home_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(CryptoTransactionsApp(service: TransactionService()));
}

class CryptoTransactionsApp extends StatelessWidget {
  const CryptoTransactionsApp({super.key, required this.service});
  final TransactionService service;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Transactions',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: const Color(0xFF3B5BDB), useMaterial3: true),
      darkTheme: ThemeData(colorSchemeSeed: const Color(0xFF3B5BDB), brightness: Brightness.dark, useMaterial3: true),
      home: HomeView(service: service),
    );
  }
}
