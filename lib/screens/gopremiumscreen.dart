import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutterwave/flutterwave.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:wassapviews/libraries.dart';

class GoPremiumScreen extends StatefulWidget {
  bool _loading = true;
  GoPremiumScreen({Key? key}) : super(key: key);

  @override
  _GoPremiumScreenState createState() => _GoPremiumScreenState();
}

class _GoPremiumScreenState extends State<GoPremiumScreen> {
  String _plan = UserSharedPreferences.getPaidPlan()!;
  List<ProductDetails>? productDetails;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  @override
  void initState() {
    super.initState();
    _initializePayment();
  }

  @override
  void dispose() {
    _subscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PhoneNumberController _phoneNumberController = context.read(phoneNumberProvider.notifier);
    if (UserSharedPreferences.getPaidPlan() != 'free') {
      Future.delayed(Duration(milliseconds: 500), () => _activatePremuimPlan());
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
                      appLang[watch(langProvider) as String]![39],
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
                  // height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      Image.asset(
                        'assets/images/trophy.png',
                        height: 100,
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 22.5, right: 22.5),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                spreadRadius: 0,
                                blurRadius: 1,
                                color: GlobalVariables.isDarkMode() ? Colors.transparent : Colors.grey,
                              )
                            ],
                          ),
                          child: Consumer(
                            builder: (context, watch, widget) {
                              return Text(
                                appLang[watch(langProvider) as String]![40],
                                style: TextStyle(
                                  color: Theme.of(context).buttonColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Consumer(builder: (context, watch, widget) {
                        return (watch(premiumPlanStatusProvider) as String) == 'active'
                            ? TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PremiumScreen()));
                                },
                                child: Text(
                                  'Go to Premium Page',
                                  style: TextStyle(
                                    color: Theme.of(context).backgroundColor,
                                  ),
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Theme.of(context).buttonColor),
                                ),
                              )
                            : SizedBox.shrink();
                      }),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Table(
                          border: TableBorder.all(style: BorderStyle.none),
                          children: [
                            TableRow(
                              children: [
                                Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: Text('Features of Premium Plan', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                                Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: Text('FREE', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                                Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: Text('PREMIUM', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                              ],
                            ),
                            TableRow(
                              children: [
                                Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: Text('Submit Contact')),
                                Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: Icon(Icons.check, color: Colors.green, size: 20)),
                                Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: Icon(Icons.check, color: Colors.green, size: 20)),
                              ],
                            ),
                            TableRow(
                              children: [
                                Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: Text('Download Daily VCF')),
                                Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: Icon(Icons.check, color: Colors.green, size: 20)),
                                Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: Icon(Icons.check, color: Colors.green, size: 20)),
                              ],
                            ),
                            TableRow(
                              children: [
                                Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: Text('Remove all Ads')),
                                Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: Icon(Icons.close, color: Colors.red, size: 20)),
                                Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: Icon(Icons.check, color: Colors.green, size: 20)),
                              ],
                            ),
                            TableRow(
                              children: [
                                Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: Text('2K Paginated VCF Files')),
                                Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: Icon(Icons.close, color: Colors.red, size: 20)),
                                Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: Icon(Icons.check, color: Colors.green, size: 20)),
                              ],
                            ),
                            TableRow(
                              children: [
                                Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: Text('Stop asking you to share App')),
                                Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: Icon(Icons.close, color: Colors.red, size: 20)),
                                Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: Icon(Icons.check, color: Colors.green, size: 20)),
                              ],
                            ),
                            TableRow(
                              children: [
                                Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: Text('Access to Complete VCF files')),
                                Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: Icon(Icons.close, color: Colors.red, size: 20)),
                                Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: Icon(Icons.check, color: Colors.green, size: 20)),
                              ],
                            ),
                            TableRow(
                              children: [
                                Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: Text('Sort & Manage Contacts')),
                                Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: Icon(Icons.close, color: Colors.red, size: 20)),
                                Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: Icon(Icons.check, color: Colors.green, size: 20)),
                              ],
                            ),
                            TableRow(
                              children: [
                                Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: Text('Remove outdated contacts')),
                                Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: Icon(Icons.close, color: Colors.red, size: 20)),
                                Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: Icon(Icons.check, color: Colors.green, size: 20)),
                              ],
                            ),
                            TableRow(
                              children: [
                                Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: Text('Delete inactive contacts')),
                                Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: Icon(Icons.close, color: Colors.red, size: 20)),
                                Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: Icon(Icons.check, color: Colors.green, size: 20)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(height: 50),
                      GestureDetector(
                        onTap: () {
                          if (_phoneNumberController.getPhoneNumber() == 'none') {
                            Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => HomeScreen()));
                          } else {
                            PremiumPlanStatusController _premiumPlanStatusController = context.read(premiumPlanStatusProvider.notifier);
                            if (_premiumPlanStatusController.getPremiumPlanStatus() != 'active') {
                              setState(() {
                                _plan = 'monthly';
                              });
                              _buyProduct(0);
                            }
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: GlobalVariables.isDarkMode() ? AppColors.darkModeTransparentGreen : AppColors.lightModeTransparentGreen,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: Theme.of(context).accentColor,
                              width: 2,
                            ),
                          ),
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.width * 0.15,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '₦1,500/Month',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Consumer(
                                  builder: (context, watch, widget) {
                                    return (watch(premiumPlanProvider) as String) == 'monthly'
                                        ? FaIcon(
                                            FontAwesomeIcons.check,
                                            size: 20,
                                          )
                                        : SizedBox.shrink();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(child: Text('OR', style: TextStyle(fontWeight: FontWeight.bold))),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          if (_phoneNumberController.getPhoneNumber() == 'none') {
                            Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => HomeScreen()));
                          } else {
                            PremiumPlanStatusController _premiumPlanStatusController = context.read(premiumPlanStatusProvider.notifier);
                            if (_premiumPlanStatusController.getPremiumPlanStatus() != 'active') {
                              setState(() {
                                _plan = 'yearly';
                              });
                              _buyProduct(1);
                            }
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: GlobalVariables.isDarkMode() ? AppColors.darkModeTransparentGreen : AppColors.lightModeTransparentGreen,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: Theme.of(context).accentColor,
                              width: 2,
                            ),
                          ),
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.width * 0.15,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '₦10,000/Year\n(45% Off)',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Consumer(builder: (context, watch, widget) {
                                  return (watch(premiumPlanProvider) as String) == 'yearly'
                                      ? FaIcon(
                                          FontAwesomeIcons.check,
                                          size: 20,
                                        )
                                      : SizedBox.shrink();
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      Consumer(builder: (context, watch, widget) {
                        return (watch(premiumPlanStatusProvider) as String) == 'active'
                            ? TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PremiumScreen()));
                                },
                                child: Text(
                                  'Go to Premium Page',
                                  style: TextStyle(
                                    color: Theme.of(context).backgroundColor,
                                  ),
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Theme.of(context).buttonColor),
                                ),
                              )
                            : SizedBox.shrink();
                      }),
                      SizedBox(height: 50),
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColorDark,
                            width: 2,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * 0.8,
                        // height: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Opacity(
                                    opacity: 0,
                                    child: Container(
                                      child: Text('Active'),
                                    ),
                                  ),
                                  Consumer(
                                    builder: (context, watch, widget) {
                                      return Text(
                                        appLang[watch(langProvider) as String]![43],
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      );
                                    },
                                  ),
                                  Consumer(builder: (context, watch, widget) {
                                    return (watch(premiumPlanStatusProvider) as String) == 'active'
                                        ? Container(
                                            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                            child: Text('Active', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).accentColor,
                                              borderRadius: BorderRadius.circular(7),
                                            ),
                                          )
                                        : Container(
                                            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                            child: Text('Not Active', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                            decoration: BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius: BorderRadius.circular(7),
                                            ),
                                          );
                                  }),
                                ],
                              ),
                            ),
                            Divider(),
                            SizedBox(height: 20),
                            Consumer(builder: (context, watch, widget) {
                              return Text(
                                'Current number: ${watch(phoneNumberProvider)}',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              );
                            }),
                            SizedBox(height: 5),
                            Consumer(builder: (context, watch, widget) {
                              return Text(
                                'Current plan: ${watch(premiumPlanProvider)}',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              );
                            }),
                            SizedBox(height: 5),
                            Consumer(builder: (context, watch, widget) {
                              return Text(
                                'Valid up to: ${watch(endPlanDateProvider)}',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              );
                            }),
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
            return (watch(phoneNumberProvider) as String) == 'none'
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: AppColors.transparentBlack,
                    child: AlertDialog(
                      title: Text('Can\'t Identify You'),
                      content: Text('Make sure you Submit your contact or Get VCF file first'),
                      actions: [
                        CustomTextButton(
                          text: 'Go Back',
                          onPressed: () {
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
          widget._loading ? LoadingDialog() : SizedBox.shrink(),
        ],
      ),
      bottomNavigationBar: BannerAdWidget(size: AdSize.banner),
    );
  }

  void _initializePayment() async {
    // Connecting to the underlying store
    final bool available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      // The store cannot be reached or accessed. Update the UI accordingly.
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Error'),
          content: Text('The store cannot be reached or accessed.'),
          actions: [
            CustomTextButton(
              text: 'OK',
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription!.cancel();
    }, onError: (error) {
      // handle error here.
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Error'),
          content: Text('An Error Occured.'),
          actions: [
            CustomTextButton(
              text: 'OK',
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }) as StreamSubscription<List<PurchaseDetails>>?;

    // Loading products for sale
    const Set<String> _kIds = <String>{'wassapviews_monthly_plan', 'wassapviews_yearly_plan'};
    final ProductDetailsResponse response = await InAppPurchase.instance.queryProductDetails(_kIds);
    setState(() {
      widget._loading = false;
    });
    if (response.notFoundIDs.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Error'),
          content: Text('An Error Occured.'),
          actions: [
            CustomTextButton(
              text: 'OK',
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    } else {
      productDetails = response.productDetails;
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Show pending results
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Error'),
            content: Text('Transaction cancelled!'),
            actions: [
              CustomTextButton(
                text: 'OK',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Error'),
            content: Text('An Error Occured!'),
            actions: [
              CustomTextButton(
                text: 'OK',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        UserSharedPreferences.setPaidPlan(_plan);
        await InAppPurchase.instance.completePurchase(purchaseDetails).then((value) => _activatePremuimPlan());
      }
    });
  }

  void _buyProduct(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Choose Payment Method'),
            content: Text('Please select your payment method below. If you are in Nigeria it is advisable to pay with Flutterwave.'),
            actions: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomTextButton(
                      text: 'Pay with Flutterwave',
                      onPressed: () {
                        Navigator.pop(context);
                        _makeFlutterwavePayment(index);
                      }),
                  CustomTextButton(
                      text: 'Pay with Google Play',
                      onPressed: () {
                        Navigator.pop(context);
                        final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails![index]);
                        InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
                      }),
                ],
              )
            ],
          );
        });
  }

  void _activatePremuimPlan() async {
    PhoneNumberController _phoneNumberController = context.read(phoneNumberProvider.notifier);
    PremiumPlanController _premiumPlanController = context.read(premiumPlanProvider.notifier);
    EndPlanDateController _endPlanDateController = context.read(endPlanDateProvider.notifier);
    PremiumPlanStatusController _premiumPlanStatusController = context.read(premiumPlanStatusProvider.notifier);
    try {
      setState(() {
        widget._loading = true;
      });
      final _response = await post(
        Uri.parse('https://app.wassapviews.ng/api/activatepremium'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authKey,
        },
        body: jsonEncode(
          {
            'full_number': _phoneNumberController.getPhoneNumber(),
            'plan': _plan,
          },
        ),
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          setState(() {
            widget._loading = false;
          });
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
        setState(() {
          widget._loading = false;
        });
        dynamic _fetchedData = jsonDecode(_response.body);
        if (_fetchedData['status'] == 'success') {
          UserSharedPreferences.setPaidPlan('free');
          _premiumPlanController.setPremiumPlan(_fetchedData['data']['plan']);
          _endPlanDateController.setEndPlanDate(_fetchedData['data']['end']);
          _premiumPlanStatusController.setPremiumPlanStatus('active');
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
        setState(() {
          widget._loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An unexpected error occured'),
            duration: Duration(seconds: 4),
          ),
        );
      }
    } on SocketException {
      setState(() {
        widget._loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occured! Check your internet connection and try again.'),
          duration: Duration(seconds: 4),
        ),
      );
    } catch (e) {
      setState(() {
        widget._loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occured: $e'),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _handlePaymentInitialization(String amount) async {
    setState(() {
      widget._loading = true;
    });
    final flutterwave = Flutterwave.forUIPayment(
      amount: amount,
      currency: 'NGN',
      context: this.context,
      publicKey: 'FLWPUBK_TEST-4f8843e8404bfad8148907a4ebbb7592-X',
      encryptionKey: 'FLWSECK_TEST0bc588a55b6c',
      email: "user@email.com",
      fullName: "Wassapviews App User",
      txRef: DateTime.now().toIso8601String(),
      narration: "Upgrade to Premium",
      isDebugMode: true,
      phoneNumber: UserSharedPreferences.getUserPhoneNumber()!,
      acceptAccountPayment: true,
      acceptCardPayment: true,
      acceptUSSDPayment: true,
      acceptBankTransfer: true,
    );
    final response = await flutterwave.initializeForUiPayments();
    setState(() {
      widget._loading = false;
    });
    if (response != null) {
      if (response.toJson()['data']['status'] == 'successful') {
        UserSharedPreferences.setPaidPlan(_plan);
        _activatePremuimPlan();
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred!'),
            actions: [
              CustomTextButton(
                text: 'OK',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Error'),
          content: Text('Transaction cancelled!'),
          actions: [
            CustomTextButton(
              text: 'OK',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }

  void _makeFlutterwavePayment(int index) {
    String _amount = index == 0 ? '1500' : '10000';
    this._handlePaymentInitialization(_amount);
  }
}
