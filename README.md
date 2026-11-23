# Crypto Transactions – Flutter App

> **Demo version – simplified rebuild.** It shows the app's core idea and structure. The original app's Firebase configuration is deliberately not included.

A cross-platform mobile app (Android and iOS) for recording crypto **buys, sells, sends and receives** and seeing your portfolio at a glance.

## Features

- **Portfolio summary:** net USD invested, number of transactions, and coins held per symbol (BTC, ETH…)
- **Add a transaction:** type, coin, amount, price per coin, date and an optional note, with input checks
- **Filter** by Buy / Sell / Send / Receive
- **Swipe to delete**
- Saved on the device, so transactions survive app restarts
- Material 3 design with light and dark themes

## Architecture

The app uses the [Stacked](https://pub.dev/packages/stacked) MVVM pattern:

```
lib/
├── main.dart
├── models/crypto_transaction.dart        # data model + JSON
├── services/transaction_service.dart     # storage, holdings & totals
└── ui/
    ├── views/home/home_view.dart         # screen
    ├── views/home/home_viewmodel.dart    # state & actions
    └── widgets/add_transaction_sheet.dart
test/transaction_service_test.dart        # unit tests for the maths
```

`TransactionService` is the only place that stores data. To sync across devices, replace it with a Cloud Firestore version. The original project is set up for Firebase, but its config files are kept out of this public repo.

## Run it

```bash
flutter create . --platforms=android,ios
```

```bash
flutter pub get
```

```bash
flutter run
```

Run the tests with `flutter test`.
