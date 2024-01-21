import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_helper.dart';

class AdBanner extends StatefulWidget {
  // 실제 광고를 띄워주는 위젯을 만드는 부분
  const AdBanner({Key? key}) : super(key: key);

  @override
  _AdBannerState createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  // TODO: Add _bannerAd
  late BannerAd _bannerAd;

  // TODO: Add _isBannerAdReady
  // 우리가 넣을 광고가 준비되었는가?
  bool _isBannerAdReady = false;
  @override
  Widget build(BuildContext context) {
    if (_isBannerAdReady) {
      // 광고가 준비된 경우, container에서 패딩 값만 일정 주고 광고를 넣는다
      return Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: _bannerAd.size.width.toDouble(),
            height: _bannerAd.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  void initState() {
    super.initState();

    // TODO: Initialize _bannerAd
    _bannerAd = BannerAd(
      // 광고 id 기입
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // 광고가 들어간 경우 광고가 준비되었음을 알려준다
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        // 광고가 기입되지 않은 경우 아래 내용을 출력하고 광고가 준비되지 않았음을 알려준다
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
  }

  @override
  void dispose() {
    // TODO: Dispose a BannerAd object
    _bannerAd.dispose();

    super.dispose();
  }
}