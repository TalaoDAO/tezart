import 'micheline_encoder.dart';

class PairEncoder implements MichelineEncoder {
  @override
  // Might be a Map<String, dynamic> or List<dynamic>
  final dynamic params;
  @override
  final Map<String, dynamic> type;

  PairEncoder({required this.params, required this.type});

  @override
  Map<String, dynamic> encode() {
    return {'prim': 'Pair', 'args': _args};
  }

  List<dynamic> get _args {
    List typeArgs = type['args'];
    final argsIterator = typeArgs.asMap().entries.map((entry) {
      var idx = entry.key;
      dynamic typeArg = entry.value;

      return (MichelineEncoder(
        type: typeArg,
        params: _paramN(idx),
      ).encode());
    });
    return argsIterator.toList();
  }

  int get _argsCount {
    return (type['args'].length);
  }

  dynamic _paramN(int n) {
    if (params is Map) return params;
    if (params is List) {
      var isLastArg = (n == type['args'].length - 1);
      // Handle the case when last arg is i Pair, which arguments are the last elements of the data
      if (isLastArg && params.length > _argsCount) {
        return params.skip(_argsCount - 1).toList();
      } else {
        return params[n];
      }
    }
    throw TypeError();
  }
}
