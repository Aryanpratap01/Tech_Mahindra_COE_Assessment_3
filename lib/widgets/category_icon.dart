import 'package:flutter/material.dart';

class CategoryIcon extends StatelessWidget {
  final String category;

  const CategoryIcon({required this.category});

  IconData _getIconData(String category) {
    switch (category.toLowerCase()) {
      case 'cardio':
        return Icons.directions_run;
      case 'strength':
        return Icons.fitness_center;
      case 'yoga':
        return Icons.self_improvement;
      default:
        return Icons.category;
    }
  }

  Color _getIconColor(String category, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (category.toLowerCase()) {
      case 'cardio':
        return isDark ? Colors.redAccent.shade100 : Colors.red.shade400;
      case 'strength':
        return isDark ? Colors.blueAccent.shade100 : Colors.blue.shade400;
      case 'yoga':
        return isDark ? Colors.purpleAccent.shade100 : Colors.purple.shade400;
      default:
        return isDark ? Colors.grey.shade400 : Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getIconColor(category, context).withOpacity(0.2),
      ),
      padding: EdgeInsets.all(10),
      child: Icon(
        _getIconData(category),
        color: _getIconColor(category, context),
        size: 28,
      ),
    );
  }
}
