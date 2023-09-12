import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

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
  // ...

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
    // Add more Transfer entries here with account numbers and currencies.
    Transfer(
      date: '2023-09-05',
      description: 'Transfer to Account H',
      amount: -400.0,
      accountNumber: '78901234',
      currency: 'EUR',
    ),
    Transfer(
      date: '2023-09-04',
      description: 'Transfer from Account I',
      amount: 1500.0,
      accountNumber: '89012345',
      currency: 'GBP',
    ),
    Transfer(
      date: '2023-09-03',
      description: 'Transfer to Account J',
      amount: -800.0,
      accountNumber: '90123456',
      currency: 'USD',
    ),
    Transfer(
      date: '2023-09-02',
      description: 'Transfer from Account K',
      amount: 600.0,
      accountNumber: '01234567',
      currency: 'EUR',
    ),
    // Add more Transfer entries here.
  ];

// ...


  List<Transfer> filteredTransfers = [];

  List<String> dateSelectedValues = [];
  List<String> descriptionSelectedValues = [];
  List<String> amountSelectedValues = [];
  List<String> accountSelectedValues = [];
  List<String> currencySelectedValues = [];

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
        bool dateMatch = dateSelectedValues.isEmpty || dateSelectedValues.contains(transfer.date);
        bool descriptionMatch = descriptionSelectedValues.isEmpty ||
            descriptionSelectedValues.any((value) => transfer.description.toLowerCase().contains(value.toLowerCase()));
        bool amountMatch = amountSelectedValues.isEmpty || amountSelectedValues.contains(transfer.amount.toString());
        bool accountMatch = accountSelectedValues.isEmpty || accountSelectedValues.contains(transfer.accountNumber);
        bool currencyMatch = currencySelectedValues.isEmpty || currencySelectedValues.contains(transfer.currency);
        return dateMatch && descriptionMatch && amountMatch && accountMatch && currencyMatch;
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
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MultiSelectDialogField<String>(
                  items: ['All', '2023-09-12', '2023-09-11', '2023-09-10', '2023-09-09', '2023-09-08', '2023-09-07', '2023-09-06']
                      .map((value) => MultiSelectItem<String>(value,value))
                      .toList(),
                  listType: MultiSelectListType.CHIP,
                  onConfirm: (values) {
                    dateSelectedValues = values ?? [];
                    filterData();
                  },
                  buttonText: Text('Date'),
                ),
                MultiSelectDialogField<String>(
                  items: ['All', 'Transfer from', 'Transfer to']
                      .map((value) => MultiSelectItem<String>(  value,value))
                      .toList(),
                  listType: MultiSelectListType.CHIP,
                  onConfirm: (values) {
                    descriptionSelectedValues = values ?? [];
                    filterData();
                  },
                  buttonText: Text('Description'),
                ),
                MultiSelectDialogField<String>(
                  items: ['All', '1000.0', '-500.0', '750.0', '-300.0', '1200.0', '-600.0', '900.0']
                      .map((value) => MultiSelectItem<String>( value,  value))
                      .toList(),
                  listType: MultiSelectListType.CHIP,
                  onConfirm: (values) {
                    amountSelectedValues = values ?? [];
                    filterData();
                  },
                  buttonText: Text('Amount'),
                ),
                MultiSelectDialogField<String>(
                  items: ['All', '12345678', '98765432', '56789012', '34567890', '23456789', '45678901', '67890123']
                      .map((value) => MultiSelectItem<String>(value, value))
                      .toList(),
                  listType: MultiSelectListType.CHIP,
                  onConfirm: (values) {
                    accountSelectedValues = values ?? [];
                    filterData();
                  },
                  buttonText: Text('Account Number'),
                ),
                MultiSelectDialogField<String>(
                  items: ['All', 'USD', 'EUR', 'GBP']
                      .map((value) => MultiSelectItem<String>(value,  value))
                      .toList(),
                  listType: MultiSelectListType.CHIP,
                  onConfirm: (values) {
                    currencySelectedValues = values ?? [];
                    filterData();
                  },
                  buttonText: Text('Currency'),
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
