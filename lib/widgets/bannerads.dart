import 'package:wassapviews/libraries.dart';

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
