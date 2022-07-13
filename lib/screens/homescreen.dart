import 'dart:async';
import 'package:wassapviews/libraries.dart';
import 'package:wassapviews/utils/methods.dart';
import 'package:wassapviews/widgets/others.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  static GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      LocalNotificationService.display(message);
    });
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        Navigator.pushNamed(context, message.data['route']);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Navigator.pushNamed(context, message.data['route']);
    });
    PremiumPlanStatusController _premiumPlanStatusController = context.read(premiumPlanStatusProvider.notifier);
    ShareAppController _shareAppController = context.read(shareAppProvider.notifier);
    if (_premiumPlanStatusController.getPremiumPlanStatus() != 'active') {
      Future.delayed(Duration(seconds: 60), () => GlobalVariables.loadInterstitialAd());
      Timer.periodic(Duration(seconds: 300), (Timer t) => GlobalVariables.loadInterstitialAd());
    }
    if (appJustLoaded) {
      Future.delayed(Duration(seconds: 1), () => Methods.fetchContactCount(context));
      Future.delayed(Duration(seconds: 1), () => Methods.checkPremiumPlanStatus(context));
      Future.delayed(Duration(seconds: 1), () => Methods.checkForUpdate());
      Future.delayed(Duration(seconds: 1), () => Methods.getStoragePermission());
    }

    appJustLoaded = false;
    return Scaffold(
      appBar: AppBar(
        title: AppTitleName(),
        actions: <Widget>[
          Consumer(builder: (context, watch, widget) {
            return IconButton(
              tooltip: appLang[watch(langProvider) as String]![0], // Theme
              icon: Icon(
                GlobalVariables.isDarkMode() ? Icons.light_mode : Icons.dark_mode,
                color: Theme.of(context).buttonColor,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => ThemeDialog(),
                );
              },
            );
          }),
        ],
        elevation: 0,
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 40),
                  // height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Consumer(builder: (context, watch, widget) {
                    return Text(
                      appLang[watch(langProvider) as String]![20],
                      style: TextStyle(
                        color: GlobalVariables.isDarkMode() ? AppColors.white : AppColors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    );
                  }),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 40),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      HomeScreenDisplayAds(),
                      const SizedBox(height: 10),
                      Column(
                        children: cardList.map((e) => e).toList(),
                      ),
                      const SizedBox(height: 20),
                      Consumer(builder: ((context, watch, child) {
                        return (watch(phoneNumberProvider) as String != 'none') ? Divider() : SizedBox.shrink();
                      })),
                      Consumer(
                        builder: ((context, watch, child) {
                          return (watch(phoneNumberProvider) as String != 'none') ? PremiumHomeVCFFiles() : SizedBox.shrink();
                        }),
                      ),
                      const SizedBox(height: 20),
                      VerifyAndPlaceAdWidget(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Consumer(builder: (context, watch, widget) {
            return (!(watch(shareAppProvider) as bool) && (UserSharedPreferences.getUserPhoneNumber() != '') && (_premiumPlanStatusController.getPremiumPlanStatus() != 'active'))
                ? Container(
                    color: AppColors.transparentBlack,
                    child: AlertDialog(
                      title: Text(
                        'Share',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: Text('Please click the \'SHARE NOW\' button to share our app link on your WhatsApp status in order to use this app.'),
                      actions: <Widget>[
                        CustomTextButton(
                          text: 'SHARE NOW',
                          onPressed: () async {
                            _shareAppController.setShareApp(true);
                            String _link = "https://wa.me/?text=Hey!!!%20%0A*Have%20you%20been%20Wondering%20the%20strategies%20your%20friends%20are%20using%20to%20boost%20their%20WhatsApp%20views%3F%3F%3F*%0A%0A*Leave%20the%20Wonder%20land%2C%20click%20the%20link%20below%20and%20install%20wassapviews%20app%20to%20find%20out%20their%20secret*%0A%F0%9F%91%87%F0%9F%91%87%F0%9F%91%87%F0%9F%91%87%F0%9F%91%87%0Ahttps%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3Dcom.dartechlabs.wassapviews%0Ahttps%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3Dcom.dartechlabs.wassapviews";
                            if (await canLaunch(_link)) {
                              await launch(_link);
                            } else {
                              throw 'Could not launch $_link';
                            }
                          },
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink();
          }),
          Consumer(builder: (context, watch, widget) {
            return (watch(internetProvider) as bool) ? SizedBox.shrink() : InternetDialog();
          }),
          Consumer(builder: (context, watch, widget) {
            return (watch(loadingDialogProvider) as bool) ? LoadingDialog() : SizedBox.shrink();
          }),
        ],
      ),
      drawer: CustomDrawer(),
      bottomNavigationBar: Consumer(builder: (context, watch, widget) {
        return (watch(premiumPlanStatusProvider) as String == 'active') ? SizedBox.shrink() : BannerAdWidget(size: AdSize.banner);
      }),
    );
  }
}
