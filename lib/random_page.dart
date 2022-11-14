import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:random_app/ad_helper.dart';

class RandomPage extends StatefulWidget {
  const RandomPage({super.key});

  @override
  State<RandomPage> createState() => _RandomPageState();
}

class _RandomPageState extends State<RandomPage> {
  int value = 0;

  //iklan
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    _createBannerAd();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  void _createBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          // print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );
    _bannerAd.load();
  }

  random(int min, int max) {
    return min + Random().nextInt(max - min);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Random App'),
          elevation: 0,
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
                flex: 1,
                child: Container(
                  color: Colors.blue,
                )),
            Expanded(
                flex: 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "$value",
                      style: const TextStyle(
                          fontSize: 50, color: Color.fromARGB(255, 86, 86, 86)),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            value = random(0, 99);
                          });
                        },
                        child: const Text('Random'))
                  ],
                )),
            Expanded(
              flex: 1,
              child: Stack(children: [
                Container(color: Colors.yellow),
                const Center(
                    child: Text(
                  "Loading Ads...",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )),
                if (_isBannerAdReady)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: _bannerAd.size.width.toDouble(),
                      height: _bannerAd.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd),
                    ),
                  ),
              ]),
            )
          ],
        ));
  }
}
