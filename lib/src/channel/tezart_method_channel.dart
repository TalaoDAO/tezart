import "tezart_platform_interface.dart";
import "tezart_js_runtime.dart";

/// An implementation of [TezartPlatform] that uses [TezartJsRuntime]
/// (flutter_js) to execute JavaScript locally instead of a MethodChannel.
class MethodChannelTezart extends TezartPlatform {
  @override
  Future<String?> localForge(String operation) async {
    try {
      return await TezartJsRuntime.instance.forge(operation);
    } catch (_) {
      return null;
    }
  }
}
