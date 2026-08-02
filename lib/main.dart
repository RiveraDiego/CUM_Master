import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/ads/ad_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AdService.instance.initialize();
  runApp(const ProviderScope(child: CumMasterApp()));
}
