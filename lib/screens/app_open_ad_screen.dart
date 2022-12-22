import "dart:async";
import "dart:developer";

import "package:after_layout/after_layout.dart";
import "package:flutter/material.dart";
import "package:google_mobile_ads/google_mobile_ads.dart";
import "package:google_mobile_ads_demo/helper/ad_helper.dart";

class AppOpenAdScreen extends StatefulWidget {
  const AppOpenAdScreen({super.key});

  @override
  State<AppOpenAdScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AppOpenAdScreen>
    with AfterLayoutMixin<AppOpenAdScreen> {
  AppOpenAd? _appOpenAd;
  int _numAppOpenLoadAttempts = 0;
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

  Future<void> _createAppOpenAd() async {
    await AppOpenAd.load(
      orientation: AppOpenAd.orientationPortrait,
      adUnitId: AdHelperSingleton().appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (AppOpenAd ad) async {
          _appOpenAd = ad;
          _numAppOpenLoadAttempts = 0;
          await _appOpenAd?.setImmersiveMode(true);
          await _showAppOpenAd();
        },
        onAdFailedToLoad: (LoadAdError error) async {
          log("onAdFailedToLoad : LoadAdError : ${error.message}");
          _numAppOpenLoadAttempts += 1;
          _appOpenAd = null;
          if (_numAppOpenLoadAttempts < maxFailedLoadAttempts) {
            await _createAppOpenAd();
          }
        },
      ),
    );
    return Future<void>.value();
  }

  Future<void> _showAppOpenAd() async {
    if (_appOpenAd == null) {
      log("Warning: attempt to show app open ad before loaded.");
      return;
    }
    _appOpenAd?.fullScreenContentCallback =
        FullScreenContentCallback<AppOpenAd>(
      onAdShowedFullScreenContent: (AppOpenAd ad) {},
      onAdDismissedFullScreenContent: (AppOpenAd ad) async {
        final NavigatorState navigatorState = Navigator.of(context);
        await ad.dispose();
        navigatorState.pop();
      },
      onAdFailedToShowFullScreenContent: (
        AppOpenAd ad,
        AdError error,
      ) async {
        log("onAdFailedToShowFullScreenContent : AdError : ${error.message}");
        await ad.dispose();
      },
      onAdWillDismissFullScreenContent: (AppOpenAd ad) {},
      onAdImpression: (AppOpenAd ad) {},
      onAdClicked: (AppOpenAd ad) {},
    );
    await _appOpenAd?.show();
    _appOpenAd = null;
    return Future<void>.value();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    await _createAppOpenAd();
    return Future<void>.value();
  }
}
