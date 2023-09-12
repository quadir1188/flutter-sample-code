import 'package:ai_created_code/payment/payment_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class PaymentService {
  Future<void> withinOwnAccount(WithinOwnAccountPayment payment);
  Future<void> withinSameBank(WithinSameBankPayment payment);
  Future<void> withinSameCountry(WithinSameCountryPayment payment);
  Future<void> internationalPayment(InternationalPayment payment);
}

class MockPaymentService implements PaymentService {
  @override
  Future<void> withinOwnAccount(WithinOwnAccountPayment payment) async {
    await Future.delayed(Duration(seconds: 2));
    print('Within Own Account Payment: ${payment.accountNumber}, ${payment.amount}');
  }

  @override
  Future<void> withinSameBank(WithinSameBankPayment payment) async {
    await Future.delayed(Duration(seconds: 2));
    print('Within Same Bank Payment: ${payment.recipientAccountNumber}, ${payment.amount}');
  }

  @override
  Future<void> withinSameCountry(WithinSameCountryPayment payment) async {
    await Future.delayed(Duration(seconds: 2));
    print('Within Same Country Payment: ${payment.recipientAccountNumber}, ${payment.amount}');
  }

  @override
  Future<void> internationalPayment(InternationalPayment payment) async {
    await Future.delayed(Duration(seconds: 2));
    print('International Payment: ${payment.recipientAccountNumber}, ${payment.amount}');
  }
}

final paymentServiceProvider = Provider<PaymentService>((ref) {
  return MockPaymentService();
});

final withinOwnAccountProvider = StateProvider<WithinOwnAccountPayment>((ref) {
  return WithinOwnAccountPayment(accountNumber: '', amount: 0);
});

final withinSameBankProvider = StateProvider<WithinSameBankPayment>((ref) {
  return WithinSameBankPayment(recipientName: '', recipientAccountNumber: '', amount: 0);
});

final withinSameCountryProvider = StateProvider<WithinSameCountryPayment>((ref) {
  return WithinSameCountryPayment(recipientName: '', recipientAccountNumber: '', bankName: '', amount: 0);
});

final internationalPaymentProvider = StateProvider<InternationalPayment>((ref) {
  return InternationalPayment(recipientName: '', recipientAccountNumber: '', recipientBankName: '', recipientBankCountry: '', amount: 0);
});
