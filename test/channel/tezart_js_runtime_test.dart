import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:tezart/src/channel/tezart_platform_interface.dart';
import 'package:tezart/src/channel/tezart_js_runtime.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TezartJsRuntime localForge tests', () {
    test('it successfully forges a transaction operation payload', () async {
      final payload = {
        'branch': 'BLockGenesisGenesisGenesisGenesisGenesisf3b2d1',
        'contents': [
          {
            'kind': 'transaction',
            'source': 'tz1edmE1ZtizUW2qRj5XA2BLuiR8pRDnoBRg',
            'fee': '1272',
            'counter': '30737',
            'gas_limit': '10400',
            'storage_limit': '0',
            'amount': '1000000',
            'destination': 'tz1gja25C6w7C1XFLwjhcX1Cg8Q2zpv5wJGG',
          }
        ]
      };

      final data = json.encode(payload);
      final result = await TezartJsRuntime.instance.forge(data);

      expect(result, isNotNull);
      expect(result, isNotEmpty);
      expect(RegExp(r'^[0-9a-fA-F]+$').hasMatch(result!), true);
      print('Local forge output hex: ');
    });
  });
}
