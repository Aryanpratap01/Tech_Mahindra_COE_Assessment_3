import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/workout_model.dart';

class WorkoutStorage {
  static const _key = 'workouts';

  // Clear corrupt or invalid stored data
  static Future<void> clearCorruptData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  // Load saved workouts safely with error handling
  static Future<List<Workout>> loadWorkouts() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final stored = prefs.getString(_key);
      if (stored == null) return [];

      final List<dynamic> decoded = jsonDecode(stored);
      return decoded.map((e) => Workout.fromJson(e)).toList();
    } catch (e) {
      // If data corrupted or wrong type, clear and return empty list
      await clearCorruptData();
      return [];
    }
  }

  // Save a workout safely with error handling
  static Future<void> saveWorkout(Workout workout) async {
    final prefs = await SharedPreferences.getInstance();

    List<Workout> workouts = [];

    try {
      final stored = prefs.getString(_key);
      if (stored != null) {
        final List<dynamic> decoded = jsonDecode(stored);
        workouts = decoded.map((e) => Workout.fromJson(e)).toList();
      }
    } catch (e) {
      // Clear corrupt data and start fresh
      await clearCorruptData();
      workouts = [];
    }

    workouts.add(workout);

    final updatedJson = jsonEncode(Workout.listToJson(workouts));
    await prefs.setString(_key, updatedJson);
  }
}
