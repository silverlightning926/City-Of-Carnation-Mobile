import 'package:city_of_carnation/services/auth_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  static Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    return analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  static Future<void> logEventCardClick({
    required String id,
    required String title,
  }) async {
    return analytics.logEvent(
      name: 'event_card_click',
      parameters: {
        'id': id,
        'title': title,
      },
    );
  }

  static Future<void> newsCardClick({
    required String id,
    required String title,
  }) async {
    return analytics.logEvent(
      name: 'news_card_click',
      parameters: {
        'id': id,
        'title': title,
      },
    );
  }

  static Future<void> workOrderCreated({
    required String title,
  }) async {
    return analytics.logEvent(
      name: 'work_order_created',
      parameters: {
        'title': title,
      },
    );
  }

  static Future<void> workOrderCardClicked({
    required String id,
    required String title,
  }) async {
    return analytics.logEvent(
      name: 'work_order_card_click',
      parameters: {
        'id': id,
        'title': title,
      },
    );
  }

  static Future<void> logLogin() async {
    return analytics.logLogin();
  }

  static Future<void> setUserProperties({
    required String name,
    required String value,
  }) async {
    return analytics.setUserProperty(
      name: name,
      value: value,
    );
  }

  static Future<void> setUserId() async {
    return analytics.setUserId(id: AuthService.userId);
  }

  static Future<void> removeUserId() async {
    return analytics.setUserId(id: null);
  }

  static FirebaseAnalyticsObserver get analyticsObserver {
    return FirebaseAnalyticsObserver(analytics: analytics);
  }
}
