import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'account_provider.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Account Info',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Account Info'),
        ),
        body: Center(
          child: AccountInfo(),
        ),
      ),
    );
  }
}

class AccountInfo extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final account = watch(accountProvider);

    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(
          children: [
            TableCell(
              child: Text('ID'),
            ),
            TableCell(
              child: Text('${account.id}'),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Text('Name'),
            ),
            TableCell(
              child: Text('${account.name}'),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Text('Email'),
            ),
            TableCell(
              child: Text('${account.email}'),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Text('Balance'),
            ),
            TableCell(
              child: Text('${account.balance.toStringAsFixed(2)}'),
            ),
          ],
        ),
      ],
    );
  }
}
