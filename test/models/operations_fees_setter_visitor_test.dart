// ignore_for_file: prefer_function_declarations_over_variables

@Timeout(Duration(seconds: 60))
import 'package:mockito/mockito.dart' show Fake;
import 'package:test/test.dart';
import 'package:tezart/src/models/operation/impl/operation_fees_setter_visitor.dart';
import 'package:tezart/tezart.dart';

import '../env/env.dart';
import '../test_utils/test_client.dart';

void main() {
  final tezart = testClient();
  final originatorKeystore = Keystore.fromSecretKey(Env.originatorSk);
  late Operation operation;

  group('when the operation customFee is set', () {
    const customFee = 1234;
    final subject = () => OperationFeesSetterVisitor().visit(operation);

    setUp(() {
      // visit also computes operation.totalFee, which needs the limits, the
      // operations list (forged operation) and the chain's cost_per_byte.
      operation = Operation(kind: Kinds.generic, customFee: customFee)
        ..gasLimit = 1000
        ..storageLimit = 300;
      final operationsList = OperationsList(
        publicKey: originatorKeystore.publicKey,
        rpcInterface: _FakeRpcInterface(),
      )..appendOperation(operation);
      operationsList.result.forgedOperation = '00' * 100;
    });

    test('it sets operation.fee using customFee', () async {
      await subject();
      expect(operation.fee, customFee);
    });
  });

  group('when the operation customFee is not set', () {
    final subject = () => OperationFeesSetterVisitor().visit(operation);

    setUp(() async {
      final destination = Keystore.random();
      final operationsList = await tezart.transferOperation(
        source: originatorKeystore,
        publicKey: originatorKeystore.publicKey,
        destination: destination.address,
        amount: 1000,
      );
      operation = operationsList.operations.last;
      await operationsList.computeCounters();
      await operationsList.computeLimits();
    });

    test('it computes the fees using the operation simulation', () async {
      await subject();
      expect(operation.fee, lessThan(64657));
    });
  });
}

class _FakeRpcInterface extends Fake implements RpcInterface {
  @override
  Future<Map<String, dynamic>> constants([dynamic chain, dynamic level]) async => {'cost_per_byte': '250'};
}
