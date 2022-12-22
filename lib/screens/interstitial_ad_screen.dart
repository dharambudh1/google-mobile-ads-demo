import "dart:async";
import "dart:developer";

import "package:after_layout/after_layout.dart";
import "package:flutter/material.dart";
import "package:google_mobile_ads/google_mobile_ads.dart";
import "package:google_mobile_ads_demo/helper/ad_helper.dart";

class InterstitialAdScreen extends StatefulWidget {
  const InterstitialAdScreen({super.key});

  @override
  State<InterstitialAdScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<InterstitialAdScreen>
    with AfterLayoutMixin<InterstitialAdScreen> {
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }

  Future<void> _createInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: AdHelperSingleton().interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) async {
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          await _interstitialAd?.setImmersiveMode(true);
          await _showInterstitialAd();
        },
        onAdFailedToLoad: (LoadAdError error) async {
          log("onAdFailedToLoad : LoadAdError : ${error.message}");
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
            await _createInterstitialAd();
          }
        },
      ),
    );
    return Future<void>.value();
  }

  Future<void> _showInterstitialAd() async {
    if (_interstitialAd == null) {
      log("Warning: attempt to show interstitial before loaded.");
      return;
    }
    _interstitialAd?.fullScreenContentCallback =
        FullScreenContentCallback<InterstitialAd>(
      onAdShowedFullScreenContent: (InterstitialAd ad) {},
      onAdDismissedFullScreenContent: (InterstitialAd ad) async {
        final NavigatorState navigatorState = Navigator.of(context);
        await ad.dispose();
        navigatorState.pop();
      },
      onAdFailedToShowFullScreenContent: (
        InterstitialAd ad,
        AdError error,
      ) async {
        log("onAdFailedToShowFullScreenContent : AdError : ${error.message}");
        await ad.dispose();
      },
      onAdWillDismissFullScreenContent: (InterstitialAd ad) {},
      onAdImpression: (InterstitialAd ad) {},
      onAdClicked: (InterstitialAd ad) {},
    );
    await _interstitialAd?.show();
    _interstitialAd = null;
    return Future<void>.value();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    await _createInterstitialAd();
    return Future<void>.value();
  }
}
