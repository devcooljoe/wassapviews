import 'package:wassapviews/libraries.dart';

class UserSharedPreferences {
  static SharedPreferences? _preferences;
  static String themeMode = 'themeMode';
  static String language = 'language';
  static String firstLaunch = 'firstLaunch';
  static String deviceName = 'deviceName';
  static String deviceID = 'deviceID';
  static String contactCount = 'contactCount';
  static String userIsoCode = 'isoCode';
  static String userDialCode = 'dialCode';
  static String userPhoneNumber = 'phoneNumber';
  static String verificationId = 'verificationId';
  static String premiumPlan = 'premiumPlan';
  static String endPlanDate = 'endPlanDate';
  static String premiumPlanStatus = 'premiumPlanStatus';
  static String rated = 'rated';
  static String shared = 'shared';
  static String watchedVideo = 'watchedVideo';
  static String paidPlan = 'paidPlan';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setTheme(String val) async => await _preferences!.setString(themeMode, val);
  static String getTheme() => _preferences!.getString(themeMode) ?? "system";

  static Future setLanguage(String val) async => await _preferences!.setString(language, val);
  static String getLanguage() => _preferences!.getString(language) ?? "English";

  static Future setFirstLaunch(String val) async => await _preferences!.setString(firstLaunch, val);
  static String getFirstLaunch() => _preferences!.getString(firstLaunch) ?? "true";

  static Future setDeviceName(String val) async => await _preferences!.setString(deviceName, val);
  static String getDeviceName() => _preferences!.getString(deviceName) ?? "";

  static Future setDeviceID(String val) async => await _preferences!.setString(deviceID, val);
  static String getDeviceID() => _preferences!.getString(deviceID) ?? "";

  static Future setContactCount(String val) async => await _preferences!.setString(contactCount, val);
  static String getContactCount() => _preferences!.getString(contactCount) ?? "0";

  static Future setUserIsoCode(String val) async => await _preferences!.setString(userIsoCode, val);
  static String? getUserIsoCode() => _preferences!.getString(userIsoCode) ?? 'US';

  static Future setUserDialCode(String val) async => await _preferences!.setString(userDialCode, val);
  static String? getUserDialCode() => _preferences!.getString(userDialCode) ?? '+1';

  static Future setUserPhoneNumber(String val) async => await _preferences!.setString(userPhoneNumber, val);
  static String? getUserPhoneNumber() => _preferences!.getString(userPhoneNumber) ?? "";

  static Future setVerificationId(String val) async => await _preferences!.setString(verificationId, val);
  static String? getVerificationId() => _preferences!.getString(verificationId) ?? "";

  static Future setPremiumPlan(String val) async => await _preferences!.setString(premiumPlan, val);
  static String? getPremiumPlan() => _preferences!.getString(premiumPlan) ?? "";

  static Future setEndPlanDate(String val) async => await _preferences!.setString(endPlanDate, val);
  static String? getEndPlanDate() => _preferences!.getString(endPlanDate) ?? "";

  static Future setPremiumPlanStatus(String val) async => await _preferences!.setString(premiumPlanStatus, val);
  static String? getPremiumPlanStatus() => _preferences!.getString(premiumPlanStatus) ?? "none";

  static Future setRated(String val) async => await _preferences!.setString(rated, val);
  static String? getRated() => _preferences!.getString(rated) ?? "false";

  static Future setShared(String val) async => await _preferences!.setString(shared, val);
  static String? getShared() => _preferences!.getString(shared) ?? "false";

  static Future setWatchedVideo(bool val) async => await _preferences!.setBool(watchedVideo, val);
  static bool? getWatchedVideo() => _preferences!.getBool(watchedVideo) ?? false;

  static Future setPaidPlan(String val) async => await _preferences!.setString(paidPlan, val);
  static String? getPaidPlan() => _preferences!.getString(paidPlan) ?? 'free';
}
