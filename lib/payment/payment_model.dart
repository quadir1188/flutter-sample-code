class WithinOwnAccountPayment {
  final String accountNumber;
  final double amount;

  WithinOwnAccountPayment({
    required this.accountNumber,
    required this.amount,
  });
}

class WithinSameBankPayment {
  final String recipientName;
  final String recipientAccountNumber;
  final double amount;

  WithinSameBankPayment({
    required this.recipientName,
    required this.recipientAccountNumber,
    required this.amount,
  });
}

class WithinSameCountryPayment {
  final String recipientName;
  final String recipientAccountNumber;
  final String bankName;
  final double amount;

  WithinSameCountryPayment({
    required this.recipientName,
    required this.recipientAccountNumber,
    required this.bankName,
    required this.amount,
  });
}

class InternationalPayment {
  final String recipientName;
  final String recipientAccountNumber;
  final String recipientBankName;
  final String recipientBankCountry;
  final double amount;

  InternationalPayment({
    required this.recipientName,
    required this.recipientAccountNumber,
    required this.recipientBankName,
    required this.recipientBankCountry,
    required this.amount,
  });
}
