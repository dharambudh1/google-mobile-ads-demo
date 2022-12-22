import "dart:async";
import "dart:developer";
import "dart:io";

import "package:after_layout/after_layout.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:google_mobile_ads/google_mobile_ads.dart";
import "package:google_mobile_ads_demo/helper/ad_helper.dart";

class BannerAdScreen extends StatefulWidget {
  const BannerAdScreen({super.key});

  @override
  State<BannerAdScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<BannerAdScreen>
    with AfterLayoutMixin<BannerAdScreen> {
  late BannerAd _bannerAd;
  String _bannerError = "";

  @override
  void initState() {
    super.initState();
    _bannerAd = _initBannerAd();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Banner Ad"),
      ),
      body: SafeArea(
        child: Center(
          child: _bannerError == ""
              ? Platform.isIOS
                  ? const CupertinoActivityIndicator()
                  : Platform.isAndroid
                      ? const CircularProgressIndicator()
                      : const SizedBox()
              : _bannerError == "_"
                  ? SizedBox(
                      height: _bannerAd.size.height.toDouble(),
                      width: _bannerAd.size.width.toDouble(),
                      child: AdWidget(ad: _bannerAd),
                    )
                  : Text(_bannerError),
        ),
      ),
    );
  }

  BannerAd _initBannerAd() {
    return BannerAd(
      adUnitId: AdHelperSingleton().bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          _bannerError = "_";
          setState(() {});
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) async {
          log("onAdFailedToLoad : LoadAdError : ${error.message}");
          _bannerError = error.message;
          setState(() {});
          await ad.dispose();
        },
        onAdOpened: (Ad ad) {},
        onAdClosed: (Ad ad) {},
        onAdWillDismissScreen: (Ad ad) {},
        onAdImpression: (Ad ad) {},
        onPaidEvent: (
          Ad ad,
          double valueMicros,
          PrecisionType precision,
          String currencyCode,
        ) {},
        onAdClicked: (Ad ad) {},
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    await _bannerAd.load();
    return Future<void>.value();
  }
}
