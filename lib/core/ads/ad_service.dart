import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService extends ChangeNotifier {
  AdService._();

  static final instance = AdService._();

  bool _initialized = false;
  bool _canRequestAds = false;
  bool _privacyOptionsRequired = false;

  bool get canRequestAds => _canRequestAds;
  bool get privacyOptionsRequired => _privacyOptionsRequired;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    final update = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      update.complete,
      (_) => update.complete(),
    );
    await update.future;

    final consentForm = Completer<void>();
    ConsentForm.loadAndShowConsentFormIfRequired((_) => consentForm.complete());
    await consentForm.future;
    await _refreshState();
  }

  Future<FormError?> showPrivacyOptions() async {
    final result = Completer<FormError?>();
    ConsentForm.showPrivacyOptionsForm((error) => result.complete(error));
    final error = await result.future;
    await _refreshState();
    return error;
  }

  Future<void> _refreshState() async {
    _canRequestAds = await ConsentInformation.instance.canRequestAds();
    _privacyOptionsRequired =
        await ConsentInformation.instance
            .getPrivacyOptionsRequirementStatus() ==
        PrivacyOptionsRequirementStatus.required;
    if (_canRequestAds) await MobileAds.instance.initialize();
    notifyListeners();
  }
}
