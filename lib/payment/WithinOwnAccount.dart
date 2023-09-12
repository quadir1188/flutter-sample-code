// screens/payment_screens.dart
import 'package:ai_created_code/payment/payment_model.dart';
import 'package:ai_created_code/payment/payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class WithinOwnAccountScreen extends HookWidget {
  final _formKey = GlobalKey<FormState>();

  WithinOwnAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accountNumber = useState('');
    final amount = useState('');

    return Scaffold(
      appBar: AppBar(title: Text('Within Own Account Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Account Number'),
                onChanged: (value) => accountNumber.value = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter account number';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                onChanged: (value) => amount.value = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final payment = WithinOwnAccountPayment(
                      accountNumber: accountNumber.value,
                      amount: double.parse(amount.value),
                    );
                    //_makePayment(WidgetRef , payment);
                  }
                },
                child: Text('Make Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _makePayment(WidgetRef ref, WithinSameBankPayment payment) async {
    final paymentService = ref.read(paymentServiceProvider);
    await paymentService.withinSameBank(payment);
  }
}

// ... Define other payment screens for other payment scenarios ...
