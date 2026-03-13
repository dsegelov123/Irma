import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../widgets/kawaii_asset.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Calendar', style: TextStyle(fontFamily: 'Lufga', fontSize: 20)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Month Selector / Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   const Icon(Icons.chevron_left, color: Colors.grey),
                   const Text('April, 2023', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                   const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
            
            // Simplified Calendar Grid
            _buildCalendarGrid(),
            
            const SizedBox(height: 32),
            
            // Phase Legend Tabs
            _buildPhaseTabs(),
            
            const SizedBox(height: 48),
            
            // Any Symptoms / Add Button
            const Text('Any Symptoms', style: TextStyle(fontFamily: 'Lufga', fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('How Are You Feeling Today?', style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            
            _buildAddSymptomsButton(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2EF).withOpacity(0.5),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          _buildWeekDays(),
          const SizedBox(height: 16),
          // Placeholder for actual grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
            itemCount: 31,
            itemBuilder: (context, index) {
              final day = index + 1;
              final isToday = day == 6;
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isToday ? AppColors.primary : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        day < 10 ? '0$day' : '$day',
                        style: TextStyle(
                          fontSize: 12,
                          color: isToday ? Colors.white : AppColors.textPrimary,
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (day % 7 == 0) // Example pips
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDays() {
    const days = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days.map((d) => Text(d, style: const TextStyle(fontSize: 10, color: Colors.grey))).toList(),
    );
  }

  Widget _buildPhaseTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
           _buildTab(KawaiiFunction.periods, 'Periods', const Color(0xFFE8E7FF)),
           _buildTab(KawaiiFunction.mucus, 'Muscus', const Color(0xFFFFF2E8)),
           _buildTab(KawaiiFunction.ovulation, 'Ovulation', const Color(0xFFFFE8EF)),
           _buildTab(KawaiiFunction.looming, 'Looming', const Color(0xFFE7F3FF)),
        ],
      ),
    );
  }

  Widget _buildTab(KawaiiFunction function, String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          KawaiiAsset.function(function, size: 24),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildAddSymptomsButton(BuildContext context) {
    return Column(
      children: [
        const KawaiiAsset.mood(KawaiiMood.thinking, size: 64),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/symptoms'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primarySoft),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: const Text('Add Symptoms', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
