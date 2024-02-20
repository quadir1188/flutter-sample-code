# ai_created_code

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Country Selection'),
        ),
        body: Center(
          child: CountrySelection(),
        ),
      ),
    );
  }
}

class CountrySelection extends StatefulWidget {
  @override
  _CountrySelectionState createState() => _CountrySelectionState();
}

class _CountrySelectionState extends State<CountrySelection> {
  String _selectedCountry;

  List<String> _countries = [
    'USA',
    'Canada',
    'UK',
    'Germany',
    'France',
    'Japan',
    // Add more countries as needed
  ];

  @override
  Widget build(BuildContext context) {
    // Check if it's a mobile platform
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return isMobile ? _buildMobileDropdown() : _buildWebDropdown();
  }

  Widget _buildMobileDropdown() {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        setState(() {
          _selectedCountry = value;
        });
      },
      itemBuilder: (BuildContext context) {
        return _countries.map((String country) {
          return PopupMenuItem<String>(
            value: country,
            child: Text(country),
          );
        }).toList();
      },
      child: ListTile(
        title: Text(_selectedCountry ?? 'Select a country'),
        trailing: Icon(Icons.arrow_drop_down),
      ),
    );
  }

  Widget _buildWebDropdown() {
    return DropdownButton<String>(
      value: _selectedCountry,
      onChanged: (String newValue) {
        setState(() {
          _selectedCountry = newValue;
        });
      },
      items: _countries.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      hint: Text('Select a country'),
    );
  }
}