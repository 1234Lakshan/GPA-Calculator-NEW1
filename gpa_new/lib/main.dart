import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPA Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue[50],
      ),
      home: const InputScreen(),
    );
  }
}

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final List<TextEditingController> courseControllers = [];
  final List<FocusNode> focusNodes = [];
  final List<String> selectedCredits = [];
  final List<String> selectedGrades = [];

  final List<String> creditOptions = ['1', '2', '3', '4', '5'];
  final List<String> gradeOptions = [
    'A+',
    'A',
    'A-',
    'B+',
    'B',
    'B-',
    'C+',
    'C',
    'C-',
    'D+',
    'D',
    'E'
  ];

  @override
  void initState() {
    super.initState();
    addCourse(); // Add an initial course
  }

  void addCourse() {
    courseControllers.add(TextEditingController());
    focusNodes.add(FocusNode());
    selectedCredits.add(creditOptions[0]);
    selectedGrades.add(gradeOptions[0]);

    // Use setState only once
    setState(() {});
  }

  void calculateGPA() {
    double totalPoints = 0;
    int totalCredits = 0;

    for (int i = 0; i < courseControllers.length; i++) {
      int credit = int.tryParse(selectedCredits[i]) ?? 0;
      double gradePoint = getGradePoint(selectedGrades[i]);
      totalPoints += credit * gradePoint;
      totalCredits += credit;
    }

    double gpa = totalCredits > 0 ? totalPoints / totalCredits : 0.0;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(gpa: gpa),
      ),
    );
  }

  double getGradePoint(String grade) {
    Map<String, double> gradeMap = {
      'A+': 4.0,
      'A': 4.0,
      'A-': 3.7,
      'B+': 3.3,
      'B': 3.0,
      'B-': 2.7,
      'C+': 2.3,
      'C': 2.0,
      'C-': 1.7,
      'D+': 1.3,
      'D': 1.0,
      'E': 0.0
    };
    return gradeMap[grade] ?? 0.0;
  }

  @override
  void dispose() {
    for (var controller in courseControllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('GPA Calculator'), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: courseControllers.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: courseControllers[index],
                              focusNode: focusNodes[index],
                              decoration: const InputDecoration(
                                  labelText: 'Course Name'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          StatefulBuilder(
                            builder: (context, setStateDropdown) {
                              return DropdownButton<String>(
                                value: selectedCredits[index],
                                items: creditOptions.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setStateDropdown(() {
                                    selectedCredits[index] = newValue!;
                                  });
                                },
                              );
                            },
                          ),
                          const SizedBox(width: 10),
                          StatefulBuilder(
                            builder: (context, setStateDropdown) {
                              return DropdownButton<String>(
                                value: selectedGrades[index],
                                items: gradeOptions.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setStateDropdown(() {
                                    selectedGrades[index] = newValue!;
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: addCourse,
              icon: const Icon(Icons.add),
              label: const Text('Add Course'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateGPA,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Calculate'),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final double gpa;
  const ResultScreen({super.key, required this.gpa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('GPA Result'), backgroundColor: Colors.blue),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your GPA: ${gpa.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
