import 'dart:convert';

import 'package:currency_calculator/models/allCurrencies.dart';
import 'package:currency_calculator/models/rates_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RatesController with ChangeNotifier {
  List<RatesModel> ratesList = [];
  List<CurrencyModel> currencyList = [];

  Future<void> fetchRates() async {
    try {
      final response = await http.get(Uri.parse(
          'https://openexchangerates.org/api/latest.json?app_id=4f8dd1feb9d8487ab55672bde8c9a35d'));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        RatesModel ratesModel = RatesModel.fromJson(data);
        ratesList = [ratesModel];
        notifyListeners();
      } else {
        throw Exception('Failed to load rates');
      }
    } catch (e) {
      // Handle or log the error appropriately
      print('Error fetching rates: $e');
    }
  }

  Future<void> fetchCurrency() async {
    try {
      final response2 = await http.get(Uri.parse(
          'https://openexchangerates.org/api/currencies.json?app_id=4f8dd1feb9d8487ab55672bde8c9a35d'));

      if (response2.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response2.body);
        CurrencyModel currencyModel = CurrencyModel.fromJson(data);
        currencyList = [currencyModel];
        notifyListeners();
      } else {
        throw Exception('Failed to load rates');
      }
    } catch (e) {
      print('Error fetching rates: $e');
    }
  }
}
