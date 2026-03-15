import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/irma_theme.dart';
import '../models/irma_cycle_data.dart';
import '../services/irma_cycle_engine.dart';

class IrmaMonthCalendar extends StatefulWidget {
  final IrmaCycleData cycleData;
  final Function(DateTime) onDateSelected;

  const IrmaMonthCalendar({
    super.key,
    required this.cycleData,
    required this.onDateSelected,
  });

  @override
  State<IrmaMonthCalendar> createState() => _IrmaMonthCalendarState();
}

class _IrmaMonthCalendarState extends State<IrmaMonthCalendar> {
  DateTime _currentMonth = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345, // Gospel Standard Width
      padding: const EdgeInsets.all(24), // Increased padding for 345px width
      decoration: BoxDecoration(
        color: IrmaTheme.pureWhite,
        borderRadius: BorderRadius.circular(IrmaTheme.radiusCard), // Gospel Standard Radius
        border: Border.all(color: IrmaTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: IrmaTheme.pureBlack.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // HEADER (Month Year + Nav)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('MMMM yyyy').format(_currentMonth),
                style: IrmaTheme.outfit.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: IrmaTheme.textMain,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: IrmaTheme.textSub),
                    onPressed: () => setState(() => _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, color: IrmaTheme.textSub),
                    onPressed: () => setState(() => _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // WEEKDAY LABELS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day) => Expanded(
              child: Center(
                child: Text(
                  day,
                  style: IrmaTheme.inter.copyWith(
                    fontSize: 12,
                    color: IrmaTheme.textSub,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 12),

          // CALENDAR GRID
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstDayOffset = DateTime(_currentMonth.year, _currentMonth.month, 1).weekday - 1;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: daysInMonth + firstDayOffset,
      itemBuilder: (context, index) {
        if (index < firstDayOffset) return const SizedBox();

        final day = index - firstDayOffset + 1;
        final date = DateTime(_currentMonth.year, _currentMonth.month, day);
        final isSelected = isSameDay(date, _selectedDate);
        
        // Use the Cycle Engine to determine phase colors
        final state = IrmaCycleEngine.calculateState(widget.cycleData, date);
        final phaseColor = _getPhaseColor(state.phase);

        return GestureDetector(
          onTap: () {
            setState(() => _selectedDate = date);
            widget.onDateSelected(date);
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? IrmaTheme.textMain : (phaseColor != Colors.transparent ? phaseColor.withOpacity(0.1) : Colors.transparent),
              borderRadius: BorderRadius.circular(IrmaTheme.radiusTile), // Gospel Rule: Rounded but not pill for grid cells
              border: isSelected 
                ? null 
                : (phaseColor != Colors.transparent 
                    ? Border.all(color: phaseColor.withOpacity(0.3)) 
                    : Border.all(color: IrmaTheme.borderLight.withOpacity(0.5))),
            ),
            child: Text(
              day.toString(),
              style: IrmaTheme.outfit.copyWith(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? IrmaTheme.pureWhite : IrmaTheme.textMain,
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getPhaseColor(IrmaCyclePhase phase) {
    switch (phase) {
      case IrmaCyclePhase.menstrual: return IrmaTheme.menstrual;
      case IrmaCyclePhase.follicular: return IrmaTheme.follicular;
      case IrmaCyclePhase.ovulation: return IrmaTheme.ovulation;
      case IrmaCyclePhase.luteal: return IrmaTheme.luteal;
      default: return Colors.transparent;
    }
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
