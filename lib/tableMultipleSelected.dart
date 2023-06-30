import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

enum SortOrder { Ascending, Descending }

class AccountTransfer {
  final String fromAccount;
  final String toAccount;
  final double amount;
  final DateTime date;

  AccountTransfer({
    required this.fromAccount,
    required this.toAccount,
    required this.amount,
    required this.date,
  });
}

final accountTransfersProvider =
StateProvider<List<AccountTransfer>>((ref) {
  return [
    AccountTransfer(
      fromAccount: 'Account A',
      toAccount: 'Account B',
      amount: 10.0,
      date: DateTime(2023, 6, 10),
    ),
    AccountTransfer(
      fromAccount: 'Account C',
      toAccount: 'Account D',
      amount: 20.0,
      date: DateTime(2023, 6, 2),
    ),
    AccountTransfer(
      fromAccount: 'Account E',
      toAccount: 'Account F',
      amount: 30.0,
      date: DateTime(2023, 5, 23),
    ),
    AccountTransfer(
      fromAccount: 'Account G',
      toAccount: 'Account H',
      amount: 1000.0,
      date: DateTime(2023, 5, 10),
    ),
    AccountTransfer(
      fromAccount: 'Account I',
      toAccount: 'Account J',
      amount: 2000.0,
      date: DateTime(2023, 4, 20),
    ),
    AccountTransfer(
      fromAccount: 'Account K',
      toAccount: 'Account L',
      amount: 3000.0,
      date: DateTime(2023, 4, 5),
    ),
  ];
});

final sortOrderProvider = StateProvider<SortOrder>((ref) => SortOrder.Ascending);
final sortColumnIndexProvider = StateProvider<int>((ref) => -1);

final selectedAccountsProvider = StateProvider<List<AccountTransfer>>((ref) => []);

class AccountTransferTable extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountTransfers = ref.watch(accountTransfersProvider);
    final sortOrder = ref.watch(sortOrderProvider);
    final sortColumnIndex = ref.watch(sortColumnIndexProvider);

    accountTransfers.sort((a, b) {
      if (sortColumnIndex == 0) {
        if (sortOrder == SortOrder.Ascending) {
          return a.fromAccount.compareTo(b.fromAccount);
        } else {
          return b.fromAccount.compareTo(a.fromAccount);
        }
      } else if (sortColumnIndex == 1) {
        if (sortOrder == SortOrder.Ascending) {
          return a.toAccount.compareTo(b.toAccount);
        } else {
          return b.toAccount.compareTo(a.toAccount);
        }
      } else if (sortColumnIndex == 2) {
        if (sortOrder == SortOrder.Ascending) {
          return a.amount.compareTo(b.amount);
        } else {
          return b.amount.compareTo(a.amount);
        }
      } else if (sortColumnIndex == 3) {
        if (sortOrder == SortOrder.Ascending) {
          return a.date.compareTo(b.date);
        } else {
          return b.date.compareTo(a.date);
        }
      } else {
        return 0;
      }
    });

    return Column(
      children: [
        DataTable(
          columns: [
            DataColumn(
              label: Row(
                children: [
                  Text('From Account'),
                  buildSortIcon(sortColumnIndex, 0, sortOrder),
                ],
              ),
              onSort: (columnIndex, _) {
                ref.read(sortColumnIndexProvider.notifier).state =
                    columnIndex;
                toggleSortOrder(context, ref);
              },
            ),
            DataColumn(
              label: Row(
                children: [
                  Text('To Account'),
                  buildSortIcon(sortColumnIndex, 1, sortOrder),
                ],
              ),
              onSort: (columnIndex, _) {
                ref.read(sortColumnIndexProvider.notifier).state =
                    columnIndex;
                toggleSortOrder(context, ref);
              },
            ),
            DataColumn(
              label: Row(
                children: [
                  Text('Amount'),
                  buildSortIcon(sortColumnIndex, 2, sortOrder),
                ],
              ),
              onSort: (columnIndex, _) {
                ref.read(sortColumnIndexProvider.notifier).state =
                    columnIndex;
                toggleSortOrder(context, ref);
              },
            ),
            DataColumn(
              label: Row(
                children: [
                  Text('Date'),
                  buildSortIcon(sortColumnIndex, 3, sortOrder),
                ],
              ),
              onSort: (columnIndex, _) {
                ref.read(sortColumnIndexProvider.notifier).state =
                    columnIndex;
                toggleSortOrder(context, ref);
              },
            ),
          ],
          rows: accountTransfers.map((transfer) {
            return DataRow(cells: [
              DataCell(Text(transfer.fromAccount)),
              DataCell(Text(transfer.toAccount)),
              DataCell(Text(transfer.amount.toString())),
              DataCell(Text(transfer.date.toString())),
            ]);
          }).toList(),
        ),
      ],
    );
  }

  Widget buildSortIcon(
      int sortColumnIndex, int columnIndex, SortOrder sortOrder) {
    if (sortColumnIndex == columnIndex) {
      return sortOrder == SortOrder.Ascending
          ? Icon(Icons.arrow_upward)
          : Icon(Icons.arrow_downward);
    }
    return Icon(Icons.unfold_more);
  }

  void toggleSortOrder(BuildContext context, WidgetRef ref) {
    final sortOrder = ref.read(sortOrderProvider.notifier).state;
    ref.read(sortOrderProvider.notifier).state = sortOrder ==
        SortOrder.Ascending
        ? SortOrder.Descending
        : SortOrder.Ascending;
  }
}

class AccountTransferSelectionButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAccounts = ref.watch(selectedAccountsProvider.notifier).state;
    return ElevatedButton(
      onPressed: () async {
        final selectedAccountsResult = await showDialog<List<AccountTransfer>>(
          context: context,
          builder: (BuildContext context) {
            return MultiSelectDialog<AccountTransfer>(
              items: ref.watch(accountTransfersProvider.notifier).state.map((e) => MultiSelectItem(e, e.fromAccount)).toList(),
              initialValue: selectedAccounts.toList(),
              onConfirm: (List<AccountTransfer>? values) {
                ref.read(selectedAccountsProvider.notifier).state = values?.toList() ?? [];
               // Navigator.of(context).pop(values);
              },
            );
          },
        );

        if (selectedAccountsResult != null) {
          // Handle selected accounts
          print('Selected Accounts: $selectedAccountsResult');
        }
      },
      child: Text('Select Accounts'),
    );
  }
}

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Account Transfers')),
          body: Column(
            children: [
              AccountTransferSelectionButton(),
              Expanded(child: AccountTransferTable()),
            ],
          ),
        ),
      ),
    ),
  );
}
