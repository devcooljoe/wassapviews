import 'package:flutter/cupertino.dart';
import 'package:wassapviews/libraries.dart';
import 'package:dio/dio.dart' as dio;

class GetVcfScreen extends StatelessWidget {
  GetVcfScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PhoneNumber _phoneNumber = PhoneNumber(
    dialCode: UserSharedPreferences.getUserDialCode(),
    isoCode: UserSharedPreferences.getUserIsoCode(),
    phoneNumber: UserSharedPreferences.getUserPhoneNumber(),
  );

  bool _validateForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    LoadingDialogController _controller = context.read(loadingDialogProvider.notifier);
    PremiumPlanStatusController _premiumPlanStatusController = context.read(premiumPlanStatusProvider.notifier);
    WatchAdController _watchAdController = context.read(watchAdProvider.notifier);
    if (_premiumPlanStatusController.getPremiumPlanStatus() != 'active' && !GlobalVariables.watchAd) {
      Future.delayed(Duration(milliseconds: 600), () => _watchAdController.setWatchAd(false));
    }
    Future _loadRewardedAd() async {
      _controller.setLoading(true);
      await RewardedAd.load(
        adUnitId: 'ca-app-pub-2125815836441893/4988945137',
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            _controller.setLoading(false);
            ad.show(onUserEarnedReward: (RewardedAd ad, RewardItem item) {
              ad.dispose();
            });
          },
          onAdFailedToLoad: (LoadAdError error) {
            _controller.setLoading(false);
            debugPrint('RewardedAd failed to load: $error');
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Consumer(
          builder: (context, watch, widget) {
            return (watch(premiumPlanStatusProvider) as String) == 'active'
                ? RichText(
                    text: TextSpan(
                      text: 'Premium',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).buttonColor,
                      ),
                      children: <InlineSpan>[
                        TextSpan(
                          text: 'Plan',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        )
                      ],
                    ),
                  )
                : RichText(
                    text: TextSpan(
                      text: 'Wassap',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).buttonColor,
                      ),
                      children: <InlineSpan>[
                        TextSpan(
                          text: 'Views',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        )
                      ],
                    ),
                  );
          },
        ),
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
                bottomLeft: Radius.circular(100.0),
                bottomRight: Radius.circular(5.0),
                topRight: Radius.circular(50.0),
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
                      appLang[watch(langProvider) as String]![35],
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
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: CustomPhoneInput(
                            initialValue: _phoneNumber,
                            onInputChanged: (value) {
                              _phoneNumber = PhoneNumber(
                                dialCode: value.dialCode,
                                isoCode: value.isoCode,
                                phoneNumber: value.phoneNumber,
                              );
                            },
                            onSaved: (value) async {
                              _phoneNumber = PhoneNumber(
                                dialCode: value.dialCode,
                                isoCode: value.isoCode,
                                phoneNumber: value.phoneNumber,
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).accentColor,
                                elevation: 0,
                              ),
                              child: Consumer(builder: (context, watch, widget) {
                                return Text(appLang[watch(langProvider) as String]![30]);
                              }),
                              onPressed: () {
                                _getVcfScreen(context);
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Consumer(builder: (context, watch, widget) {
                            return Text(
                              appLang[watch(langProvider) as String]![37],
                              style: TextStyle(color: Colors.indigo),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Consumer(builder: (context, watch, widget) {
            return (watch(internetProvider) as bool) ? SizedBox.shrink() : InternetDialog();
          }),
          Consumer(builder: (context, watch, widget) {
            return (watch(loadingDialogProvider) as bool) ? LoadingDialog() : SizedBox.shrink();
          }),
          Consumer(builder: (context, watch, widget) {
            return (watch(watchAdProvider) as bool)
                ? SizedBox.shrink()
                : Container(
                    color: Colors.transparent,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: AlertDialog(
                      title: Text('Watch Ad'),
                      content: Text('This app is funded by Ads therefore you need to watch an Ad before proceeding. Click the "Continue" button to proceed'),
                      actions: [
                        CustomTextButton(
                          text: 'Go Back',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        CustomTextButton(
                          text: 'Continue',
                          onPressed: () {
                            _loadRewardedAd();
                            GlobalVariables.watchAd = true;
                            _watchAdController.setWatchAd(true);
                          },
                        ),
                      ],
                    ),
                  );
          })
        ],
      ),
    );
  }

  void _getVcfScreen(BuildContext context) async {
    LoadingDialogController _controller = context.read(loadingDialogProvider.notifier);
    if (_validateForm()) {
      if (UserSharedPreferences.getUserPhoneNumber() == "" || UserSharedPreferences.getUserPhoneNumber() != _phoneNumber.phoneNumber) {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (BuildContext context) => ValidateNumberScreen(
              phoneNumber: _phoneNumber,
            ),
          ),
        );
      } else {
        String _code = _phoneNumber.dialCode!;
        String _inititalNumber = _phoneNumber.phoneNumber!;
        String _number = _inititalNumber.substring(_code.length, _inititalNumber.length);
        try {
          _controller.setLoading(true);
          var _testdir = await Directory('storage/emulated/0/Wassapviews/vcf').create(recursive: true);
          String appDocPath = _testdir.path;

          final _response = await post(
            Uri.parse('https://app.wassapviews.ng/api/getvcf'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': authKey,
            },
            body: jsonEncode(
              {
                'country_code': _code,
                'number': _number,
              },
            ),
          ).timeout(
            const Duration(seconds: 60),
            onTimeout: () {
              _controller.setLoading(false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Connection timeout! Check your internet connection and try again.'),
                  duration: Duration(seconds: 4),
                ),
              );
              return Response('Error', 500);
            },
          );
          if (_response.statusCode == 200 || _response.statusCode == 201) {
            dynamic _fetchedData = jsonDecode(_response.body);
            if (_fetchedData['status'] == 'success') {
              String _downloadPath = _fetchedData['data']['path'];
              String _fileName = _fetchedData['data']['file_name'];

              var _dio = dio.Dio();

              try {
                await _dio.download(_downloadPath, "$appDocPath/$_fileName");
              } catch (e) {
                debugPrint('Error: $e');
              }

              _controller.setLoading(false);
              GlobalVariables.watchAd = false;
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text(
                    'Download Complete',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: const Text('VCF file has downloaded completely. Click the \'Import VCF\' button and click your contact app to open the file. \n Note: Your VCF files can be found in the "Wassapviews" => "vcf" folder of your root storage.'),
                  actions: <Widget>[
                    CustomTextButton(
                      text: 'Import VCF',
                      onPressed: () async {
                        await OpenFile.open("${appDocPath}/${_fileName}");
                        Navigator.pop(context, 'Cancel');
                        if (UserSharedPreferences.getRated() == 'false') {
                          _showCustomDialog(context);
                        }
                      },
                    ),
                  ],
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _fetchedData['message'],
                    style: TextStyle(
                      color: Theme.of(context).buttonColor,
                    ),
                  ),
                  backgroundColor: Theme.of(context).backgroundColor,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.fromLTRB(
                    50,
                    0,
                    50,
                    70,
                  ),
                  duration: const Duration(seconds: 4),
                ),
              );
            } else if (_fetchedData['status'] == 'share') {
              _controller.setLoading(false);
              UserSharedPreferences.setShared('false');
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text(
                    UserSharedPreferences.getShared() == 'true' ? 'Not Available' : 'Share',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Text(UserSharedPreferences.getShared() == 'true' ? 'Come back later for more new VCF files.' : 'Click the \'SHARE NOW\' button to share our app link on your WhatsApp status and in 5 groups.'),
                  actions: <Widget>[
                    UserSharedPreferences.getShared() == 'true'
                        ? SizedBox.shrink()
                        : CustomTextButton(
                            text: 'SHARE NOW',
                            onPressed: () async {
                              UserSharedPreferences.setShared('true');
                              String _link =
                                  "https://wa.me/?text=*THE%20SECRET%20OF%20WHATSAPP%20TVs%20HAS%20BEEN%20REVEALED*%0A%0AAre%20you%20tired%20of%20getting%20low%20Whatsapp%20status%20views%3F%20Follow%20the%20link%20below%20to%20install%20Wassapviews%20app%20in%20order%20to%20gain%202k%2B%20Whatsapp%20status%20views%20for%20free%20with%20just%201%20click%F0%9F%98%B1%F0%9F%98%B1%F0%9F%92%83%F0%9F%92%83%20%0A%20%20%20%20%20%20%20%20%20%20%20%20%20*VISIT*%20%F0%9F%91%87%0A%20%20https%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3Dcom.dartechlabs.wassapviews%0A%20%20https%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3Dcom.dartechlabs.wassapviews";
                              if (await canLaunch(_link)) {
                                await launch(_link);
                              } else {
                                throw 'Could not launch $_link';
                              }
                              await Future.delayed(const Duration(seconds: 10));
                              Navigator.pop(context, 'Cancel');
                            },
                          ),
                  ],
                ),
              );
            } else {
              _controller.setLoading(false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _fetchedData['message'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.fromLTRB(
                    50,
                    0,
                    50,
                    70,
                  ),
                  duration: const Duration(seconds: 4),
                ),
              );
            }
          } else {
            _controller.setLoading(false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('An unexpected error occured. StatusCode: ${_response.statusCode}'),
                duration: const Duration(seconds: 4),
              ),
            );
          }
        } on SocketException {
          _controller.setLoading(false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('An error occured! Check your internet connection and try again.'),
              duration: Duration(seconds: 4),
            ),
          );
        } on PlatformException {
          _controller.setLoading(false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('An error occured! Could not get the downloads directory.'),
              duration: Duration(seconds: 4),
            ),
          );
        } catch (e) {
          _controller.setLoading(false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('An unexpected error occured: $e'),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    }
  }

  void _showCustomDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Join us on Telegram',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text('Please join our official Telegram channel for more info, questions, updates, tutorial, etc.. .'),
        actions: <Widget>[
          CustomTextButton(
            text: 'Join Us',
            onPressed: () async {
              await UserSharedPreferences.setRated('true');
              String url = 'https://t.me/wassapviews';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
              Navigator.pop(context, 'Cancel');
            },
          ),
        ],
      ),
    );
  }
}
