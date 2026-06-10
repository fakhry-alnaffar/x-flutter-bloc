import 'package:flutter/foundation.dart';
import 'package:x_flutter_bloc/src/bloc/mixins/failure_stream_mixin.dart';
import 'package:x_flutter_bloc/src/bloc/mixins/progress_stream_mixin.dart';
import 'package:x_flutter_core/x_flutter_core.dart';
import 'package:x_flutter_core_models/x_flutter_core_models.dart' hide DataResponse, DataResponseSuccess;

/// Mixin that orchestrates async operations with progress and failure handling.
///
/// Designed to be used with [ProgressStreamMixin] and [FailureStreamMixin].
mixin OperationOrchestrator on ProgressStreamMixin, FailureStreamMixin {
  void _emitFailure(Failure failure, {void Function(Failure)? onError}) {
    (onError ?? emitFailure)(failure);
  }

  /// Processes a [DataResponse] and automatically handles progress and failure streams.
  ///
  /// [operation] is the async call returning [DataResponse].
  /// [onSuccess] is called if the response is successful.
  /// [onError] optional custom error handler. If not provided, it emits to [failureStream].
  /// [enableProgress] whether to show the progress overlay during the operation.
  ///
  /// Returns the original [DataResponse] for further processing if needed.
  Future<DataResponse<T>> performOperation<T>({
    required Future<DataResponse<T>> Function() operation,
    required void Function(T data) onSuccess,
    void Function(Failure failure)? onError,
    bool enableProgress = true,
  }) async {
    try {
      if (enableProgress) {
        startProgress();
      }

      final response = await operation();

      switch (response) {
        case DataResponseSuccess<T>(data: final data):
          onSuccess(data);
        case CanceledRequest<T>():
          break; // intentionally ignored
        default:
          // Covers ApiError, NoInternetConnection, Unauthorized, TooManyRequests,
          // UndefinedError, and any future DataResponse variants.
          _emitFailure(mapResponseToFailure(response), onError: onError);
      }

      return response;
    } catch (e) {
      _emitFailure(const ApiUnknownFailure(), onError: onError);
      rethrow;
    } finally {
      if (enableProgress) {
        await stopProgress();
      }
    }
  }

  /// Alias for [performOperation] to align with Clean Architecture naming conventions.
  Future<DataResponse<T>> performSafeOperation<T>({
    required Future<DataResponse<T>> Function() operation,
    required void Function(T data) onSuccess,
    void Function(Failure failure)? onError,
    bool enableProgress = true,
  }) =>
      performOperation(
        operation: operation,
        onSuccess: onSuccess,
        onError: onError,
        enableProgress: enableProgress,
      );

  /// Maps [DataResponse] errors to [Failure] objects.
  /// Override this to customize error mapping across the Bloc/Cubit.
  @protected
  Failure mapResponseToFailure<T>(DataResponse<T> response) {
    return switch (response) {
      ApiError<T>(error: final error, statusCode: final code) =>
        ApiResponseFailure(statusCode: code ?? 0, message: error.toString()),
      NoInternetConnection<T>() => const ConnectionFailure(),
      Unauthorized<T>() => const ApiUnauthorizedFailure(),
      TooManyRequests<T>() => const ApiTooManyRequestsFailure(),
      UndefinedError<T>(errorObject: final error, statusCode: final code) =>
        ApiUndefinedFailure(message: error.toString(), statusCode: code),
      _ => const ApiUnknownFailure(),
    };
  }
}
