import 'package:flutter/cupertino.dart';
import 'package:wassapviews/libraries.dart';

class Methods extends StatelessWidget {
  const Methods({Key? key}) : super(key: key);
  static GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  static void browserDownloadVCF(BuildContext context, String date) async {
    LoadingDialogController _controller = context.read(loadingDialogProvider.notifier);
    String _code = UserSharedPreferences.getUserDialCode()!;
    String _inititalNumber = UserSharedPreferences.getUserPhoneNumber()!;
    String _number = _inititalNumber.substring(_code.length, _inititalNumber.length);
    try {
      _controller.setLoading(true);

      final _response = await post(
        Uri.parse('https://app.wassapviews.ng/api/getsinglevcf'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authKey,
        },
        body: jsonEncode(
          {
            'country_code': _code,
            'number': _number,
            'date': date,
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
                      Methods.showCustomDialog(context);
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
                          String _link = "https://wa.me/?text=Hey!!!%20%0A*Have%20you%20been%20Wondering%20the%20strategies%20your%20friends%20are%20using%20to%20boost%20their%20WhatsApp%20views%3F%3F%3F*%0A%0A*Leave%20the%20Wonder%20land%2C%20click%20the%20link%20below%20and%20install%20wassapviews%20app%20to%20find%20out%20their%20secret*%0A%F0%9F%91%87%F0%9F%91%87%F0%9F%91%87%F0%9F%91%87%F0%9F%91%87%0Ahttps%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3Dcom.dartechlabs.wassapviews%0Ahttps%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3Dcom.dartechlabs.wassapviews";
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
        } else if (_fetchedData['status'] == 'submit') {
          _controller.setLoading(false);
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text(
                'Submit your Contact First',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text('You have not submitted your number. Tap the submit contact button below to submit your contact.'),
              actions: <Widget>[
                CustomTextButton(
                    text: 'Submit Contact',
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) {
                        return SubmitContactScreen();
                      }));
                    }),
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

  static Future<void> checkForUpdate() async {
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

  static void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(text)));
    }
  }

  static void showCustomDialog(BuildContext context) {
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

  static Future getStoragePermission() async {
    var permission = await Permission.storage.request();
    if (permission.isGranted) {
      // await FlutterContacts.requestPermission();
      return true;
    } else if (permission.isPermanentlyDenied) {
      await openAppSettings();
    } else if (permission.isDenied) {
      return false;
    }
  }

  static dynamic getads(BuildContext context) async {
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

  static void fetchContactCount(BuildContext context) async {
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

  static void checkPremiumPlanStatus(BuildContext context) async {
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

  // static void _deleteInactiveContacts(BuildContext context) async {
  //   LoadingDialogController _controller = context.read(loadingDialogProvider.notifier);
  //   if (await FlutterContacts.requestPermission()*/) {
  //     try {
  //       String _code = UserSharedPreferences.getUserDialCode()!;
  //       String _inititalNumber = UserSharedPreferences.getUserPhoneNumber()!;
  //       String _number = _inititalNumber.substring(_code.length, _inititalNumber.length);

  //       _controller.setLoading(true);
  //       final _response = await post(
  //         Uri.parse('https://app.wassapviews.ng/api/fetchoutdated'),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json',
  //           'Authorization': authKey,
  //         },
  //         body: jsonEncode(
  //           {
  //             'country_code': _code,
  //             'number': _number,
  //           },
  //         ),
  //       ).timeout(
  //         const Duration(seconds: 60),
  //         onTimeout: () {
  //           _controller.setLoading(false);
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(
  //               content: Text('Connection timeout! Check your internet connection and try again.'),
  //               duration: Duration(seconds: 4),
  //             ),
  //           );
  //           return Response('Error', 500);
  //         },
  //       );
  //       if (_response.statusCode == 200 || _response.statusCode == 201) {
  //         dynamic _fetchedData = jsonDecode(_response.body);
  //         if (_fetchedData['status'] == 'success') {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //               content: Text(
  //                 'Deleting inactive & outdated contacts',
  //               ),
  //               backgroundColor: Theme.of(context).backgroundColor,
  //               behavior: SnackBarBehavior.floating,
  //               margin: const EdgeInsets.fromLTRB(
  //                 50,
  //                 0,
  //                 50,
  //                 70,
  //               ),
  //               duration: const Duration(seconds: 4),
  //             ),
  //           );
  //           List _data = _fetchedData['data'];
  //           _data.forEach((element) async {
  //             Contact? contact = await FlutterContacts.getContact(element.toString());
  //             if (contact != null && (contact.displayName).contains(' WV')) {
  //               await contact.delete();
  //             }
  //           });
  //           _controller.setLoading(false);
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //               content: Text(
  //                 'Contacts updated successfully.',
  //               ),
  //               backgroundColor: Theme.of(context).backgroundColor,
  //               behavior: SnackBarBehavior.floating,
  //               margin: const EdgeInsets.fromLTRB(
  //                 50,
  //                 0,
  //                 50,
  //                 70,
  //               ),
  //               duration: const Duration(seconds: 4),
  //             ),
  //           );
  //         } else {
  //           _controller.setLoading(false);
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //               content: Text(
  //                 _fetchedData['message'],
  //                 style: const TextStyle(color: Colors.white),
  //               ),
  //               backgroundColor: Colors.red,
  //               behavior: SnackBarBehavior.floating,
  //               margin: const EdgeInsets.fromLTRB(
  //                 50,
  //                 0,
  //                 50,
  //                 70,
  //               ),
  //               duration: const Duration(seconds: 4),
  //             ),
  //           );
  //         }
  //       } else {
  //         _controller.setLoading(false);
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text('An unexpected error occured'),
  //             duration: Duration(seconds: 4),
  //           ),
  //         );
  //       }
  //     } on SocketException {
  //       _controller.setLoading(false);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('An error occured! Check your internet connection and try again.'),
  //           duration: Duration(seconds: 4),
  //         ),
  //       );
  //     } catch (e) {
  //       _controller.setLoading(false);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('An unexpected error occured: $e'),
  //           duration: const Duration(seconds: 4),
  //         ),
  //       );
  //     }
  //   }
  // }

}
