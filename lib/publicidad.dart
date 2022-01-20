import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerLargePublicity extends StatefulWidget {
  @override
  State<BannerLargePublicity> createState() => _BannerLargePublicityState();
}

class _BannerLargePublicityState extends State<BannerLargePublicity> {
  final BannerAdListener listener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );

  final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-6184780932224233/6744302941',
    //adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    size: AdSize.largeBanner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  @override
  void initState() {
    myBanner.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: AdWidget(
        ad: myBanner,
      ),
      width: myBanner.size.width.toDouble(),
      height: myBanner.size.height.toDouble(),
    );
  }
}
