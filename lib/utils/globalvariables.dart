import 'package:wassapviews/libraries.dart';

String authKey = 'Bearer 3Du9FOEZy3JWkwTmromCggcWcSKx9OuIqeHk71j0TCYYvAv31wOYrAlXYkqC3FLq';
bool appJustLoaded = true;
String deviceName = UserSharedPreferences.getDeviceName();
String deviceID = UserSharedPreferences.getDeviceID();

class GlobalVariables {
  static String theme = UserSharedPreferences.getTheme();
  static String firstLaunch = UserSharedPreferences.getFirstLaunch();
  static bool watchAd = false;

  static String generateThemeFromRadioVal(int e) {
    String _mode = 'light';
    switch (e) {
      case 2:
        _mode = 'system';
        break;
      case 1:
        _mode = 'dark';
        break;
      default:
        _mode = 'light';
    }
    return _mode;
  }

  static int generateRadioValFromTheme(String e) {
    int _val = 0;
    switch (e) {
      case 'system':
        _val = 2;
        break;
      case 'dark':
        _val = 1;
        break;
      default:
        _val = 0;
    }
    return _val;
  }

  static ThemeMode generateThemeMode() {
    ThemeMode _val;
    switch (theme) {
      case 'system':
        _val = ThemeMode.system;
        break;
      case 'dark':
        _val = ThemeMode.dark;
        break;
      default:
        _val = ThemeMode.light;
    }
    return _val;
  }

  static bool isDarkMode() {
    Brightness _brightness = SchedulerBinding.instance!.window.platformBrightness;
    if (theme == 'dark' || (theme == 'system' && _brightness == Brightness.dark)) {
      return true;
    } else {
      return false;
    }
  }

  static String getString(int index) {
    String lang = UserSharedPreferences.getLanguage();
    return appLang[lang]![index];
  }

  static void loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: 'ca-app-pub-2125815836441893/3174810752',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          ad.show();
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
              ad.dispose();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('RewardedAd failed to load: $error');
        },
      ),
    );
  }
}
