import 'dart:async';
import 'package:wassapviews/libraries.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService.initialize();
  await MobileAds.instance.initialize();
  await UserSharedPreferences.init();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    ProviderScope(
      child: Phoenix(
        child: Wassapviews(),
      ),
    ),
  );
}

class Wassapviews extends StatelessWidget {
  const Wassapviews({Key? key}) : super(key: key);

  void _getDeviceInfo() async {
    if (deviceName == '' || deviceID == '') {
      String deviceName = '';
      String deviceID = '';
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      try {
        if (Platform.isAndroid) {
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          deviceName = androidInfo.model;
          deviceID = androidInfo.androidId;
        } else if (Platform.isIOS) {
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          deviceName = iosInfo.name;
          deviceID = iosInfo.identifierForVendor;
        }
      } on PlatformException {
        debugPrint('Failed to get platform version');
      }
      await UserSharedPreferences.setDeviceName(deviceName);
      await UserSharedPreferences.setDeviceID(deviceID);
      deviceName = deviceName;
      deviceID = deviceID;
    }
  }

  @override
  Widget build(BuildContext context) {
    _getDeviceInfo();
    Timer.periodic(Duration(seconds: 2), (Timer t) => checkForInternetConnection(context));
    return MaterialApp(
      title: 'Wassapviews',
      home: GlobalVariables.firstLaunch == 'true' ? OnboardScreen() : HomeScreen(),
      theme: appTheme,
      darkTheme: appThemeDark,
      themeMode: GlobalVariables.generateThemeMode(),
      debugShowCheckedModeBanner: false,
      routes: {
        'home': (_) => HomeScreen(),
        'submit': (_) => SubmitContactScreen(),
        'getvcf': (_) => GetVcfScreen(),
        'premium': (_) => GoPremiumScreen(),
      },
    );
  }

  checkForInternetConnection(BuildContext context) async {
    InternetController _controller = context.read(internetProvider.notifier);
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _controller.setInternet(true);
      }
    } on SocketException catch (_) {
      _controller.setInternet(false);
    } catch (e) {
      print('Error: $e');
    }
  }
}
