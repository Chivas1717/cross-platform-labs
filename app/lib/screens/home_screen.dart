import 'package:flutter/material.dart';

import '../calculators/lab1.dart'; // <-- Імпортуємо файл з калькуляторами (див. нижче)
import 'lab_screen.dart';

class HomeScreen extends StatelessWidget {
  // Приклад: тепер для Лаби 1 передаємо об'єкти з "title" та "widget"
  final List<Map<String, dynamic>> labs = [
    {
      'title': 'Лабораторна робота №1',
      'calculators': [
        {
          'title': 'Завдання 1',
          'widget': Task1Calculator(),
        },
        {
          'title': 'Завдання 2',
          'widget': Task2Calculator(),
        },
      ],
    },
    // Додайте інші лаби за потребою
    // {
    //   'title': 'Лаба 2',
    //   'calculators': [
    //     {
    //       'title': 'Калькулятор 1',
    //       'widget': YourAnotherCalculatorWidget(),
    //     },
    //   ],
    // },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Головна сторінка'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text(
                'Лабораторні роботи',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Головна'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            // Динамічне створення пунктів меню для кожної лаби
            ...labs.map((lab) {
              return ListTile(
                title: Text(lab['title']),
                onTap: () {
                  Navigator.pop(context); // Закриваємо меню
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LabScreen(
                        title: lab['title'],
                        calculators: lab['calculators'],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Ласкаво просимо до додатку!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
