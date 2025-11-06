import 'dart:ui';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdHelper {
  InterstitialAd? _interstitialAd;

  /// Loads an interstitial ad
  void loadAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // ✅ Test ID
      // Use your real ID in production, e.g.:
      // 'ca-app-pub-7716352626622549/xxxxxxxxxx',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialAd?.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialAd = null;
        },
      ),
    );
  }

  /// Shows the ad, then performs an action (e.g., generate QR)
  void showAd({required VoidCallback onAdClosed}) {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _interstitialAd = null;
          loadAd(); // Prepare next ad
          onAdClosed(); // Continue action
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          _interstitialAd = null;
          loadAd();
          onAdClosed();
        },
      );

      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      // Ad not ready — continue without showing ad
      onAdClosed();
      loadAd(); // Try loading again
    }
  }

  void dispose() {
    _interstitialAd?.dispose();
  }
}
