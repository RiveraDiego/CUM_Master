import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../core/ads/ad_service.dart';

class MinimalBannerAd extends StatefulWidget {
  const MinimalBannerAd({super.key});

  @override
  State<MinimalBannerAd> createState() => _MinimalBannerAdState();
}

class _MinimalBannerAdState extends State<MinimalBannerAd> {
  static const _testBannerId = 'ca-app-pub-3940256099942544/9214589741';
  static const _bannerId = String.fromEnvironment(
    'ADMOB_BANNER_ID',
    defaultValue: _testBannerId,
  );

  BannerAd? _banner;
  Timer? _retryTimer;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    AdService.instance.addListener(_onAdStateChanged);
    _onAdStateChanged();
  }

  @override
  void dispose() {
    AdService.instance.removeListener(_onAdStateChanged);
    _retryTimer?.cancel();
    _banner?.dispose();
    super.dispose();
  }

  void _onAdStateChanged() {
    if (!AdService.instance.canRequestAds || _banner != null) return;
    final banner = BannerAd(
      adUnitId: _bannerId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          if (!mounted) return;
          setState(() {
            _banner = null;
            _loaded = false;
          });
          _retryTimer?.cancel();
          _retryTimer = Timer(const Duration(seconds: 30), _onAdStateChanged);
        },
      ),
    );
    _banner = banner;
    banner.load();
  }

  @override
  Widget build(BuildContext context) {
    final banner = _banner;
    if (!_loaded || banner == null) return const SizedBox.shrink();
    return SafeArea(
      top: false,
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surface,
        child: Center(
          child: SizedBox(
            width: banner.size.width.toDouble(),
            height: banner.size.height.toDouble(),
            child: AdWidget(ad: banner),
          ),
        ),
      ),
    );
  }
}
