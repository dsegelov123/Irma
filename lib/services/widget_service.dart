import 'package:home_widget/home_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user_profile.dart';

class WidgetService {
  static final String _groupId = dotenv.env['APP_GROUP_ID'] ?? 'group.com.irma.app';

  static Future<void> updateWidgets(UserProfile profile, String currentPhase, String dailyInsight, int cycleDay) async {
    try {
      // Sync basic data for the widget to read
      await HomeWidget.saveWidgetData<String>('current_phase', currentPhase);
      await HomeWidget.saveWidgetData<String>('daily_insight', dailyInsight);
      await HomeWidget.saveWidgetData<int>('cycle_day', cycleDay);

      // Trigger native redraw
      await HomeWidget.updateWidget(
        name: 'IrmaWidgetProvider',
        iOSName: 'IrmaWidget',
      );
    } catch (e) {
      // Silent fail in MVP
    }
  }
}
