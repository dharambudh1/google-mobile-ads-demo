import "dart:async";
import "dart:developer";

import "package:after_layout/after_layout.dart";
import "package:flutter/material.dart";
import "package:google_mobile_ads/google_mobile_ads.dart";
import "package:google_mobile_ads_demo/helper/ad_helper.dart";

class RewardedInterstitialAdScreen extends StatefulWidget {
  const RewardedInterstitialAdScreen({super.key});

  @override
  State<RewardedInterstitialAdScreen> createState() =>
      _RewardedInterstitialAdScreenState();
}

class _RewardedInterstitialAdScreenState
    extends State<RewardedInterstitialAdScreen>
    with AfterLayoutMixin<RewardedInterstitialAdScreen> {
  RewardedInterstitialAd? _rewardedInterstitialAd;
  int _numRewardedInterstitialLoadAttempts = 0;
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

  Future<void> _createRewardedInterstitialAd() async {
    await RewardedInterstitialAd.load(
      adUnitId: AdHelperSingleton().rewardedInterstitialAd,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (RewardedInterstitialAd ad) async {
          _rewardedInterstitialAd = ad;
          _numRewardedInterstitialLoadAttempts = 0;
          await _rewardedInterstitialAd?.setImmersiveMode(true);
          await _showRewardedInterstitialAd();
        },
        onAdFailedToLoad: (LoadAdError error) {
          log("onAdFailedToLoad : LoadAdError : ${error.message}");
          _numRewardedInterstitialLoadAttempts += 1;
          _rewardedInterstitialAd = null;
          if (_numRewardedInterstitialLoadAttempts < maxFailedLoadAttempts) {
            _createRewardedInterstitialAd();
          }
        },
      ),
    );
    return Future<void>.value();
  }

  Future<void> _showRewardedInterstitialAd() async {
    if (_rewardedInterstitialAd == null) {
      log("Warning: attempt to show rewarded interstitial before loaded.");
      return;
    }
    _rewardedInterstitialAd?.fullScreenContentCallback =
        FullScreenContentCallback<RewardedInterstitialAd>(
      onAdShowedFullScreenContent: (RewardedInterstitialAd ad) {},
      onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) async {
        final NavigatorState navigatorState = Navigator.of(context);
        await ad.dispose();
        navigatorState.pop();
      },
      onAdFailedToShowFullScreenContent: (
        RewardedInterstitialAd ad,
        AdError error,
      ) async {
        log("onAdFailedToShowFullScreenContent : AdError : ${error.message}");
        await ad.dispose();
      },
      onAdWillDismissFullScreenContent: (RewardedInterstitialAd ad) {},
      onAdImpression: (RewardedInterstitialAd ad) {},
      onAdClicked: (RewardedInterstitialAd ad) {},
    );
    await _rewardedInterstitialAd?.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        final String r = "Reward $RewardItem(${reward.amount}, ${reward.type})";
        final SnackBar snackBar = SnackBar(
          content: Text(r),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );
    _rewardedInterstitialAd = null;
    return Future<void>.value();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    await _createRewardedInterstitialAd();
    return Future<void>.value();
  }
}
