import 'package:app/calculators/lab3.dart';
import 'package:flutter/material.dart';

import '../calculators/lab1.dart'; // <-- Імпортуємо файл з калькуляторами (див. нижче)
import '../calculators/lab2.dart';
import '../calculators/lab4.dart';
import '../calculators/lab5.dart';
import 'lab_screen.dart';

class HomeScreen extends StatelessWidget {
  // Приклад: тепер для Лаби 1 передаємо об'єкти з "title" та "widget"
  final List<Map<String, dynamic>> labs = [
    {
      'title': 'Лабораторна робота №1',
      'calculators': [
        {
          'title': 'Завдання 1',
          'widget': Lab1Task1Calculator(),
        },
        {
          'title': 'Завдання 2',
          'widget': Task2Calculator(),
        },
      ],
    },
    {
      'title': 'Лабораторна робота №2',
      'calculators': [
        {
          'title': 'Завдання 1',
          'widget': Lab2Task1Calculator(), // <-- Новий екран
        },
      ],
    },
    {
      'title': 'Лабораторна робота №3',
      'calculators': [
        {
          'title': 'Завдання 1',
          'widget': Lab3Task1Calculator(), // <-- Новий екран
        },
      ],
    },
    {
      'title': 'Лабораторна робота №4',
      'calculators': [
        {
          'title': 'Трифазне КЗ',
          'widget': ThreePhaseSCCalculator(),
        },
        {
          'title': 'Однофазне КЗ',
          'widget': SinglePhaseSCCalculator(),
        },
        {
          'title': 'Термічна стійкість',
          'widget': ThermalStabilityCalculator(),
        },
      ],
    },
    {
      'title': 'Лабораторна робота №5',
      'calculators': [
        {
          'title': 'Task 1',
          'widget': Lab5Task1Calculator(),
        },
        {
          'title': 'Task 2',
          'widget': Lab5Task2Calculator(),
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Головна сторінка'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
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
              title: const Text('Головна'),
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
      body: const Center(
        child: Text(
          'Ласкаво просимо до додатку!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
