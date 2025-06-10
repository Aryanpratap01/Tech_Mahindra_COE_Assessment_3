import 'package:flutter/material.dart';
import '../models/workout_model.dart';
import '../utils/workout_storage.dart';

class AddWorkoutPage extends StatefulWidget {
  @override
  _AddWorkoutPageState createState() => _AddWorkoutPageState();
}

class _AddWorkoutPageState extends State<AddWorkoutPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _intensityController = TextEditingController();

  String? _selectedCategory;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> _categories = [
    'Cardio',
    'Strength',
    'Flexibility',
    'Balance',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    _intensityController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _saveWorkout() {
    if (_formKey.currentState!.validate()) {
      // Prepare the workout object
      final workout = Workout(
        title: _nameController.text.trim(),
        category: _selectedCategory!,
        duration: int.parse(_durationController.text.trim()),
        date: DateTime.now(),
        caloriesBurned: int.parse(_caloriesController.text.trim()),
        intensity: int.parse(_intensityController.text.trim()),
      );

      // Save workout via your storage utility
      WorkoutStorage.saveWorkout(workout);

      _animationController.forward(from: 0);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Workout Added Successfully!'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green.shade600,
        ),
      );

      _nameController.clear();
      _durationController.clear();
      _caloriesController.clear();
      _intensityController.clear();
      setState(() {
        _selectedCategory = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Add Workout')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: FadeTransition(
          opacity: _fadeAnimation.drive(Tween(begin: 1.0, end: 1.0)),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter Workout Details',
                  style: theme.textTheme.titleLarge,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Workout Name',
                    prefixIcon: Icon(Icons.fitness_center),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator:
                      (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Please enter workout name'
                              : null,
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.category),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items:
                      _categories
                          .map(
                            (cat) =>
                                DropdownMenuItem(child: Text(cat), value: cat),
                          )
                          .toList(),
                  onChanged: (val) => setState(() => _selectedCategory = val),
                  validator:
                      (value) =>
                          value == null ? 'Please select a category' : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Duration (minutes)',
                    prefixIcon: Icon(Icons.timer),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Please enter duration';
                    final n = int.tryParse(value);
                    if (n == null || n <= 0)
                      return 'Please enter a valid positive number';
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _caloriesController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Calories Burned',
                    prefixIcon: Icon(Icons.local_fire_department),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Please enter calories burned';
                    final n = int.tryParse(value);
                    if (n == null || n < 0)
                      return 'Please enter a valid number (0 or more)';
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _intensityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Intensity (1-10)',
                    prefixIcon: Icon(Icons.speed),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Please enter intensity';
                    final n = int.tryParse(value);
                    if (n == null || n < 1 || n > 10)
                      return 'Enter intensity between 1 and 10';
                    return null;
                  },
                ),
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.save),
                    label: Text(
                      'Save Workout',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _saveWorkout,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
