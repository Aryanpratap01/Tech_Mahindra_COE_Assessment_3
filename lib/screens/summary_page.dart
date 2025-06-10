import 'package:flutter/material.dart';
import '../models/workout_model.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({Key? key}) : super(key: key);

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  List<Workout> workouts = [];

  double get totalCalories =>
      workouts.fold(0, (sum, item) => sum + item.caloriesBurned.toDouble());

  double get totalDuration =>
      workouts.fold(0, (sum, item) => sum + item.duration.toDouble());

  String get averageIntensity {
    if (workouts.isEmpty) return 'N/A';
    final intensitySum = workouts.fold(0, (sum, item) => sum + item.intensity);
    final avg = intensitySum / workouts.length;
    if (avg < 3) return 'Low';
    if (avg < 6) return 'Moderate';
    return 'High';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is List<Workout>) {
      workouts = args;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasWorkouts = workouts.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text('Workout Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            hasWorkouts
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildStatCard(
                      context,
                      title: 'Total Workouts',
                      value: workouts.length.toString(),
                      icon: Icons.fitness_center,
                      color: Colors.blueAccent,
                    ),
                    SizedBox(height: 16),
                    _buildStatCard(
                      context,
                      title: 'Total Calories Burned',
                      value: totalCalories.toStringAsFixed(1),
                      icon: Icons.local_fire_department,
                      color: Colors.redAccent,
                    ),
                    SizedBox(height: 16),
                    _buildStatCard(
                      context,
                      title: 'Total Duration (mins)',
                      value: totalDuration.toStringAsFixed(1),
                      icon: Icons.timer,
                      color: Colors.orangeAccent,
                    ),
                    SizedBox(height: 16),
                    _buildStatCard(
                      context,
                      title: 'Average Intensity',
                      value: averageIntensity,
                      icon: Icons.speed,
                      color: Colors.green,
                    ),
                    Spacer(),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                      label: Text('Back'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
                : Center(
                  child: Text(
                    'No workouts logged yet.\nStart adding your workouts!',
                    style: theme.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, color: color, size: 30),
              radius: 30,
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 6),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: Text(
                      value,
                      key: ValueKey(value),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
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
}
