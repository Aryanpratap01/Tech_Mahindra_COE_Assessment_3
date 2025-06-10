import 'package:flutter/material.dart';

class BMICalculatorPage extends StatefulWidget {
  @override
  _BMICalculatorPageState createState() => _BMICalculatorPageState();
}

class _BMICalculatorPageState extends State<BMICalculatorPage>
    with SingleTickerProviderStateMixin {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  String? _bmiResult;
  String? _bmiStatus;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _calculateBMI() {
    final weightText = _weightController.text.trim();
    final heightText = _heightController.text.trim();

    if (weightText.isEmpty || heightText.isEmpty) {
      _showSnackBar('Please enter both weight and height');
      return;
    }

    final weight = double.tryParse(weightText);
    final heightCm = double.tryParse(heightText);

    if (weight == null || weight <= 0 || heightCm == null || heightCm <= 0) {
      _showSnackBar('Enter valid positive numbers for weight and height');
      return;
    }

    final heightM = heightCm / 100;
    final bmi = weight / (heightM * heightM);
    String status;

    if (bmi < 18.5) {
      status = 'Underweight';
    } else if (bmi < 25) {
      status = 'Normal';
    } else if (bmi < 30) {
      status = 'Overweight';
    } else {
      status = 'Obese';
    }

    setState(() {
      _bmiResult = bmi.toStringAsFixed(2);
      _bmiStatus = status;
    });

    _animationController.forward(from: 0);
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('BMI Calculator')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Enter your details to calculate BMI',
              style: theme.textTheme.titleLarge,
            ),
            SizedBox(height: 25),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Weight (kg)',
                prefixIcon: Icon(Icons.fitness_center),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Height (cm)',
                prefixIcon: Icon(Icons.height),
              ),
            ),
            SizedBox(height: 25),
            ElevatedButton.icon(
              icon: Icon(Icons.calculate),
              label: Text('Calculate BMI'),
              onPressed: _calculateBMI,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 40),
            FadeTransition(
              opacity: _fadeAnimation,
              child:
                  _bmiResult == null
                      ? SizedBox.shrink()
                      : Column(
                        children: [
                          Text(
                            'Your BMI is',
                            style: theme.textTheme.titleMedium,
                          ),
                          SizedBox(height: 10),
                          Text(
                            _bmiResult!,
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            _bmiStatus!,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: _getStatusColor(_bmiStatus!, theme),
                            ),
                          ),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status, ThemeData theme) {
    switch (status) {
      case 'Underweight':
        return Colors.orangeAccent;
      case 'Normal':
        return Colors.greenAccent;
      case 'Overweight':
        return Colors.amber;
      case 'Obese':
        return Colors.redAccent;
      default:
        return theme.colorScheme.secondary;
    }
  }
}
