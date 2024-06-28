import 'package:coozy_the_cafe/utlis/components/constants.dart';

class AnalyticsService {
  static void trackEvent(String eventName) {
    // This method could use a package like Firebase Analytics, Mixpanel, or any other analytics service
    // to track the given event.
    Constants.debugLog(AnalyticsService, 'Tracking event: $eventName');
    // Example with Firebase Analytics:
    // FirebaseAnalytics().logEvent(name: eventName, parameters: null);
  }
}