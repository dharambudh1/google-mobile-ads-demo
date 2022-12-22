import "package:flutter/material.dart";
import "package:google_mobile_ads_demo/screens/app_open_ad_screen.dart";
import "package:google_mobile_ads_demo/screens/banner_ad_screen.dart";
import "package:google_mobile_ads_demo/screens/interstitial_ad_screen.dart";
import "package:google_mobile_ads_demo/screens/rewarded_ad_screen.dart";
import "package:google_mobile_ads_demo/screens/rewarded_interstitial_ad.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Mobile Ads Demo"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              commonButton(
                buttonText: "App Open Ad",
                widget: const AppOpenAdScreen(),
              ),
              const SizedBox(height: 50),
              commonButton(
                buttonText: "Banner Ad",
                widget: const BannerAdScreen(),
              ),
              const SizedBox(height: 50),
              commonButton(
                buttonText: "Interstitial (Full-Screen) Ad",
                widget: const InterstitialAdScreen(),
              ),
              const SizedBox(height: 50),
              commonButton(
                buttonText: "Rewarded Ad",
                widget: const RewardedAdScreen(),
              ),
              const SizedBox(height: 50),
              commonButton(
                buttonText: "Rewarded Interstitial Ad",
                widget: const RewardedInterstitialAdScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget commonButton({required String buttonText, required Widget widget}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.60,
      child: ElevatedButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return widget;
              },
            ),
          );
        },
        child: Text(buttonText),
      ),
    );
  }
}
