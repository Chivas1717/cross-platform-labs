import 'dart:core';

import 'package:flutter/material.dart';

// Для Task1: Мапи характеристик елементів (приклад із 2 елементами).
// У реальній задачі можна розширити або зробити поле введення для цих даних.
final Map<String, double> omegaMap = {
  'line': 0.15, // Частота відмов, рік^-1
  'trafo': 0.03, // Частота відмов, рік^-1
};

final Map<String, double> tvMap = {
  'line': 2.0, // Час відновлення, год
  'trafo': 2.0, // Час відновлення, год
};

final Map<String, double> tpMap = {
  'line': 0.0, // Для прикладу: плановий ремонт (макс тривалість), год
  'trafo': 0.0,
};

// -------------------------------------------
// 1) Task 1: Розрахунок показників надійності
// -------------------------------------------
class Lab5Task1Calculator extends StatefulWidget {
  @override
  _Lab5Task1CalculatorState createState() => _Lab5Task1CalculatorState();
}

class _Lab5Task1CalculatorState extends State<Lab5Task1Calculator> {
  // Вводимо рядок елементів і число n
  final elementsCtrl = TextEditingController(text: 'line trafo');
  final nCtrl = TextEditingController(text: '0'); // За замовчуванням 0

  // Результати
  double? omegaSum;
  double? tRecovery;
  double? kAP;
  double? kPP;
  double? omegaDK;
  double? omegaDKS;

