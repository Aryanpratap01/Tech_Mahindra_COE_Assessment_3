import 'package:flutter/material.dart';
import '../models/workout_model.dart';
import '../utils/workout_storage.dart';
import '../widgets/workout_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<Workout> _workouts = [];
  bool _isLoading = true;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
  }

  Future<void> _loadWorkouts() async {
    final workouts = await WorkoutStorage.loadWorkouts();
    setState(() {
      _workouts = workouts;
      _isLoading = false;
    });
    _animationController.forward();
  }

  Future<void> _refresh() async {
    await _loadWorkouts();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToAddWorkout() async {
    final result = await Navigator.pushNamed(context, '/add');
    if (result == true) {
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Fitness Tracker'),
        actions: [
          IconButton(
            tooltip: 'Summary',
            icon: Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.pushNamed(context, '/summary', arguments: _workouts);
            },
          ),
          IconButton(
            tooltip: 'BMI Calculator',
            icon: Icon(Icons.monitor_weight),
            onPressed: () {
              Navigator.pushNamed(context, '/bmi');
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(theme.primaryColor),
                ),
              )
              : _workouts.isEmpty
              ? Center(
                child: Text(
                  'No workouts logged yet.\nTap + to add your first workout!',
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              )
              : RefreshIndicator(
                onRefresh: _refresh,
                color: theme.primaryColor,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  itemCount: _workouts.length,
                  itemBuilder: (context, index) {
                    final workout = _workouts[index];
                    return FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(
                          (index / _workouts.length).clamp(0, 1),
                          1.0,
                          curve: Curves.easeOut,
                        ),
                      ),
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0, 0.1),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Interval(
                              (index / _workouts.length).clamp(0, 1),
                              1.0,
                              curve: Curves.easeOut,
                            ),
                          ),
                        ),
                        child: WorkoutCard(workout: workout),
                      ),
                    );
                  },
                ),
              ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Workout',
        onPressed: _navigateToAddWorkout,
        child: Icon(Icons.add),
        elevation: 6,
      ),
    );
  }
}
