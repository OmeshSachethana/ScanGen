import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static String get bannerAdUnitId {
    // Test ID
    return 'ca-app-pub-3940256099942544/6300978111';
    // Your real ID: 'ca-app-pub-7716352626622549/1279583495';
  }

  static Future<InitializationStatus> initialize() {
    return MobileAds.instance.initialize();
  }
}
