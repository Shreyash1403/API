import 'package:currency_calculator/controllers/rates_controller.dart';
import 'package:currency_calculator/views/Rates_Display.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (BuildContext context) => RatesController()),
        ],
        child: const MaterialApp(
          home: RatesDisplay(),
        ));
  }
}
