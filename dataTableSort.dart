import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SortOrder { Ascending, Descending }

class AccountTransfer {
  final String fromAccount;
  final String toAccount;
  final double amount;

  AccountTransfer({required this.fromAccount, required this.toAccount, required this.amount});
}

final accountTransfersProvider = StateProvider<List<AccountTransfer>>((ref) {
  return [
    AccountTransfer(fromAccount: 'Account A', toAccount: 'Account B', amount: 100.0),
    AccountTransfer(fromAccount: 'Account C', toAccount: 'Account D', amount: 200.0),
    AccountTransfer(fromAccount: 'Account E', toAccount: 'Account F', amount: 300.0),
  ];
});

final sortOrderProvider = StateProvider<SortOrder>((ref) => SortOrder.Ascending);
final sortColumnIndexProvider = StateProvider<int>((ref) => -1);

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
                ref.read(sortColumnIndexProvider.notifier).state = columnIndex;
                toggleSortOrder(context,ref);
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
                ref.read(sortColumnIndexProvider.notifier).state = columnIndex;
                toggleSortOrder(context,ref);
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
                ref.read(sortColumnIndexProvider.notifier).state = columnIndex;
                toggleSortOrder(context,ref);
              },
            ),
          ],
          rows: accountTransfers.map((transfer) {
            return DataRow(cells: [
              DataCell(Text(transfer.fromAccount)),
              DataCell(Text(transfer.toAccount)),
              DataCell(Text(transfer.amount.toString())),
            ]);
          }).toList(),
        ),
      ],
    );
  }

  Widget buildSortIcon(int sortColumnIndex, int columnIndex, SortOrder sortOrder) {
    if (sortColumnIndex == columnIndex) {
      return sortOrder == SortOrder.Ascending
          ? Icon(Icons.arrow_upward)
          : Icon(Icons.arrow_downward);
    }
    return Icon(Icons.unfold_more);
  }

  void toggleSortOrder(BuildContext context, WidgetRef ref) {
    final sortOrder = ref.read(sortOrderProvider.notifier).state;
    ref.read(sortOrderProvider.notifier).state =
    sortOrder == SortOrder.Ascending ? SortOrder.Descending : SortOrder.Ascending;
  }
}

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Account Transfers')),
          body: AccountTransferTable(),
        ),
      ),
    ),
  );
}
