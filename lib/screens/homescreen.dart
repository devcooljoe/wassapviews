import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:wassapviews/libraries.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  static GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  dynamic getads() async {
    var response = await get(
      Uri.parse('https://app.wassapviews.ng/api/getads'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authKey,
      },
    );
    return response.body;
  }

  Future _getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      await FlutterContacts.requestPermission();
      return true;
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      return false;
    }
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        InAppUpdate.startFlexibleUpdate().then((_) {
          InAppUpdate.completeFlexibleUpdate().then((_) {
            showSnack("App Updated Successfully!");
          }).catchError((e) {
            showSnack(e.toString());
          });
        }).catchError((e) {
          showSnack(e.toString());
        });
      }
    }).catchError((e) {
      showSnack(e.toString());
    });
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(text)));
    }
  }

  @override
  Widget build(BuildContext context) {
    int initpage = 0;
    int itemcount = 2;
    PageController pageController = PageController(initialPage: 0);

    void setOnboardPage(BuildContext context) {
      initpage++;
      if (initpage >= itemcount) {
        initpage = 0;
      }
      pageController.animateToPage(initpage, duration: const Duration(milliseconds: 500), curve: Curves.ease);
    }

    Timer.periodic(Duration(seconds: 5), (Timer t) => setOnboardPage(context));

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
      Future.delayed(Duration(milliseconds: 500), () => GlobalVariables.loadInterstitialAd());
      Timer.periodic(Duration(seconds: 30), (Timer t) => GlobalVariables.loadInterstitialAd());
    }
    if (appJustLoaded) {
      Future.delayed(Duration(seconds: 1), () => fetchContactCount(context));
      Future.delayed(Duration(seconds: 1), () => checkPremiumPlanStatus(context));
      Future.delayed(Duration(seconds: 1), () => checkForUpdate());
      Future.delayed(Duration(seconds: 1), () => _getStoragePermission());
    }

    appJustLoaded = false;
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
                      FutureBuilder(
                        future: getads(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Container(
                              padding: EdgeInsets.all(4),
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: Image.asset('assets/images/phone.png'),
                            );
                          } else {
                            List<dynamic> data = jsonDecode(snapshot.data.toString())['data'];
                            itemcount = data.length;
                            return Column(
                              children: <Widget>[
                                Text('Sponsored Ads', style: TextStyle(fontWeight: FontWeight.bold)),
                                Container(
                                  padding: EdgeInsets.all(4),
                                  height: MediaQuery.of(context).size.height * 0.4,
                                  child: PageView.builder(
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        child: CachedNetworkImage(imageUrl: data[index]['image']!),
                                        onTap: () async {
                                          String url = data[index]['link'];
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                      );
                                    },
                                    itemCount: data.length,
                                    controller: pageController,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SmoothPageIndicator(
                                  controller: pageController,
                                  count: data.length,
                                  effect: WormEffect(
                                    dotHeight: 5,
                                    dotWidth: 5,
                                    dotColor: GlobalVariables.isDarkMode() ? AppColors.grey4 : AppColors.grey2,
                                    activeDotColor: Theme.of(context).accentColor,
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: cardList.map((e) => e).toList(),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Consumer(builder: (context, watch, widget) {
            return (watch(shareAppProvider) as bool && UserSharedPreferences.getUserPhoneNumber() != '')
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
                            String _link =
                                "https://wa.me/?text=*THE%20SECRET%20OF%20WHATSAPP%20TVs%20HAS%20BEEN%20REVEALED*%0A%0AAre%20you%20tired%20of%20getting%20low%20Whatsapp%20status%20views%3F%20Follow%20the%20link%20below%20to%20install%20Wassapviews%20app%20in%20order%20to%20gain%202k%2B%20Whatsapp%20status%20views%20for%20free%20with%20just%201%20click%F0%9F%98%B1%F0%9F%98%B1%F0%9F%92%83%F0%9F%92%83%20%0A%20%20%20%20%20%20%20%20%20%20%20%20%20*VISIT*%20%F0%9F%91%87%0A%20%20https%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3Dcom.dartechlabs.wassapviews%0A%20%20https%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3Dcom.dartechlabs.wassapviews";
                            if (await canLaunch(_link)) {
                              await launch(_link);
                            } else {
                              throw 'Could not launch $_link';
                            }
                            await Future.delayed(const Duration(seconds: 10));
                            Navigator.pop(context);
                            Navigator.pop(context);
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
        ],
      ),
      drawer: CustomDrawer(),
      bottomNavigationBar: BannerAdWidget(size: AdSize.banner),
    );
  }
}

void fetchContactCount(BuildContext context) async {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Updating contacts...',
        style: TextStyle(color: Theme.of(context).buttonColor),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      duration: const Duration(seconds: 4),
    ),
  );
  try {
    final _response = await post(
      Uri.parse('https://app.wassapviews.ng/api/getcount'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authKey,
      },
    ).timeout(
      const Duration(seconds: 60),
      onTimeout: () {
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
        String _count = _fetchedData['data']['count'].toString();
        ContactCountController _controller = context.read(contactCountProvider.notifier);
        _controller.setCount(_count);
        await UserSharedPreferences.setContactCount(_count);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Contacts updated successfully!',
              style: TextStyle(color: Theme.of(context).buttonColor),
            ),
            backgroundColor: Theme.of(context).backgroundColor,
            duration: const Duration(seconds: 4),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_fetchedData['message']),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  } on SocketException {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('An error occured! Check your internet connection and try again.'),
        duration: Duration(seconds: 4),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('An unexpected error occured: $e'),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}

void checkPremiumPlanStatus(BuildContext context) async {
  PhoneNumberController _phoneNumberController = context.read(phoneNumberProvider.notifier);
  PremiumPlanController _premiumPlanController = context.read(premiumPlanProvider.notifier);
  EndPlanDateController _endPlanDateController = context.read(endPlanDateProvider.notifier);
  PremiumPlanStatusController _premiumPlanStatusController = context.read(premiumPlanStatusProvider.notifier);
  try {
    final _response = await post(
      Uri.parse('https://app.wassapviews.ng/api/getpremiumstatus'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authKey,
      },
      body: jsonEncode(
        {
          'full_number': _phoneNumberController.getPhoneNumber(),
        },
      ),
    ).timeout(
      const Duration(seconds: 60),
      onTimeout: () {
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
        _premiumPlanStatusController.setPremiumPlanStatus(_fetchedData['data']['status']);
        _premiumPlanController.setPremiumPlan(_fetchedData['data']['plan']);
        _endPlanDateController.setEndPlanDate(_fetchedData['data']['end']);
      } else {
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An unexpected error occured'),
          duration: Duration(seconds: 4),
        ),
      );
    }
  } on SocketException {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('An error occured! Check your internet connection and try again.'),
        duration: Duration(seconds: 4),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('An unexpected error occured: $e'),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
