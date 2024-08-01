import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String name;
  final String surname;
  final int age;
  final double height;
  final double weight;
  final int steps;
  final double bmi;
  final String bmiMessage;
  final String dietPlan;
  final String exercisePlan;
  HomePage({
     required this.name,
     required this.surname,
     required this.age,
     required this.height,
     required this.weight,
     required this.steps,
     required this.bmi,
     required this.bmiMessage,
     required this.dietPlan,
     required this.exercisePlan,

  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ana Sayfa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Hoşgeldiniz, $name $surname'),
            SizedBox(height: 10),
            Text('Yaş: $age'),
            Text('Boy: ${height.toStringAsFixed(1)} cm'),
            Text('Kilo: ${weight.toStringAsFixed(1)} kg'),
            Text('Günlük Adım Sayısı: $steps'),
            SizedBox(height: 10),
            Text('Vücut Kitle İndeksiniz (BMI): ${bmi.toStringAsFixed(2)} ($bmiMessage)'),
            SizedBox(height: 10),
            Text('Diyet Planı: $dietPlan'),
            Text('Egzersiz Planı: $exercisePlan'),
          ],
        ),
      ),
    );
  }
}
