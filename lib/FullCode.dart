import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class Account {
  final int id;
  final String name;
  final String email;
  final double balance;

  Account({
    required this.id,
    required this.name,
    required this.email,
    required this.balance,
  });
}

final accountProvider = Provider<Account>((ref) {
  return Account(
    id: 1,
    name: 'John Doe',
    email: 'johndoe@example.com',
    balance: 1000.0,
  );
});

final filterProvider = StateProvider<String>((ref) => 'ID');

class AccountInfo extends ConsumerWidget {
  final List<String> filterOptions = ['ID', 'Name', 'Email'];

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final account = watch(accountProvider);
    final filterBy = watch(filterProvider).state;

    List<TableRow> filterAccounts() {
      switch (filterBy) {
        case 'ID':
          return [
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
          ];
        case 'Name':
          return [
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
          ];
        case 'Email':
          return [
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
          ];
        default:
          return [];
      }
    }

    return Column(
      children: [
        DropdownButton<String>(
          value: filterBy,
          onChanged: (String? newValue) {
            if (newValue != null) {
              context.read(filterProvider).state = newValue;
            }
          },
          items: filterOptions.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        Table(
          border: TableBorder.all(),
          children: filterAccounts(),
        ),
      ],
    );
  }
}

