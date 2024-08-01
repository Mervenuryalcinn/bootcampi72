import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WellnessWing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController stepsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giriş Ekranı'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Ad'),
            ),
            SizedBox(height: 12.0),
            TextFormField(
              controller: surnameController,
              decoration: InputDecoration(labelText: 'Soyad'),
            ),
            SizedBox(height: 12.0),
            TextFormField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Yaş'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12.0),
            TextFormField(
              controller: heightController,
              decoration: InputDecoration(labelText: 'Boy (cm)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12.0),
            TextFormField(
              controller: weightController,
              decoration: InputDecoration(labelText: 'Kilo (kg)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12.0),
            TextFormField(
              controller: stepsController,
              decoration: InputDecoration(labelText: 'Günlük Adım Sayısı'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                navigateToHome(context);
              },
              child: Text('Giriş Yap'),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToHome(BuildContext context) {
    String name = nameController.text;
    String surname = surnameController.text;
    int age = int.tryParse(ageController.text) ?? 0;
    double height = double.tryParse(heightController.text) ?? 0.0;
    double weight = double.tryParse(weightController.text) ?? 0.0;
    int steps = int.tryParse(stepsController.text) ?? 0;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage(height: height, weight: weight)),
    );
  }
}

class HomePage extends StatelessWidget {
  final double height;
  final double weight;

  HomePage({required this.height, required this.weight});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WellnessWing'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                navigateToDietProgram(context);
              },
              child: Text('Diyet Programı'),
            ),
            SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: () {
                navigateToExerciseProgram(context);
              },
              child: Text('Egzersiz Programı'),
            ),
            SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: () {
                showHealthStatusDialog(context);
              },
              child: Text('Sağlık Durumu'),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToDietProgram(BuildContext context) {
    double bmi = calculateBMI(height, weight);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DietProgramPage(bmi: bmi)),
    );
  }

  void navigateToExerciseProgram(BuildContext context) {
    double bmi = calculateBMI(height, weight);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ExerciseProgramPage(bmi: bmi, age: 25, gender: 'erkek')),
    );
  }

  void showHealthStatusDialog(BuildContext context) {
    double bmi = calculateBMI(height, weight);
    String bmiMessage = getBMIMessage(bmi);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sağlık Durumu'),
          content: Text('BMI: $bmi\n$bmiMessage'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  String getBMIMessage(double bmi) {
    if (bmi < 18.5) {
      return 'Zayıf';
    } else if (bmi >= 18.5 && bmi < 25) {
      return 'Normal';
    } else if (bmi >= 25 && bmi < 30) {
      return 'Kilolu';
    } else {
      return 'Obez';
    }
  }

  double calculateBMI(double height, double weight) {
    double heightInMeters = height / 100; // cm'yi metre cinsine çeviriyoruz
    return weight / (heightInMeters * heightInMeters);
  }
}

class DietProgramPage extends StatelessWidget {
  final double bmi;

  DietProgramPage({required this.bmi});

  @override
  Widget build(BuildContext context) {
    List<DietProgram> dietProgram = getDietProgram(bmi);

    return Scaffold(
      appBar: AppBar(
        title: Text('Diyet Programı'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: dietProgram.length,
          itemBuilder: (context, index) {
            final meal = dietProgram[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${meal.meal}:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...meal.items.map((item) => Text(' - $item')),
                SizedBox(height: 12.0),
              ],
            );
          },
        ),
      ),
    );
  }

  List<DietProgram> getDietProgram(double bmi) {
    if (bmi < 18.5) {
      return [
        DietProgram(
          meal: 'Kahvaltı',
          items: [
            '2 dilim tam buğday ekmeği',
            '1 adet haşlanmış yumurta',
            '1 dilim beyaz peynir',
            '1 küçük avokado dilimi',
            '1 orta boy domates',
            '1 küçük salatalık',
            '10-12 adet zeytin',
            'Taze sıkılmış meyve suyu',
          ],
        ),
        DietProgram(
          meal: 'Ara Öğün',
          items: [
            '1 porsiyon meyve (muz, elma, portakal)',
            '15 adet badem veya ceviz',
          ],
        ),
        DietProgram(
          meal: 'Öğle Yemeği',
          items: [
            '1 porsiyon ızgara tavuk, hindi veya balık',
            '1 kase yeşil salata (limonlu zeytinyağlı sos ile)',
            '1 su bardağı yoğurt',
            '2 dilim tam buğday ekmeği',
          ],
        ),
        DietProgram(
          meal: 'Ara Öğün',
          items: [
            '1 kase yoğurt içine 1 yemek kaşığı chia tohumu veya keten tohumu',
          ],
        ),
        DietProgram(
          meal: 'Akşam Yemeği',
          items: [
            '1 porsiyon zeytinyağlı sebze yemeği (örneğin, enginar, kabak, ıspanak)',
            '1 kase mercimek çorbası veya sebze çorbası',
            '2 dilim tam buğday ekmeği',
            '1 kase salata',
          ],
        ),
        DietProgram(
          meal: 'Ara Öğün (İsteğe Bağlı)',
          items: [
            '1 porsiyon meyve',
            '1 bardak süt veya 1 kase yoğurt',
          ],
        ),
      ];
    } else if (bmi >= 18.5 && bmi < 25) {
      return [
        DietProgram(
          meal: 'Kahvaltı',
          items: [
            '1 dilim tam buğday ekmeği',
            '1 adet haşlanmış yumurta',
            '1 dilim beyaz peynir',
            '1 küçük avokado dilimi',
            '1 orta boy domates',
            '1 küçük salatalık',
            '8-10 adet zeytin',
            'Taze sıkılmış meyve suyu veya yeşil çay',
          ],
        ),
        DietProgram(
          meal: 'Ara Öğün',
          items: [
            '1 porsiyon meyve (elma, armut, şeftali)',
            '10 adet badem veya fındık',
          ],
        ),
        DietProgram(
          meal: 'Öğle Yemeği',
          items: [
            '1 porsiyon ızgara tavuk, hindi veya balık',
            '1 kase yeşil salata (limonlu zeytinyağlı sos ile)',
            '1 su bardağı ayran veya yoğurt',
            '1 dilim tam buğday ekmeği',
          ],
        ),
        DietProgram(
          meal: 'Ara Öğün',
          items: [
            '1 kase yoğurt içine 1 yemek kaşığı chia tohumu veya keten tohumu',
            '1 porsiyon meyve',
          ],
        ),
        DietProgram(
          meal: 'Akşam Yemeği',
          items: [
            '1 porsiyon zeytinyağlı sebze yemeği (örneğin, enginar, kabak, ıspanak)',
            '1 kase mercimek çorbası veya sebze çorbası',
            '1 dilim tam buğday ekmeği',
            '1 kase salata',
          ],
        ),
      ];
    } else if (bmi >= 25 && bmi < 30) {
      return [
        DietProgram(
          meal: 'Kahvaltı',
          items: [
            '1 dilim tam buğday ekmeği',
            '1 adet haşlanmış yumurta veya 2 adet beyaz peynirli omlet',
            '1 küçük avokado dilimi',
            '1 orta boy domates',
            '1 küçük salatalık',
            '6-8 adet zeytin',
            'Bitki çayı (yeşil çay, papatya çayı)',
          ],
        ),
        DietProgram(
          meal: 'Ara Öğün',
          items: [
            '1 porsiyon meyve (elma, armut, şeftali)',
            '8-10 adet badem veya ceviz',
          ],
        ),
        DietProgram(
          meal: 'Öğle Yemeği',
          items: [
            '1 porsiyon ızgara tavuk, hindi veya balık',
            '1 kase yeşil salata (limonlu zeytinyağlı sos ile)',
            '1 su bardağı ayran veya yoğurt',
            '1 dilim tam buğday ekmeği',
          ],
        ),
        DietProgram(
          meal: 'Ara Öğün',
          items: [
            '1 kase yoğurt içine 1 yemek kaşığı chia tohumu veya keten tohumu',
            '1 porsiyon meyve',
          ],
        ),
        DietProgram(
          meal: 'Akşam Yemeği',
          items: [
            '1 porsiyon zeytinyağlı sebze yemeği (örneğin, enginar, kabak, ıspanak)',
            '1 kase mercimek çorbası veya sebze çorbası',
            '1 dilim tam buğday ekmeği',
            '1 kase salata',
          ],
        ),
      ];
    } else {
      return [
        DietProgram(
          meal: 'Kahvaltı',
          items: [
            '1 dilim tam buğday ekmeği',
            '1 adet haşlanmış yumurta veya 2 adet beyaz peynirli omlet',
            '1 küçük avokado dilimi',
            '1 orta boy domates',
            '1 küçük salatalık',
            '6-8 adet zeytin',
            'Bitki çayı (yeşil çay, papatya çayı)',
          ],
        ),
        DietProgram(
          meal: 'Ara Öğün',
          items: [
            '1 porsiyon meyve (elma, armut, şeftali)',
            '8-10 adet badem veya ceviz',
          ],
        ),
        DietProgram(
          meal: 'Öğle Yemeği',
          items: [
            '1 porsiyon ızgara tavuk, hindi veya balık',
            '1 kase yeşil salata (limonlu zeytinyağlı sos ile)',
            '1 su bardağı ayran veya yoğurt',
            '1 dilim tam buğday ekmeği',
          ],
        ),
        DietProgram(
          meal: 'Ara Öğün',
          items: [
            '1 kase yoğurt içine 1 yemek kaşığı chia tohumu veya keten tohumu',
            '1 porsiyon meyve',
          ],
        ),
        DietProgram(
          meal: 'Akşam Yemeği',
          items: [
            '1 porsiyon zeytinyağlı sebze yemeği (örneğin, enginar, kabak, ıspanak)',
            '1 kase mercimek çorbası veya sebze çorbası',
            '1 dilim tam buğday ekmeği',
            '1 kase salata',
          ],
        ),
      ];
    }
  }
}

