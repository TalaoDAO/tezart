import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:tezart/src/channel/tezart_js_runtime.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TezartJsRuntime localForge tests', () {
    test('it successfully forges a transaction operation payload', () async {
      final payload = {
        'branch': 'BMHBtAaUv59LipV1czwZ5iQkxEktPJDE7A9sYXPkPeRzbBasNY8',
        'contents': [
          {
            'kind': 'transaction',
            'source': 'tz1QCVQinE8iVj1H2fckqx6oiM85CNJSK9Sx',
            'fee': '1272',
            'counter': '30737',
            'gas_limit': '10400',
            'storage_limit': '0',
            'amount': '1000000',
            'destination': 'tz1QCVQinE8iVj1H2fckqx6oiM85CNJSK9Sx',
          }
        ]
      };

      final data = json.encode(payload);
      final result = await TezartJsRuntime.instance.forge(data);

      expect(result, isNotNull);
      expect(result, isNotEmpty);
      expect(RegExp(r'^[0-9a-fA-F]+$').hasMatch(result!), true);
    });
  });
}