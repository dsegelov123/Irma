import '../services/error_reporting_service.dart';

class FeedbackService {
  static Future<void> sendFeedback(String feedback, String category) async {
    // In production, this would call an API or send an email.
    // For now, we log it to our technical service.
    
    ErrorReportingService.recordMessage('USER FEEDBACK [$category]: $feedback');
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
  }
}
