import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:currency_calculator/controllers/rates_controller.dart';

class RatesDisplay extends StatefulWidget {
  const RatesDisplay({Key? key}) : super(key: key);

  @override
  State<RatesDisplay> createState() => _RatesDisplayState();
}

class _RatesDisplayState extends State<RatesDisplay> {
  final formKey = GlobalKey<FormState>();
  String? selectedFromCurrency;
  String? selectedToCurrency;
  double? amount;
  double? result;

  @override
  void initState() {
    super.initState();
    final ratesController = Provider.of<RatesController>(context, listen: false);
    ratesController.fetchRates();
    ratesController.fetchCurrency();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text('Currency Converter')),
      body: Container(
        height: h,
        width: w,
        padding: const EdgeInsets.all(10),
        child: Consumer<RatesController>(
          builder: (context, ratesController, child) {
            if (ratesController.ratesList.isEmpty || ratesController.currencyList.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            final rates = ratesController.ratesList.first.rates;
            final currencies = ratesController.currencyList.first.currencies;

            return Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedFromCurrency,
                    hint: const Text('From Currency'),
                    items: currencies.keys.map((String currency) {
                      return DropdownMenuItem<String>(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedFromCurrency = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Select a currency' : null,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedToCurrency,
                    hint: const Text('To Currency'),
                    items: currencies.keys.map((String currency) {
                      return DropdownMenuItem<String>(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedToCurrency = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Select a currency' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      amount = double.tryParse(value);
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Enter an amount' : null,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          final fromRate = rates[selectedFromCurrency] ?? 1;
                          final toRate = rates[selectedToCurrency] ?? 1;
                          result = amount! * (toRate / fromRate);
                        });
                      }
                    },
                    child: const Text('Convert'),
                  ),
                  const SizedBox(height: 20),
                  if (result != null)
                    Text(
                      'Converted Amount: ${result!.toStringAsFixed(2)} $selectedToCurrency',
                      style: const TextStyle(fontSize: 18),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
