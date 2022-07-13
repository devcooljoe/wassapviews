import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:wassapviews/libraries.dart';
import 'package:wassapviews/utils/methods.dart';

class BannerAdWidget extends StatefulWidget {
  AdSize size;
  BannerAdWidget({Key? key, required this.size}) : super(key: key);
  bool isAdLoaded = false;
  late BannerAd? banner = null;

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  Future<void> loadBannerAd(AdSize size) async {
    BannerAd banner = BannerAd(
      request: const AdRequest(),
      size: size,
      adUnitId: 'ca-app-pub-2125815836441893/6775990902',
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            widget.isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError loadError) {
          setState(() {
            widget.isAdLoaded = false;
          });
          ad.dispose();
        },
      ),
    );
    await banner.load();
    setState(() {
      widget.banner = banner;
    });
  }

  @override
  void initState() {
    super.initState();
    loadBannerAd(widget.size);
  }

  @override
  Widget build(BuildContext context) {
    return widget.isAdLoaded
        ? Container(
            height: widget.banner!.size.height.toDouble(),
            width: widget.banner!.size.width.toDouble(),
            child: AdWidget(ad: widget.banner!),
          )
        : SizedBox.shrink();
  }
}

class HomeScreenDisplayAds extends StatelessWidget {
  HomeScreenDisplayAds({Key? key}) : super(key: key);

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

    return FutureBuilder(
      future: Methods.getads(context),
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
    );
  }
}
