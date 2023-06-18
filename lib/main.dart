import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final daysProvider = Provider<List<String>>((ref) {
  return List.generate(7, (index) => (index + 1).toString());
});

final monthsProvider = Provider<List<String>>((ref) {
  return [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
  ];
});

final weekdaysProvider = Provider<List<String>>((ref) {
  return ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
});

final selectedDayFilterProvider = StateProvider<String?>((ref) => null);
final selectedMonthFilterProvider = StateProvider<String?>((ref) => null);
final selectedWeekdayFilterProvider = StateProvider<String?>((ref) => null);

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Riverpod Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final days = ref.watch(daysProvider);
    final months = ref.watch(monthsProvider);
    final weekdays = ref.watch(weekdaysProvider);

    final selectedDayFilter = ref.watch(selectedDayFilterProvider.state).state;
    final selectedMonthFilter = ref.watch(selectedMonthFilterProvider.state).state;
    final selectedWeekdayFilter = ref.watch(selectedWeekdayFilterProvider.state).state;

    List<String> filteredDays = days;
    List<String> filteredMonths = months;
    List<String> filteredWeekdays = weekdays;

    if (selectedDayFilter != null) {
      filteredDays = days.where((day) => day.startsWith(selectedDayFilter)).toList();
    }
    if (selectedMonthFilter != null) {
      filteredMonths = months.where((month) => month.startsWith(selectedMonthFilter)).toList();
    }
    if (selectedWeekdayFilter != null) {
      filteredWeekdays =
          weekdays.where((weekday) => weekday.startsWith(selectedWeekdayFilter)).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Days, Months, and Weekdays'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ColumnFilterDropdown(
                  items: days,
                  onChanged: (value) {
                    ref.read(selectedDayFilterProvider.state).state = value;
                  },
                  selectedValue: selectedDayFilter,
                  hintText: 'Filter Days',
                ),
                ColumnFilterDropdown(
                  items: months,
                  onChanged: (value) {
                    ref.read(selectedMonthFilterProvider.state).state = value;
                  },
                  selectedValue: selectedMonthFilter,
                  hintText: 'Filter Months',
                ),
                ColumnFilterDropdown(
                  items: weekdays,
                  onChanged: (value) {
                    ref.read(selectedWeekdayFilterProvider.state).state = value;
                  },
                  selectedValue: selectedWeekdayFilter,
                  hintText: 'Filter Weekdays',
                ),
              ],
            ),
            DataTable(
              columns: [
                DataColumn(label: Text('Days')),
                DataColumn(label: Text('Months')),
                DataColumn(label: Text('Weekdays')),
              ],
              rows: List.generate(filteredDays.length, (index) {
                return DataRow(cells: [
                  DataCell(Text(filteredDays[index])),
                  DataCell(Text(filteredMonths[index])),
                  DataCell(Text(filteredWeekdays[index])),
                ]);
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class ColumnFilterDropdown extends StatelessWidget {
  final List<String> items;
  final String? selectedValue;
  final String hintText;
  final ValueChanged<String?> onChanged;

  const ColumnFilterDropdown({
    required this.items,
    required this.onChanged,
    required this.selectedValue,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String?>(
      value: selectedValue,
      hint: Text(hintText),
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String?>>((String? value) {
        return DropdownMenuItem<String?>(
          value: value,
          child: Text(value ?? ''),
        );
      }).toList(),
    );
  }
}
