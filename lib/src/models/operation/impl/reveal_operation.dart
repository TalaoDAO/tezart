import 'package:tezart/tezart.dart';

import 'operation.dart';

class RevealOperation extends Operation {
  RevealOperation({
    super.customFee,
    super.customGasLimit,
    super.customStorageLimit,
  }) : super(
          kind: Kinds.reveal,
        );
}
