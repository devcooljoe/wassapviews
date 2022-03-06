import 'package:wassapviews/libraries.dart';

final langProvider = StateNotifierProvider((ref) => LangController());

final radioValueProvider = StateNotifierProvider((ref) => RadioValueController());

final themeProvider = StateNotifierProvider((_) => ThemeController());

final onboardScreenProvider = StateNotifierProvider((_) => OnboardScreenController());

final contactCountProvider = StateNotifierProvider((ref) => ContactCountController());

final loadingDialogProvider = StateNotifierProvider((ref) => LoadingDialogController());

final reportReasonProvider = StateNotifierProvider((ref) => ReportReasonController());

final otpSentProvider = StateNotifierProvider((_) => OtpSentController());

final phoneNumberProvider = StateNotifierProvider((_) => PhoneNumberController());

final premiumPlanProvider = StateNotifierProvider((ref) => PremiumPlanController());

final endPlanDateProvider = StateNotifierProvider((ref) => EndPlanDateController());

final internetProvider = StateNotifierProvider((ref) => InternetController());

final premiumPlanStatusProvider = StateNotifierProvider((ref) => PremiumPlanStatusController());

final watchAdProvider = StateNotifierProvider((ref) => WatchAdController());

final shareAppProvider = StateNotifierProvider((ref) => ShareAppController());
