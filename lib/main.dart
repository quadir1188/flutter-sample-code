import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Transfer {
  final String date;
  final String description;
  final double amount;
  final String accountNumber;
  final String currency;

  Transfer({
    required this.date,
    required this.description,
    required this.amount,
    required this.accountNumber,
    required this.currency,
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Transfer> transfers = [
    Transfer(
      date: '2023-09-12',
      description: 'Transfer from Account A',
      amount: 1000.0,
      accountNumber: '12345678',
      currency: 'USD',
    ),
    Transfer(
      date: '2023-09-11',
      description: 'Transfer to Account B',
      amount: -500.0,
      accountNumber: '98765432',
      currency: 'EUR',
    ),
    Transfer(
      date: '2023-09-10',
      description: 'Transfer from Account C',
      amount: 750.0,
      accountNumber: '56789012',
      currency: 'GBP',
    ),
    Transfer(
      date: '2023-09-09',
      description: 'Transfer to Account D',
      amount: -300.0,
      accountNumber: '34567890',
      currency: 'USD',
    ),
    Transfer(
      date: '2023-09-08',
      description: 'Transfer from Account E',
      amount: 1200.0,
      accountNumber: '23456789',
      currency: 'EUR',
    ),
    Transfer(
      date: '2023-09-07',
      description: 'Transfer to Account F',
      amount: -600.0,
      accountNumber: '45678901',
      currency: 'GBP',
    ),
    Transfer(
      date: '2023-09-06',
      description: 'Transfer from Account G',
      amount: 900.0,
      accountNumber: '67890123',
      currency: 'USD',
    ),
    Transfer(
      date: '2023-09-12',
      description: 'Transfer from Account A',
      amount: 1000.0,
      accountNumber: '67890123',
      currency: 'EUR',
    ),
    Transfer(
      date: '2023-09-11',
      description: 'Transfer to Account B',
      amount: -500.0,
      accountNumber: '56789012',
      currency: 'USD',
    ),
    Transfer(
      date: '2023-09-11',
      description: 'Transfer from Account C',
      amount: 750.0,
      accountNumber: '56789012',
      currency: 'GBP',
    ),
    Transfer(
      date: '2023-09-09',
      description: 'Transfer to Account D',
      amount: -300.0,
      accountNumber: '23456789',
      currency: 'GBP',
    ),
    Transfer(
      date: '2023-09-08',
      description: 'Transfer from Account E',
      amount: 1200.0,
      accountNumber: '23456789',
      currency: 'EUR',
    ),
    Transfer(
      date: '2023-09-07',
      description: 'Transfer to Account F',
      amount: -600.0,
      accountNumber: '45678901',
      currency: 'GBP',
    ),
    Transfer(
      date: '2023-09-06',
      description: 'Transfer from Account G',
      amount: 900.0,
      accountNumber: '67890123',
      currency: 'USD',
    ),
    // Add more Transfer entries here with account numbers and currencies.
  ];

  List<Transfer> filteredTransfers = [];

  String dateDropdownValue = 'All';
  String descriptionDropdownValue = 'All';
  String amountDropdownValue = 'All';
  String accountDropdownValue = 'All';
  String currencyDropdownValue = 'All';

  @override
  void initState() {
    super.initState();
    // Initially, set the filteredTransfers to the original transfers list.
    filteredTransfers = List.from(transfers);
  }

  void filterData() {
    setState(() {
      filteredTransfers = transfers
          .where((transfer) {
        if (dateDropdownValue != 'All' && transfer.date != dateDropdownValue) return false;
        if (descriptionDropdownValue != 'All' &&
            !transfer.description.toLowerCase().contains(descriptionDropdownValue.toLowerCase())) return false;
        if (amountDropdownValue != 'All' && transfer.amount.toString() != amountDropdownValue) return false;
        if (accountDropdownValue != 'All' && transfer.accountNumber != accountDropdownValue) return false;
        if (currencyDropdownValue != 'All' && transfer.currency != currencyDropdownValue) return false;
        return true;
      })
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Account Transfer Data Table',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Account Transfer Data Table'),
        ),
        body: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<String>(
                  value: dateDropdownValue,
                  onChanged: (value) {
                    setState(() {
                      dateDropdownValue = value!;
                      filterData();
                    });
                  },
                  items: [
                    'All',
                    '2023-09-12',
                    '2023-09-11',
                    '2023-09-10',
                    '2023-09-09',
                    '2023-09-08',
                    '2023-09-07',
                    '2023-09-06',
                  ] // Add more date options here.
                      .map<DropdownMenuItem<String>>(
                        (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  )
                      .toList(),
                ),
                DropdownButton<String>(
                  value: descriptionDropdownValue,
                  onChanged: (value) {
                    setState(() {
                      descriptionDropdownValue = value!;
                      filterData();
                    });
                  },
                  items: [
                    'All',
                    'Transfer from',
                    'Transfer to',
                  ] // Add more description options here.
                      .map<DropdownMenuItem<String>>(
                        (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  )
                      .toList(),
                ),
                DropdownButton<String>(
                  value: amountDropdownValue,
                  onChanged: (value) {
                    setState(() {
                      amountDropdownValue = value!;
                      filterData();
                    });
                  },
                  items: [
                    'All',
                    '1000.0',
                    '-500.0',
                    '750.0',
                    '-300.0',
                    '1200.0',
                    '-600.0',
                    '900.0',
                  ] // Add more amount options here.
                      .map<DropdownMenuItem<String>>(
                        (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  )
                      .toList(),
                ),
                DropdownButton<String>(
                  value: accountDropdownValue,
                  onChanged: (value) {
                    setState(() {
                      accountDropdownValue = value!;
                      filterData();
                    });
                  },
                  items: [
                    'All',
                    '12345678',
                    '98765432',
                    '56789012',
                    '34567890',
                    '23456789',
                    '45678901',
                    '67890123',
                  ] // Add more account number options here.
                      .map<DropdownMenuItem<String>>(
                        (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  )
                      .toList(),
                ),
                DropdownButton<String>(
                  value: currencyDropdownValue,
                  onChanged: (value) {
                    setState(() {
                      currencyDropdownValue = value!;
                      filterData();
                    });
                  },
                  items: [
                    'All',
                    'USD',
                    'EUR',
                    'GBP',
                  ] // Add more currency options here.
                      .map<DropdownMenuItem<String>>(
                        (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  )
                      .toList(),
                ),
              ],
            ),
            DataTable(
              columns: <DataColumn>[
                DataColumn(
                  label: Text('Date'),
                ),
                DataColumn(
                  label: Text('Description'),
                ),
                DataColumn(
                  label: Text('Amount'),
                ),
                DataColumn(
                  label: Text('Account Number'),
                ),
                DataColumn(
                  label: Text('Currency'),
                ),
              ],
              rows: filteredTransfers
                  .map(
                    (transfer) => DataRow(
                  cells: <DataCell>[
                    DataCell(Text(transfer.date)),
                    DataCell(Text(transfer.description)),
                    DataCell(Text('\$${transfer.amount.toStringAsFixed(2)}')),
                    DataCell(Text(transfer.accountNumber)),
                    DataCell(Text(transfer.currency)),
                  ],
                ),
              )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