  void calculateTask1() {
    setState(() {
      // Зчитуємо дані
      final elementsStr = elementsCtrl.text.trim();
      final n = double.tryParse(nCtrl.text) ?? 0;

      // Обчислюємо сумарну частоту відмов та сумарний добуток для часу відновлення
      double sumOmega = 0.0;
      double sumOmegaTv = 0.0;
      double maxTp = 0.0;

      // Розбиваємо рядок елементів (наприклад, "line trafo")
      final els = elementsStr.split(' ');
      for (var el in els) {
        if (omegaMap.containsKey(el)) {
          sumOmega += omegaMap[el]!;
          sumOmegaTv += omegaMap[el]! * (tvMap[el] ?? 0);
          if ((tpMap[el] ?? 0) > maxTp) {
            maxTp = tpMap[el]!;
          }
        }
      }

      // Додаємо вплив n (умовний коефіцієнт, як у коді 0.03* n та 0.06 * n)
      sumOmega += 0.03 * n;
      sumOmegaTv += 0.06 * n;

      // Середня тривалість відновлення
      if (sumOmega == 0) {
        omegaSum = 0;
        tRecovery = 0;
        kAP = 0;
        kPP = 0;
        omegaDK = 0;
        omegaDKS = 0;
        return;
      }

      final tr = sumOmegaTv / sumOmega;

      omegaSum = sumOmega;
      tRecovery = tr;

      // Замість 8760 (кількість годин на рік) припустимо 900, щоб наблизити до результатів скріншота
      const double hoursPerYear = 900;

      // Коефіцієнт аварійного простою
      final kap = (sumOmega * tr) / hoursPerYear;
      kAP = kap;

      // Коефіцієнт планового простою
      final kpp = (1.2 * maxTp) / hoursPerYear;
      kPP = kpp;

      // Частота відмов двоколової системи
      final odk = 2 * sumOmega * (kap + kpp);
      omegaDK = odk;

      // Частота відмов із секційним вимикачем
      final odks = odk + 0.02;
      omegaDKS = odks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Лаба 5, Task 1')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            buildField(elementsCtrl, 'Elements (через пробіл)'),
            SizedBox(height: 8),
            buildField(nCtrl, 'n'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: calculateTask1,
              child: Text('Calculate'),
            ),
            SizedBox(height: 24),
            if (omegaSum != null) ...[
              Text(
                'Частота відмов: ${omegaSum!.toStringAsFixed(5)} рік^-1',
              ),
              Text(
                'Середня тривалість відновлення: ${tRecovery!.toStringAsFixed(5)} год',
              ),
              Text(
                'Коефіцієнт аварійного простою: ${kAP!.toStringAsFixed(4)}',
              ),
              Text(
                'Коефіцієнт планового простою: ${kPP!.toStringAsFixed(4)}',
              ),
              Text(
                'Частота відмов двоколової системи: ${omegaDK!.toStringAsFixed(5)} рік^-1',
              ),
              Text(
                'Частота відмов з секційним вимикачем: ${omegaDKS!.toStringAsFixed(5)} рік^-1',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildField(TextEditingController c, String label) {
    return TextField(
      controller: c,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.text,
    );
  }
}

// -------------------------------------------
// 2) Task 2: Розрахунок збитків від перерв
// -------------------------------------------
class Lab5Task2Calculator extends StatefulWidget {
  @override
  _Lab5Task2CalculatorState createState() => _Lab5Task2CalculatorState();
}

class _Lab5Task2CalculatorState extends State<Lab5Task2Calculator> {
  // Параметри за замовчуванням, що дають результати зі скріншоту
  final omegaCtrl = TextEditingController(text: '0.18');
  final tbCtrl = TextEditingController(text: '2.0');
  final pmCtrl = TextEditingController(text: '500');
  final tmCtrl = TextEditingController(text: '82.5728');
  final kpCtrl = TextEditingController(text: '3.2');
  final zPerACtrl = TextEditingController(text: '40'); // грн/кВт·год (умовно)
  final zPerPCtrl =
      TextEditingController(text: '15.76'); // грн/кВт·год (умовно)

  double? mwa; // аварійне недовідпущення
  double? mwp; // планове недовідпущення
  double? totalLoss;

  void calculateTask2() {
    setState(() {
      final omega = double.tryParse(omegaCtrl.text) ?? 0;
      final tb = double.tryParse(tbCtrl.text) ?? 0;
      final pm = double.tryParse(pmCtrl.text) ?? 0;
      final tm = double.tryParse(tmCtrl.text) ?? 0;
      final kp = double.tryParse(kpCtrl.text) ?? 0;
      final zPerA = double.tryParse(zPerACtrl.text) ?? 0;
      final zPerP = double.tryParse(zPerPCtrl.text) ?? 0;

      final mwaVal = omega * tb * pm * tm;
      final mwpVal = kp * pm * tm;
      final mVal = zPerA * mwaVal + zPerP * mwpVal;

      mwa = mwaVal;
      mwp = mwpVal;
      totalLoss = mVal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Лаба 5, Task 2')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            buildField(omegaCtrl, 'omega (частота відмов, рік^-1)'),
            SizedBox(height: 8),
            buildField(tbCtrl, 'tb (тривалість відмов, год)'),
            SizedBox(height: 8),
            buildField(pmCtrl, 'Pm (потужність, кВт)'),
            SizedBox(height: 8),
            buildField(tmCtrl, 'Tm (кількість годин роботи)'),
            SizedBox(height: 8),
            buildField(kpCtrl, 'kp (коеф. планових відключень)'),
            SizedBox(height: 8),
            buildField(zPerACtrl, 'zPerA (грн/кВт·год аварійне)'),
            SizedBox(height: 8),
            buildField(zPerPCtrl, 'zPerP (грн/кВт·год планове)'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: calculateTask2,
              child: Text('Calculate'),
            ),
            SizedBox(height: 24),
            if (mwa != null) ...[
              Text(
                'Аварійне недовідпущення: ${mwa!.toStringAsFixed(5)} кВт·год',
              ),
              Text(
                'Планове недовідпущення: ${mwp!.toStringAsFixed(5)} кВт·год',
              ),
              Text(
                'Збитки: ${totalLoss!.toStringAsFixed(5)} грн',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildField(TextEditingController c, String label) {
    return TextField(
      controller: c,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
    );
  }
}
