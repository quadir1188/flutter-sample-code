import 'package:ai_created_code/payment/WithinOwnAccount.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentSelectionScreen extends StatelessWidget {
  const PaymentSelectionScreen({super.key});

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Select Payment Type')),
    body: ListView(
      children: [
        ListTile(
          title: Text('Within Own Account'),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WithinOwnAccountScreen())),
        ),
        /*ListTile(
          title: Text('Within Same Bank'),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WithinSameBankScreen())),
        ),
        ListTile(
          title: Text('Within Same Country'),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WithinSameCountryScreen())),
        ),
        ListTile(
          title: Text('International Payment'),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => InternationalPaymentScreen())),
        ),*/
      ],
    ),
  );
}
}