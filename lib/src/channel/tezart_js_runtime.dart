import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_js/flutter_js.dart';

/// Dart-side JavaScript runtime that replaces the native LiquidCore (Android)
/// and JavaScriptCore (iOS) platform channels.
///
/// Uses [flutter_js] which provides QuickJS on Android and JavaScriptCore
/// on iOS, both accessed through dart:ffi — no native plugin code required.
class TezartJsRuntime {
  static TezartJsRuntime? _instance;
  JavascriptRuntime? _jsRuntime;
  bool _initialized = false;

  TezartJsRuntime._();

  /// Singleton instance to avoid creating multiple JS contexts.
  static TezartJsRuntime get instance => _instance ??= TezartJsRuntime._();

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    _jsRuntime = getJavascriptRuntime();
    final jsSource = await rootBundle.loadString(
      "packages/tezart/assets/taquito_local_forging.js",
    );
    _jsRuntime!.evaluate(jsSource);
    _jsRuntime!
        .evaluate("var forger = new taquito_local_forging.LocalForger();");
    _initialized = true;
  }

  /// Forges a Tezos operation using the bundled taquito local forging JS.
  ///
  /// Returns the forged hex string, or `null` on error.
  Future<String?> forge(String operationPayload) async {
    try {
      await _ensureInitialized();
      final jsResult = _jsRuntime!.evaluate(
        "forger.forge(" + operationPayload + ");",
      );
      _jsRuntime!.executePendingJob();
      final result = await _jsRuntime!.handlePromise(jsResult);
      final value = result.stringResult;
      return value.isEmpty ? null : value;
    } catch (_) {
      return null;
    }
  }

  /// Releases the underlying JavaScript runtime resources.
  void dispose() {
    if (_initialized) {
      _jsRuntime?.dispose();
      _jsRuntime = null;
      _initialized = false;
      _instance = null;
    }
  }
}