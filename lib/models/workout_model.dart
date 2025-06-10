class Workout {
  final String title;
  final String category;
  final int duration; // in minutes
  final DateTime date;
  final int caloriesBurned;
  final int intensity; // maybe scale 1 to 10

  Workout({
    required this.title,
    required this.category,
    required this.duration,
    required this.date,
    required this.caloriesBurned,
    required this.intensity,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'category': category,
    'duration': duration,
    'date': date.toIso8601String(),
    'caloriesBurned': caloriesBurned,
    'intensity': intensity,
  };

  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
    title: json['title'],
    category: json['category'],
    duration: json['duration'],
    date: DateTime.parse(json['date']),
    caloriesBurned: json['caloriesBurned'],
    intensity: json['intensity'],
  );

  static List<Workout> listFromJson(List<dynamic> jsonList) =>
      jsonList.map((json) => Workout.fromJson(json)).toList();

  static List<Map<String, dynamic>> listToJson(List<Workout> workouts) =>
      workouts.map((w) => w.toJson()).toList();
}
