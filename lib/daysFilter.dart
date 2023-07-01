import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

enum SortOrder { Ascending, Descending }
enum FilterOption { Today, Weekly, Monthly }

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

class AccountTransferScreenWithDaysFilter extends StatelessWidget {
  const AccountTransferScreenWithDaysFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Account Transfers')),
          body:  Column(
            children: [
              AccountTransferSelectionButton(),
              SizedBox(height: 16),
              // SearchBox(),
              SizedBox(height: 16),
              AccountTransferTable(),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountTransferSelectionButton extends ConsumerWidget {
  const AccountTransferSelectionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAccounts = ref.watch(selectedAccountsProvider);
    return ElevatedButton(
      onPressed: () async {
        final selectedAccountsResult = await showDialog<List<AccountTransfer>>(
          context: context,
          builder: (BuildContext context) {
            return MultiSelectDialog<AccountTransfer>(
              items: ref
                  .watch(accountTransfersProvider)
                  .map((e) => MultiSelectItem(e, e.fromAccount))
                  .toList(),
              initialValue: selectedAccounts.toList(),
              onConfirm: (List<AccountTransfer>? values) {
                ref.read(selectedAccountsProvider.notifier).state = values?.toList() ?? [];
                var value = ref.watch(selectedAccountsProvider.notifier).state;
                print("selected value ${value.first.toAccount}");
              },
            );
          },
        );

        if (selectedAccountsResult != null) {
          // Handle selected accounts
          print('Selected Accounts: $selectedAccountsResult');
        }
      },
      child: const Text('Select Accounts'),
    );
  }
}

class AccountTransferTable extends ConsumerWidget {
  const AccountTransferTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountTransfers = ref.watch(accountTransfersProvider);
    final sortOrder = ref.watch(sortOrderProvider);
    final sortColumnIndex = ref.watch(sortColumnIndexProvider);
    final searchText = ref.watch(searchTextProvider);
    final filterOption = ref.watch(filterOptionProvider);

    List<AccountTransfer> filteredTransfers = accountTransfers
        .where((transfer) =>
    transfer.fromAccount.toLowerCase().contains(searchText) ||
        transfer.toAccount.toLowerCase().contains(searchText) ||
        transfer.amount.toString().contains(searchText) ||
        transfer.date.toString().contains(searchText))
        .toList();

    final now = DateTime.now();
    if (filterOption == FilterOption.Today) {
      filteredTransfers = filteredTransfers.where((transfer) {
        final date = transfer.date;
        return date.day == now.day && date.month == now.month && date.year == now.year;
      }).toList();
    } else if (filterOption == FilterOption.Weekly) {
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek = now.add(Duration(days: 7 - now.weekday));
      filteredTransfers = filteredTransfers.where((transfer) {
        final date = transfer.date;
        return date.isAfter(startOfWeek) && date.isBefore(endOfWeek);
      }).toList();
    } else if (filterOption == FilterOption.Monthly) {
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0);
      filteredTransfers = filteredTransfers.where((transfer) {
        final date = transfer.date;
        return date.isAfter(startOfMonth) && date.isBefore(endOfMonth);
      }).toList();
    }

    filteredTransfers.sort((a, b) {
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => ref.read(filterOptionProvider.notifier).state = FilterOption.Today,
              style: ElevatedButton.styleFrom(
                primary: filterOption == FilterOption.Today ? Colors.blue : null,
              ),
              child: Text('Today'),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => ref.read(filterOptionProvider.notifier).state = FilterOption.Weekly,
              style: ElevatedButton.styleFrom(
                primary: filterOption == FilterOption.Weekly ? Colors.blue : null,
              ),
              child: Text('Weekly'),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => ref.read(filterOptionProvider.notifier).state = FilterOption.Monthly,
              style: ElevatedButton.styleFrom(
                primary: filterOption == FilterOption.Monthly ? Colors.blue : null,
              ),
              child: Text('Monthly'),
            ),
          ],
        ),
        SizedBox(height: 16),
        DataTable(
          columns: [
            DataColumn(
              label: Row(
                children: [
                  const Text('From Account'),
                  buildSortIcon(sortColumnIndex, 0, sortOrder),
                ],
              ),
              onSort: (columnIndex, _) {
                ref.read(sortColumnIndexProvider.notifier).state = columnIndex;
                toggleSortOrder(context, ref);
              },
            ),
            DataColumn(
              label: Row(
                children: [
                  const Text('To Account'),
                  buildSortIcon(sortColumnIndex, 1, sortOrder),
                ],
              ),
              onSort: (columnIndex, _) {
                ref.read(sortColumnIndexProvider.notifier).state = columnIndex;
                toggleSortOrder(context, ref);
              },
            ),
            DataColumn(
              label: Row(
                children: [
                  const Text('Amount'),
                  buildSortIcon(sortColumnIndex, 2, sortOrder),
                ],
              ),
              onSort: (columnIndex, _) {
                ref.read(sortColumnIndexProvider.notifier).state = columnIndex;
                toggleSortOrder(context, ref);
              },
            ),
            DataColumn(
              label: Row(
                children: [
                  const Text('Date'),
                  buildSortIcon(sortColumnIndex, 3, sortOrder),
                ],
              ),
              onSort: (columnIndex, _) {
                ref.read(sortColumnIndexProvider.notifier).state = columnIndex;
                toggleSortOrder(context, ref);
              },
            ),
          ],
          rows: filteredTransfers
              .map(
                (transfer) => DataRow(
              cells: [
                DataCell(Text(transfer.fromAccount)),
                DataCell(Text(transfer.toAccount)),
                DataCell(Text(transfer.amount.toString())),
                DataCell(Text(transfer.date.toString())),
              ],
            ),
          )
              .toList(),
        ),
      ],
    );
  }

  Widget buildSortIcon(int sortColumnIndex, int columnIndex, SortOrder sortOrder) {
    if (sortColumnIndex == columnIndex) {
      if (sortOrder == SortOrder.Ascending) {
        return Icon(Icons.arrow_upward);
      } else {
        return Icon(Icons.arrow_downward);
      }
    } else {
      return Icon(Icons.sort);
    }
  }

  void toggleSortOrder(BuildContext context, WidgetRef ref) {
    final sortOrder = ref.read(sortOrderProvider.notifier).state;
    if (sortOrder == SortOrder.Ascending) {
      ref.read(sortOrderProvider.notifier).state = SortOrder.Descending;
    } else {
      ref.read(sortOrderProvider.notifier).state = SortOrder.Ascending;
    }
  }
}

final accountTransfersProvider = Provider<List<AccountTransfer>>((ref) {
  // Replace with your data source
  return [
    AccountTransfer(
      fromAccount: 'Account 1',
      toAccount: 'Account 2',
      amount: 100.0,
      date: DateTime.now().subtract(Duration(days: 2)),
    ),
    AccountTransfer(
      fromAccount: 'Account 3',
      toAccount: 'Account 4',
      amount: 200.0,
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    AccountTransfer(
      fromAccount: 'Account 5',
      toAccount: 'Account 6',
      amount: 150.0,
      date: DateTime.now(),
    ),
    AccountTransfer(
      fromAccount: 'Account 7',
      toAccount: 'Account 8',
      amount: 300.0,
      date: DateTime.now().subtract(Duration(days: 3)),
    ),
  ];
});

final selectedAccountsProvider = StateProvider<List<AccountTransfer>>((ref) => []);

final sortOrderProvider = StateProvider<SortOrder>((ref) => SortOrder.Ascending);
final sortColumnIndexProvider = StateProvider<int>((ref) => 0);

final searchTextProvider = Provider<String>((ref) => '');
final filterOptionProvider = StateProvider<FilterOption>((ref) => FilterOption.Today);


