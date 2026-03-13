import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';

class WeeklyStrip extends StatelessWidget {
  final DateTime selectedDate;
  const WeeklyStrip({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    // Generate dates for the current week centered around selectedDate
    final startOfWeek = selectedDate.subtract(Duration(days: selectedDate.weekday % 7));
    final dates = List.generate(7, (index) => startOfWeek.add(Duration(days: index)));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.chevron_left, color: Colors.grey, size: 20),
              Text(
                DateFormat('MMMM, yyyy').format(selectedDate),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: dates.map((date) => _buildDateItem(date)).toList(),
        ),
      ],
    );
  }

  Widget _buildDateItem(DateTime date) {
    final isSelected = date.day == selectedDate.day && date.month == selectedDate.month;
    final dayLabel = DateFormat('E').format(date); // Mon, Tue...
    
    return Column(
      children: [
        Text(
          dayLabel,
          style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            shape: BoxShape.circle,
            border: isSelected ? null : Border.all(color: AppColors.border, width: 1),
          ),
          child: Center(
            child: Text(
              '${date.day < 10 ? '0' : ''}${date.day}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
