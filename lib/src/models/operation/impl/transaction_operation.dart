import 'operation.dart';

class TransactionOperation extends Operation {
  TransactionOperation({
    required int super.amount,
    required String super.destination,
    super.params,
    super.entrypoint,
    super.customFee,
    super.customGasLimit,
    super.customStorageLimit,
  }) : super(
          kind: Kinds.transaction,
        );
}