class DietProgram {
  final String meal;
  final List<String> items;

  DietProgram({required this.meal, required this.items});
}

class ExerciseProgramPage extends StatelessWidget {
  final double bmi;
  final int age;
  final String gender;

  ExerciseProgramPage({required this.bmi, required this.age, required this.gender});

  @override
  Widget build(BuildContext context) {
    List<ExerciseProgram> exerciseProgram = getExerciseProgram();

    return Scaffold(
      appBar: AppBar(
        title: Text('Egzersiz Programı'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: exerciseProgram.length,
          itemBuilder: (context, index) {
            final exercise = exerciseProgram[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${exercise.exercise}:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...exercise.details.map((detail) => Text(' - $detail')),
                SizedBox(height: 12.0),
              ],
            );
          },
        ),
      ),
    );
  }

  List<ExerciseProgram> getExerciseProgram() {
    if (bmi < 18.5) {
      return [
        ExerciseProgram(
          exercise: 'Isınma',
          details: [
            '5 dakika yürüyüş',
            '5 dakika hafif koşu',
          ],
        ),
        ExerciseProgram(
          exercise: 'Ana Egzersizler',
          details: [
            '3 set 12 tekrar squat',
            '3 set 12 tekrar şınav',
            '3 set 12 tekrar lunge',
            '3 set 12 tekrar plank',
          ],
        ),
        ExerciseProgram(
          exercise: 'Soğuma',
          details: [
            '5 dakika hafif yürüyüş',
            '5 dakika esneme hareketleri',
          ],
        ),
      ];
    } else if (bmi >= 18.5 && bmi < 25) {
      return [
        ExerciseProgram(
          exercise: 'Isınma',
          details: [
            '5 dakika yürüyüş',
            '5 dakika hafif koşu',
          ],
        ),
        ExerciseProgram(
          exercise: 'Ana Egzersizler',
          details: [
            '3 set 15 tekrar squat',
            '3 set 15 tekrar şınav',
            '3 set 15 tekrar lunge',
            '3 set 15 tekrar plank',
          ],
        ),
        ExerciseProgram(
          exercise: 'Soğuma',
          details: [
            '5 dakika hafif yürüyüş',
            '5 dakika esneme hareketleri',
          ],
        ),
      ];
    } else if (bmi >= 25 && bmi < 30) {
      return [
        ExerciseProgram(
          exercise: 'Isınma',
          details: [
            '5 dakika yürüyüş',
            '5 dakika hafif koşu',
          ],
        ),
        ExerciseProgram(
          exercise: 'Ana Egzersizler',
          details: [
            '3 set 10 tekrar squat',
            '3 set 10 tekrar şınav',
            '3 set 10 tekrar lunge',
            '3 set 10 tekrar plank',
          ],
        ),
        ExerciseProgram(
          exercise: 'Soğuma',
          details: [
            '5 dakika hafif yürüyüş',
            '5 dakika esneme hareketleri',
          ],
        ),
      ];
    } else {
      return [
        ExerciseProgram(
          exercise: 'Isınma',
          details: [
            '5 dakika yürüyüş',
            '5 dakika hafif koşu',
          ],
        ),
        ExerciseProgram(
          exercise: 'Ana Egzersizler',
          details: [
            '3 set 8 tekrar squat',
            '3 set 8 tekrar şınav',
            '3 set 8 tekrar lunge',
            '3 set 8 tekrar plank',
          ],
        ),
        ExerciseProgram(
          exercise: 'Soğuma',
          details: [
            '5 dakika hafif yürüyüş',
            '5 dakika esneme hareketleri',
          ],
        ),
      ];
    }
  }
}

class ExerciseProgram {
  final String exercise;
  final List<String> details;

  ExerciseProgram({required this.exercise, required this.details});
}





