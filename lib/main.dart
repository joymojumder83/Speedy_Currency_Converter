import 'package:currency_converter_app/currency_converter_page.dart';
import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
  //...runapp
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speedy Currency Converter',
      home: SpeedyQrPage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          primary: const Color(0xFF78E992),
          seedColor: const Color(0xFF76F57A),
        ),
        useMaterial3: true,
      ),
    );
  }
}
