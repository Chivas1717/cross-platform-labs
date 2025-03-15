import 'dart:math';

import 'package:flutter/material.dart';

// Клас для зберігання даних про електроприймач (ЕП)
class EP {
  final String name;
  final double efficiency;
  final double cosPhi;
  final double voltage;
  final int quantity;
  final double power;
  final double kv;
  final double tgPhi;

  EP({
    required this.name,
    required this.efficiency,
    required this.cosPhi,
    required this.voltage,
    required this.quantity,
    required this.power,
    required this.kv,
    required this.tgPhi,
  });
}

class Lab6Task1Calculator extends StatefulWidget {
  @override
  _Lab6Task1CalculatorState createState() => _Lab6Task1CalculatorState();
}

class _Lab6Task1CalculatorState extends State<Lab6Task1Calculator> {
  // Прикладова таблиця ЕП (дефолтні дані)
  final List<EP> epList = [
    EP(
        name: 'Шліфувальний верстат',
        efficiency: 0.92,
        cosPhi: 0.9,
        voltage: 0.38,
        quantity: 4,
        power: 20,
        kv: 0.15,
        tgPhi: 1.33),
    EP(
        name: 'Свердлильний верстат',
        efficiency: 0.92,
        cosPhi: 0.9,
        voltage: 0.38,
        quantity: 2,
        power: 14,
        kv: 0.12,
        tgPhi: 1.00),
    EP(
        name: 'Фугувальний верстат',
        efficiency: 0.92,
        cosPhi: 0.9,
        voltage: 0.38,
        quantity: 4,
        power: 42,
        kv: 0.15,
        tgPhi: 1.33),
    EP(
        name: 'Циркулярна пила',
        efficiency: 0.92,
        cosPhi: 0.9,
        voltage: 0.38,
        quantity: 1,
        power: 36,
        kv: 0.30,
        tgPhi: 1.52),
    EP(
        name: 'Прес',
        efficiency: 0.92,
        cosPhi: 0.9,
        voltage: 0.38,
        quantity: 1,
        power: 20,
        kv: 0.50,
        tgPhi: 0.75),
    EP(
        name: 'Полірувальний верстат',
        efficiency: 0.92,
        cosPhi: 0.9,
        voltage: 0.38,
        quantity: 1,
        power: 40,
        kv: 0.20,
        tgPhi: 1.00),
    EP(
        name: 'Фрезерний верстат',
        efficiency: 0.92,
        cosPhi: 0.9,
        voltage: 0.38,
        quantity: 2,
        power: 32,
        kv: 0.20,
        tgPhi: 1.00),
    EP(
        name: 'Вентилятор',
        efficiency: 0.92,
        cosPhi: 0.9,
        voltage: 0.38,
        quantity: 1,
        power: 20,
        kv: 0.65,
        tgPhi: 0.75),
  ];

  double? totalPower; // Σ (Quantity * Power)
  double? totalKVPower; // Σ (Quantity * Power * KV)
  double? totalKVPowerTg; // Σ (Quantity * Power * KV * tgPhi)
  double? totalPowerSquare; // Σ (Quantity * Power^2)

  double? kvResult; // Kv
  double? ne; // ne
  double kr = 1.25; // Коефіцієнт резерву
  double? pp; // Pp
  double? qp; // Qp
  double? sp; // Sp
  double? ip; // Ip (струм)

  void calculate() {
    setState(() {
      double sumPower = 0;
      double sumKV = 0;
      double sumKVtg = 0;
      double sumPowerSq = 0;

      for (var ep in epList) {
        double pn = ep.quantity * ep.power;
        sumPower += pn;
        sumKV += pn * ep.kv;
        sumKVtg += pn * ep.kv * ep.tgPhi;
        sumPowerSq += ep.quantity * pow(ep.power, 2);
      }

      totalPower = sumPower;
      totalKVPower = sumKV;
      totalKVPowerTg = sumKVtg;
      totalPowerSquare = sumPowerSq;

      if (sumPower == 0) {
        kvResult = 0;
        ne = 0;
        pp = 0;
        qp = 0;
        sp = 0;
        ip = 0;
        return;
      }

      // Kv
      kvResult = sumKV / sumPower;

      // ne
      ne = (pow(sumPower, 2) / sumPowerSq).roundToDouble();

      // Pp
      pp = kr * sumKV;

      // Qp (припускаємо множник 1.33, як у прикладі)
      qp = (kvResult! * sumPower * 1.33);

      // Sp
      sp = sqrt(pow(pp!, 2) + pow(qp!, 2));

      // Ip (припускаємо, що мережа 0.38 кВ)
      ip = pp! / 0.38;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Лаба 6, Task 1')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: calculate,
              child: Text('Calculate'),
            ),
            SizedBox(height: 24),
            if (totalPower != null) ...[
              Text('Kv = ${kvResult?.toStringAsFixed(4)}'),
              Text('ne = ${ne?.toStringAsFixed(0)}'),
              Text('Kr = ${kr.toStringAsFixed(2)}'),
              Text('Pp = ${pp?.toStringAsFixed(2)} кВт'),
              Text('Qp = ${qp?.toStringAsFixed(2)} квар'),
              Text('Sp = ${sp?.toStringAsFixed(2)} кВА'),
              Text('Ip = ${ip?.toStringAsFixed(2)} A'),
            ],
          ],
        ),
      ),
    );
  }
}
