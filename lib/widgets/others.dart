import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:wassapviews/libraries.dart';
import 'package:wassapviews/utils/methods.dart';

class PremiumHomeVCFFiles extends StatelessWidget {
  const PremiumHomeVCFFiles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            itemCount: 15,
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
                    if (_premiumPlanStatusController.getPremiumPlanStatus() != 'active') {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Join Premium Plan'),
                              content: Text('Join our premium plan to access this file.'),
                              actions: [
                                CustomTextButton(
                                    text: 'Go Premium',
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) {
                                        return GoPremiumScreen();
                                      }));
                                    }),
                                CustomTextButton(
                                    text: 'Watch Ad',
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      LoadingDialogController _controller = context.read(loadingDialogProvider.notifier);
                                      _controller.setLoading(true);
                                      await RewardedAd.load(
                                        adUnitId: 'ca-app-pub-2125815836441893/4988945137',
                                        request: const AdRequest(),
                                        rewardedAdLoadCallback: RewardedAdLoadCallback(
                                          onAdLoaded: (RewardedAd ad) {
                                            _controller.setLoading(false);
                                            ad.show(onUserEarnedReward: (RewardedAd ad, RewardItem item) {
                                              Methods.browserDownloadVCF(context, date2);
                                              ad.dispose();
                                            });
                                          },
                                          onAdFailedToLoad: (LoadAdError error) {
                                            _controller.setLoading(false);
                                            print('Working here');
                                            Methods.browserDownloadVCF(context, date2);
                                            // debugPrint('RewardedAd failed to load: $error');
                                          },
                                        ),
                                      );
                                    }),
                              ],
                            );
                          });
                    } else {
                      Methods.browserDownloadVCF(context, date2);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Theme.of(context).primaryColorDark, width: 1, style: BorderStyle.solid),
                        top: BorderSide(color: Theme.of(context).primaryColorDark, width: 1, style: BorderStyle.solid),
                        right: BorderSide(color: Theme.of(context).primaryColorDark, width: 1, style: BorderStyle.solid),
                        bottom: int == 14 ? BorderSide(color: Theme.of(context).primaryColorDark, width: 1, style: BorderStyle.solid) : BorderSide.none,
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
    );
  }
}

class AppTitleName extends StatelessWidget {
  const AppTitleName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
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
    );
  }
}

class VerifyAndPlaceAdWidget extends StatelessWidget {
  const VerifyAndPlaceAdWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
