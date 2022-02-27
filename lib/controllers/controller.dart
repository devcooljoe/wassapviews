import 'package:wassapviews/libraries.dart';

class LangController extends StateNotifier {
  LangController() : super(UserSharedPreferences.getLanguage());

  void setLang(String lang) {
    state = lang;
  }
}

class RadioValueController extends StateNotifier {
  RadioValueController()
      : super(
          GlobalVariables.generateRadioValFromTheme(
            UserSharedPreferences.getTheme(),
          ),
        );

  void setRadioValue(int val) {
    state = val;
  }
}

class ThemeController extends StateNotifier {
  ThemeController() : super(UserSharedPreferences.getTheme());
  void setTheme(String theme) {
    state = theme;
  }
}

class OnboardScreenController extends StateNotifier {
  OnboardScreenController() : super(0);
  void setPage(int val) {
    state = val;
  }
}

class ContactCountController extends StateNotifier {
  ContactCountController() : super(UserSharedPreferences.getContactCount());

  void setCount(String num) {
    state = num;
  }
}

class LoadingDialogController extends StateNotifier {
  LoadingDialogController() : super(false);
  void setLoading(bool val) {
    state = val;
  }
}

class ReportReasonController extends StateNotifier {
  ReportReasonController() : super('Choose');
  String getState() {
    return state;
  }

  void setReason(String val) {
    state = val;
  }
}

class OtpSentController extends StateNotifier {
  OtpSentController() : super(false);
  void setSent(bool val) {
    state = val;
  }

  bool getSent() {
    return state;
  }
}

class PhoneNumberController extends StateNotifier {
  PhoneNumberController() : super((UserSharedPreferences.getUserPhoneNumber() == '') ? 'none' : UserSharedPreferences.getUserPhoneNumber());
  void setPhoneNumber(String val) {
    state = val;
  }

  String getPhoneNumber() {
    return state;
  }
}

class PremiumPlanController extends StateNotifier {
  PremiumPlanController() : super((UserSharedPreferences.getPremiumPlan() == '') ? 'none' : UserSharedPreferences.getPremiumPlan());
  String getPremiumPlan() {
    return state;
  }

  void setPremiumPlan(String val) async {
    await UserSharedPreferences.setPremiumPlan(val);
    state = val;
  }
}

class EndPlanDateController extends StateNotifier {
  EndPlanDateController() : super((UserSharedPreferences.getEndPlanDate() == '') ? 'none' : UserSharedPreferences.getEndPlanDate());
  void setEndPlanDate(String val) async {
    await UserSharedPreferences.setEndPlanDate(val);
    state = val;
  }
}

class InternetController extends StateNotifier {
  InternetController() : super(true);

  void setInternet(bool val) {
    state = val;
  }
}

class PremiumPlanStatusController extends StateNotifier {
  PremiumPlanStatusController() : super(UserSharedPreferences.getPremiumPlanStatus());

  String getPremiumPlanStatus() {
    return state;
  }

  void setPremiumPlanStatus(String val) async {
    await UserSharedPreferences.setPremiumPlanStatus(val);
    state = val;
  }
}

class WatchAdController extends StateNotifier {
  WatchAdController() : super(true);

  void setWatchAd(bool val) {
    state = val;
  }
}
