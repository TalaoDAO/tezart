// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$OperationToJson(Operation instance) => <String, dynamic>{
  'kind': Operation._kindToString(instance.kind),
  'destination': ?instance.destination,
  'amount': ?Operation._toString(instance.amount),
  'balance': ?Operation._toString(instance.balance),
  'counter': ?Operation._toString(instance.counter),
  'script': ?instance.script,
  'gas_limit': ?Operation._toString(instance.gasLimit),
  'fee': ?Operation._toString(instance.fee),
  'storage_limit': ?Operation._toString(instance.storageLimit),
  'source': instance.source,
  'parameters': ?instance.parameters,
  'public_key': ?instance.publicKey,
};
