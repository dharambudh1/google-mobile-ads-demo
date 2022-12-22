import "dart:async";
import "dart:developer";

import "package:after_layout/after_layout.dart";
import "package:flutter/material.dart";
import "package:google_mobile_ads/google_mobile_ads.dart";
import "package:google_mobile_ads_demo/helper/ad_helper.dart";

class RewardedAdScreen extends StatefulWidget {
  const RewardedAdScreen({super.key});

  @override
  State<RewardedAdScreen> createState() => _RewardedAdScreenState();
}

class _RewardedAdScreenState extends State<RewardedAdScreen>
    with AfterLayoutMixin<RewardedAdScreen> {
  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;
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

  Future<void> _createRewardedAd() async {
    await RewardedAd.load(
      adUnitId: AdHelperSingleton().rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) async {
          _rewardedAd = ad;
          _numRewardedLoadAttempts = 0;
          await _rewardedAd?.setImmersiveMode(true);
          await _showRewardedAd();
        },
        onAdFailedToLoad: (LoadAdError error) async {
          log("onAdFailedToLoad : LoadAdError : ${error.message}");
          _numRewardedLoadAttempts += 1;
          _rewardedAd = null;
          if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
            await _createRewardedAd();
          }
        },
      ),
    );
    return Future<void>.value();
  }

  Future<void> _showRewardedAd() async {
    if (_rewardedAd == null) {
      log("Warning: attempt to show rewarded before loaded.");
      return;
    }
    _rewardedAd?.fullScreenContentCallback =
        FullScreenContentCallback<RewardedAd>(
      onAdShowedFullScreenContent: (RewardedAd ad) {},
      onAdDismissedFullScreenContent: (RewardedAd ad) async {
        final NavigatorState navigatorState = Navigator.of(context);
        await ad.dispose();
        navigatorState.pop();
      },
      onAdFailedToShowFullScreenContent: (
        RewardedAd ad,
        AdError error,
      ) async {
        log("onAdFailedToShowFullScreenContent : AdError : ${error.message}");
        await ad.dispose();
      },
      onAdWillDismissFullScreenContent: (RewardedAd ad) {},
      onAdImpression: (RewardedAd ad) {},
      onAdClicked: (RewardedAd ad) {},
    );
    await _rewardedAd?.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        final String r = "Reward $RewardItem(${reward.amount}, ${reward.type})";
        final SnackBar snackBar = SnackBar(
          content: Text(r),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );
    _rewardedAd = null;
    return Future<void>.value();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    await _createRewardedAd();
    return Future<void>.value();
  }
}
