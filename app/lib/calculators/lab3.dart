import 'package:flutter/material.dart';

class Lab3Task1Calculator extends StatefulWidget {
  @override
  _Lab3Task1CalculatorState createState() => _Lab3Task1CalculatorState();
}

class _Lab3Task1CalculatorState extends State<Lab3Task1Calculator> {
  final pcCtrl =
      TextEditingController(text: '5'); // Середньодобова потужність, МВт
  final deltaCtrl = TextEditingController(
      text: '0.32'); // Частка непередбаченої енергії (32%)
  final priceCtrl = TextEditingController(text: '7'); // Ціна, тис. грн/МВт·год
  final penaltyCtrl =
      TextEditingController(text: '7'); // Штраф, тис. грн/МВт·год

  double? profit;

  void calculate() {
    setState(() {
      double pc = double.tryParse(pcCtrl.text) ?? 0;
      double delta = double.tryParse(deltaCtrl.text) ?? 0;
      double price = double.tryParse(priceCtrl.text) ?? 0;
      double penalty = double.tryParse(penaltyCtrl.text) ?? 0;

      double wPred = pc * 24 * (1 - delta);
      double wUnpred = pc * 24 * delta;
      double revenue = wPred * price;
      double fine = wUnpred * penalty;
      profit = revenue - fine;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          buildField(pcCtrl, 'Pc, МВт'),
          SizedBox(height: 8),
          buildField(deltaCtrl, 'delta (частка непередбаченої енергії)'),
          SizedBox(height: 8),
          buildField(priceCtrl, 'Ціна, тис. грн/МВт·год'),
          SizedBox(height: 8),
          buildField(penaltyCtrl, 'Штраф, тис. грн/МВт·год'),
          SizedBox(height: 16),
          ElevatedButton(onPressed: calculate, child: Text('Calculate')),
          SizedBox(height: 24),
          if (profit != null) ...[
            Text(
              '3.2.1. Результат',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Прибуток = ${profit!.toStringAsFixed(2)} тис. грн',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildField(TextEditingController ctrl, String label) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
    );
  }
}
