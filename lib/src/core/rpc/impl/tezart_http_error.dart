import 'package:dio/dio.dart' as http_client;
import 'package:tezart/src/common/exceptions/common_exception.dart';
import 'package:tezart/src/common/utils/enum_util.dart';
import 'package:tezart/src/core/client/tezart_client.dart';

enum TezartHttpErrorTypes {
  connectTimeout,
  sendTimeout,
  receiveTimeout,
  connectionError,
  badCertificate,
  response,
  cancel,
  unhandled,
}

// Wrapper around DioError
// complete missing methods if needed
class TezartHttpError extends CommonException {
  final http_client.DioException clientError;
  final staticErrorsMessages = {
    TezartHttpErrorTypes.connectTimeout: 'Opening connection timed out',
    TezartHttpErrorTypes.sendTimeout: 'Sending the request timed out',
    TezartHttpErrorTypes.receiveTimeout: 'Receiving connection timed out',
    TezartHttpErrorTypes.connectionError: 'Could not reach the node',
    TezartHttpErrorTypes.badCertificate: 'The node TLS certificate was rejected',
    TezartHttpErrorTypes.response: 'The node returned an error response',
    TezartHttpErrorTypes.cancel: 'The request has been cancelled',
    TezartHttpErrorTypes.unhandled: 'Network Error',
  };
  final errorTypesMapping = {
    http_client.DioExceptionType.connectionTimeout: TezartHttpErrorTypes.connectTimeout,
    http_client.DioExceptionType.sendTimeout: TezartHttpErrorTypes.sendTimeout,
    http_client.DioExceptionType.receiveTimeout: TezartHttpErrorTypes.receiveTimeout,
    http_client.DioExceptionType.connectionError: TezartHttpErrorTypes.connectionError,
    http_client.DioExceptionType.badCertificate: TezartHttpErrorTypes.badCertificate,
    http_client.DioExceptionType.badResponse: TezartHttpErrorTypes.response,
    http_client.DioExceptionType.cancel: TezartHttpErrorTypes.cancel,
  };

  TezartHttpError(this.clientError);

  dynamic get responseBody => _response?.data;
  int? get statusCode => _response?.statusCode;
  TezartHttpErrorTypes get type {
    return errorTypesMapping[clientError.type] ?? TezartHttpErrorTypes.unhandled;
  }

  http_client.Response? get _response => clientError.response;

  @override
  String get key => EnumUtil.enumToString(type);
  @override
  String get message =>
      _response?.statusMessage ??
      staticErrorsMessages[type] ??
      'Network Error (${clientError.type}): ${clientError.error ?? clientError.message}';
  @override
  http_client.DioException get originalException => clientError;
}

Future<T> catchHttpError<T>(Future<T> Function() func, {void Function(TezartHttpError)? onError}) async {
  try {
    return await func();
  } on TezartHttpError catch (e) {
    if (onError != null) onError(e);
    throw TezartNodeError.fromHttpError(e);
  }
}
