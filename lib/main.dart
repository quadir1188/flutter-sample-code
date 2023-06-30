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
final selectedAccountsProvider =
StateProvider<List<AccountTransfer>>((ref) => []);
final searchTextProvider = StateProvider<String>((ref) => '');



final filteredAccountTransfersProvider = Provider<List<AccountTransfer>>((ref) {
  final searchText = ref.watch(searchTextProvider.notifier).state.toLowerCase();
  final accountTransfers = ref.watch(accountTransfersProvider.notifier).state;
  final selectedAccounts = ref.watch(selectedAccountsProvider);

  if (searchText.isEmpty) {
    if(selectedAccounts.isNotEmpty){
      return accountTransfers.where((transfer) {
        for (var selectedAccount in selectedAccounts) {
          if (transfer.fromAccount.contains(selectedAccount.fromAccount)) {
            return true;
          }
        }
        return false;
      }).toList();
    }
    return accountTransfers;
  } else {
    return accountTransfers.where((transfer) =>
    transfer.fromAccount.toLowerCase().contains(searchText) ||
        transfer.toAccount.toLowerCase().contains(searchText) ||
        transfer.amount.toString().toLowerCase().contains(searchText) ||
        transfer.date.toString().toLowerCase().contains(searchText)).toList();
  }
});
class AccountTransferTable extends ConsumerWidget {
  const AccountTransferTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountTransfers = ref.watch(filteredAccountTransfersProvider);
    final sortOrder = ref.watch(sortOrderProvider);
    final sortColumnIndex = ref.watch(sortColumnIndexProvider);
    final searchText = ref.watch(searchTextProvider);

    List<AccountTransfer> filteredTransfers = accountTransfers
        .where((transfer) =>
    transfer.fromAccount.toLowerCase().contains(searchText) ||
        transfer.toAccount.toLowerCase().contains(searchText) ||
        transfer.amount.toString().contains(searchText) ||
        transfer.date.toString().contains(searchText))
        .toList();

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
          rows: filteredTransfers.map((transfer) {
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

  Widget buildSortIcon(int sortColumnIndex, int columnIndex, SortOrder sortOrder) {
    if (sortColumnIndex == columnIndex) {
      return sortOrder == SortOrder.Ascending
          ? const Icon(Icons.arrow_upward)
          : const Icon(Icons.arrow_downward);
    }
    return const Icon(Icons.unfold_more);
  }

  void toggleSortOrder(BuildContext context, WidgetRef ref) {
    final sortOrder = ref.read(sortOrderProvider.notifier).state;
    ref.read(sortOrderProvider.notifier).state =
    sortOrder == SortOrder.Ascending ? SortOrder.Descending : SortOrder.Ascending;
  }
}

class AccountTransferSelectionButton extends ConsumerWidget {
  const AccountTransferSelectionButton({super.key});

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
                  .watch(accountTransfersProvider.notifier)
                  .state
                  .map((e) => MultiSelectItem(e, e.fromAccount))
                  .toList(),
              initialValue: selectedAccounts.toList(),
              onConfirm: (List<AccountTransfer>? values) {
                ref.read(selectedAccountsProvider.notifier).state = values?.toList() ?? [];
              var value  =  ref.watch(selectedAccountsProvider.notifier).state;
              print("selected value ${value.first.toAccount}");
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
      child: const Text('Select Accounts'),
    );
  }
}

class AccountTransferScreen extends StatelessWidget {
  const AccountTransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Account Transfers')),
          body: const Column(
            children: [
              AccountTransferSelectionButton(),
              SizedBox(height: 16),
              SearchBox(),
              Expanded(child: AccountTransferTable()),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchBox extends ConsumerWidget {
  const SearchBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchText = ref.watch(searchTextProvider.notifier).state;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (value) {
          ref.read(searchTextProvider.notifier).state = value.toLowerCase();
        },
        decoration: InputDecoration(
          labelText: 'Search',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(AccountTransferScreen());
}
