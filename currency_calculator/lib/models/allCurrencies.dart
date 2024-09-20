class CurrencyModel {
  final Map<String, String> currencies;

  CurrencyModel({required this.currencies});

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      currencies: Map<String, String>.from(json['currencies']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currencies': currencies,
    };
  }
}
