import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:wassapviews/libraries.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  static GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  dynamic getads(BuildContext context) async {
    var response = await get(
      Uri.parse('https://app.wassapviews.ng/api/getads'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authKey,
      },
    ).timeout(Duration(seconds: 120), onTimeout: () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occured while fetching ads.'),
        ),
      );
      return Response('Error', 500);
    });
    return response.body;
  }

  Future _getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      // await FlutterContacts.requestPermission();
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

  void browserDownloadVCF(BuildContext context, String date) async {
    LoadingDialogController _controller = context.read(loadingDialogProvider.notifier);
    try {
      _controller.setLoading(true);

      final _response = await get(
        Uri.parse('https://app.wassapviews.ng/api/getsinglevcf/$date'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authKey,
        },
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

          _controller.setLoading(false);
          GlobalVariables.watchAd = false;
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text(
                'Download VCF',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: const Text('VCF file has been requested completely. Click the \'Download VCF\' button to open your browser and download the VCF file.'),
              actions: <Widget>[
                CustomTextButton(
                  text: 'Download VCF',
                  onPressed: () async {
                    if (await canLaunch(_downloadPath)) {
                      await launch(_downloadPath);
                    } else {
                      throw 'Could not launch $_downloadPath';
                    }
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
                          String _link = "https://wa.me/?text=*THE%20SECRET%20OF%20WHATSAPP%20TVs%20HAS%20BEEN%20REVEALED*%0A%0AAre%20you%20tired%20of%20getting%20low%20Whatsapp%20status%20views%3F%20Follow%20the%20link%20below%20to%20install%20Wassapviews%20app%20in%20order%20to%20gain%202k%2B%20Whatsapp%20status%20views%20for%20free%20with%20just%201%20click%F0%9F%98%B1%F0%9F%98%B1%F0%9F%92%83%F0%9F%92%83%20%0A%20%20%20%20%20%20%20%20%20%20%20%20%20*VISIT*%20%F0%9F%91%87%0A%20%20https%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3Dcom.dartechlabs.wassapviews%0A%20%20https%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3Dcom.dartechlabs.wassapviews";
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
    } on FileSystemException {
      _controller.setLoading(false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Storage permission not granted by device. Please use another device.'),
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
      if (pageController.hasClients) {
        pageController.animateToPage(initpage, duration: const Duration(milliseconds: 500), curve: Curves.ease);
      }
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
      Future.delayed(Duration(milliseconds: 1000), () => GlobalVariables.loadInterstitialAd());
      Timer.periodic(Duration(seconds: 60), (Timer t) => GlobalVariables.loadInterstitialAd());
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
                        future: getads(context),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Container(
                              padding: EdgeInsets.all(4),
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: Image.asset('assets/images/phone.png'),
                            );
                          } else if (snapshot.hasError) {
                            return Container(
                              padding: EdgeInsets.all(4),
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: Text('Failed to load Images.'),
                            );
                          } else {
                            try {
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
                                          child: CachedNetworkImage(
                                            imageUrl: data[index]['image']!,
                                            placeholder: (context, str) {
                                              return Padding(
                                                padding: EdgeInsets.all(100),
                                                child: CircularProgressIndicator(color: Theme.of(context).accentColor),
                                              );
                                            },
                                          ),
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
                            } catch (e) {
                              return Container(
                                padding: EdgeInsets.all(4),
                                height: MediaQuery.of(context).size.height * 0.4,
                                child: Text('Failed to load Images.'),
                              );
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: cardList.map((e) => e).toList(),
                      ),
                      const SizedBox(height: 20),
                      Divider(),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                FaIcon(FontAwesomeIcons.list, size: 28),
                                SizedBox(width: 15),
                                Text(
                                  'Download List',
                                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 15),
                                Text(
                                  '~PRO',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: GlobalVariables.isDarkMode() ? Colors.yellow : Colors.yellow.shade900),
                                )
                              ],
                            ),
                            Text(
                              'Here is a list of previously compiled vCards files for premium users to download.',
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Theme.of(context).shadowColor),
                            ),
                            SizedBox(height: 30),
                            ListView.builder(
                              itemCount: 10,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, int) {
                                final DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - (int + 1));
                                final DateFormat formatter = DateFormat('d MMM, y');
                                String date = formatter.format(now);
                                String year = now.year.toString();
                                String month = now.month.toString().padLeft(2, '0');
                                String day = now.day.toString().padLeft(2, '0');
                                String date2 = '$year-$month-$day';
                                return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () async {
                                      PremiumPlanStatusController _premiumPlanStatusController = context.read(premiumPlanStatusProvider.notifier);
                                      if (_premiumPlanStatusController.getPremiumPlanStatus() == 'active') {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Join Premium Plan'),
                                                content: Text('Join our premium plan to access this file.'),
                                                actions: [
                                                  CustomTextButton(
                                                      text: 'OK',
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) {
                                                          return GoPremiumScreen();
                                                        }));
                                                      }),
                                                ],
                                              );
                                            });
                                      } else {
                                        browserDownloadVCF(context, date2);
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          left: BorderSide(color: Theme.of(context).primaryColorDark, width: 1, style: BorderStyle.solid),
                                          top: BorderSide(color: Theme.of(context).primaryColorDark, width: 1, style: BorderStyle.solid),
                                          right: BorderSide(color: Theme.of(context).primaryColorDark, width: 1, style: BorderStyle.solid),
                                          bottom: int == 9 ? BorderSide(color: Theme.of(context).primaryColorDark, width: 1, style: BorderStyle.solid) : BorderSide.none,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          FaIcon(FontAwesomeIcons.addressCard, size: 21, color: Theme.of(context).accentColor),
                                          SizedBox(width: 10),
                                          Text(
                                            'vCard for $date',
                                            style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500, color: Theme.of(context).accentColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                String _l = "https://wassapviews.ng/tv/signup";
                                if (await canLaunch(_l)) {
                                  await launch(_l);
                                } else {
                                  throw 'Could not launch $_l';
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width * 0.6,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).accentColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'VERIFY & PLACE YOUR \n WHATSAPP TV ON WASSAPVIEWS \n ₦5,000/Month',
                                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '✔ Gain the trust of your customers.',
                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Theme.of(context).shadowColor),
                                  ),
                                  Text(
                                    '✔ Get our users to trust you.',
                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Theme.of(context).shadowColor),
                                  ),
                                  Text(
                                    '✔ Boost your sale 100% assured.',
                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Theme.of(context).shadowColor),
                                  ),
                                  Text(
                                    '✔ Get your personal WhatsApp TV link on Wassapviews.',
                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Theme.of(context).shadowColor),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'NOTE:',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).shadowColor),
                                  ),
                                  Text(
                                    '• You must be a trusted Tv therefore you must upload a non-edited and raw video proof of your Status Views Count.',
                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Theme.of(context).shadowColor),
                                  ),
                                  Text(
                                    '• You will also be tested before you will be approved.',
                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Theme.of(context).shadowColor),
                                  ),
                                  Text(
                                    '• There is no refund.',
                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Theme.of(context).shadowColor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
                            String _link = "https://wa.me/?text=*THE%20SECRET%20OF%20WHATSAPP%20TVs%20HAS%20BEEN%20REVEALED*%0A%0AAre%20you%20tired%20of%20getting%20low%20Whatsapp%20status%20views%3F%20Follow%20the%20link%20below%20to%20install%20Wassapviews%20app%20in%20order%20to%20gain%202k%2B%20Whatsapp%20status%20views%20for%20free%20with%20just%201%20click%F0%9F%98%B1%F0%9F%98%B1%F0%9F%92%83%F0%9F%92%83%20%0A%20%20%20%20%20%20%20%20%20%20%20%20%20*VISIT*%20%F0%9F%91%87%0A%20%20https%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3Dcom.dartechlabs.wassapviews%0A%20%20https%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3Dcom.dartechlabs.wassapviews";
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
