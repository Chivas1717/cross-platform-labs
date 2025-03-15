import 'dart:math';

import 'package:flutter/material.dart';

// 1) Трифазне КЗ
class ThreePhaseSCCalculator extends StatefulWidget {
  @override
  _ThreePhaseSCCalculatorState createState() => _ThreePhaseSCCalculatorState();
}

class _ThreePhaseSCCalculatorState extends State<ThreePhaseSCCalculator> {
  final voltageCtrl = TextEditingController();
  final impedanceCtrl = TextEditingController();

  double? current;

  void calculate() {
    setState(() {
      double voltage = double.tryParse(voltageCtrl.text) ?? 0;
      double impedance = double.tryParse(impedanceCtrl.text) ?? 0;
      if (impedance == 0) {
        current = null;
        return;
      }
      current = voltage / (impedance * sqrt(3));
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildCalculator(
      title: 'Трифазне КЗ',
      fields: [
        _buildField(voltageCtrl, 'Напруга, В'),
        SizedBox(height: 8),
        _buildField(impedanceCtrl, 'Імпеданс, Ом'),
      ],
      onCalculate: calculate,
      result: current == null
          ? null
          : 'Струм трифазного КЗ: ${current!.toStringAsFixed(2)} A',
    );
  }
}

// 2) Однофазне КЗ
class SinglePhaseSCCalculator extends StatefulWidget {
  @override
  _SinglePhaseSCCalculatorState createState() =>
      _SinglePhaseSCCalculatorState();
}

class _SinglePhaseSCCalculatorState extends State<SinglePhaseSCCalculator> {
  final voltageCtrl = TextEditingController();
  final impedanceCtrl = TextEditingController();

  double? current;

  void calculate() {
    setState(() {
      double voltage = double.tryParse(voltageCtrl.text) ?? 0;
      double impedance = double.tryParse(impedanceCtrl.text) ?? 0;
      if (impedance == 0) {
        current = null;
        return;
      }
      current = voltage / impedance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildCalculator(
      title: 'Однофазне КЗ',
      fields: [
        _buildField(voltageCtrl, 'Напруга, В'),
        SizedBox(height: 8),
        _buildField(impedanceCtrl, 'Імпеданс, Ом'),
      ],
      onCalculate: calculate,
      result: current == null
          ? null
          : 'Струм однофазного КЗ: ${current!.toStringAsFixed(2)} A',
    );
  }
}

// 3) Перевірка термічної стійкості
class ThermalStabilityCalculator extends StatefulWidget {
  @override
  _ThermalStabilityCalculatorState createState() =>
      _ThermalStabilityCalculatorState();
}

class _ThermalStabilityCalculatorState
    extends State<ThermalStabilityCalculator> {
  final currentCtrl = TextEditingController();
  final durationCtrl = TextEditingController();

  double? stability;

  void calculate() {
    setState(() {
      double i = double.tryParse(currentCtrl.text) ?? 0;
      double t = double.tryParse(durationCtrl.text) ?? 0;
      stability = i * i * t;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildCalculator(
      title: 'Термічна стійкість',
      fields: [
        _buildField(currentCtrl, 'Струм, A'),
        SizedBox(height: 8),
        _buildField(durationCtrl, 'Тривалість, c'),
      ],
      onCalculate: calculate,
      result: stability == null
          ? null
          : 'Термічна стійкість: ${stability!.toStringAsFixed(2)} A²·с',
    );
  }
}

// --------------------------------------------------------
// Допоміжні віджети для побудови інтерфейсу (щоб не дублювати код)
// --------------------------------------------------------
Widget _buildCalculator({
  required String title,
  required List<Widget> fields,
  required VoidCallback onCalculate,
  String? result,
}) {
  return SingleChildScrollView(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 16),
        ...fields,
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: onCalculate,
          child: Text('Calculate'),
        ),
        SizedBox(height: 24),
        if (result != null) Text(result, style: TextStyle(fontSize: 16)),
      ],
    ),
  );
}

Widget _buildField(TextEditingController ctrl, String label) {
  return TextField(
    controller: ctrl,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
    ),
    keyboardType: TextInputType.number,
  );
}
