import 'package:cum_master/core/release/app_release.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('exposes the public semantic version and code name', () {
    expect(AppRelease.number, '1.0.1');
    expect(AppRelease.codeName, 'Nuegado Guardián');
    expect(AppRelease.label, 'Versión 1.0.1 · Nuegado Guardián');
  });
}
