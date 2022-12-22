import "dart:io";

class AdHelperSingleton {
  factory AdHelperSingleton() {
    return _singleton;
  }

  AdHelperSingleton._internal();

  static final AdHelperSingleton _singleton = AdHelperSingleton._internal();

  String get appOpenAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/3419835294";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/5662855259";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/2934735716";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/7049598008";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/3964253750";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/8673189370";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/7552160883";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  String get rewardedInterstitialAd {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/5354046379";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/6978759866";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
