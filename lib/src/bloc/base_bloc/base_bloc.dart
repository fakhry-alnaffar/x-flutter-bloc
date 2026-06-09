import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onix_flutter_bloc/src/bloc/mixins/failure_stream_mixin.dart';
import 'package:onix_flutter_bloc/src/bloc/mixins/progress_stream_mixin.dart';
import 'package:onix_flutter_bloc/src/bloc/mixins/single_result_mixin.dart';
import 'package:onix_flutter_core/onix_flutter_core.dart';
import 'package:onix_flutter_core_models/onix_flutter_core_models.dart';

/// Base class for all BLoCs in the system.
///
/// Features:
/// - Single Result support (Navigation, Toasts, etc.)
/// - Progress Stream (Loading overlays)
/// - Failure Stream (Error handling)
/// - Integrated [DataResponse] processing
abstract class BaseBloc<Event, State, SR> extends Bloc<Event, State>
    with SingleResultMixin<State, SR>, ProgressStreamMixin, FailureStreamMixin {
  BaseBloc(super.initialState);

  /// Unified failure handler (safe + clean)
  void _emitFailure(
    Failure failure, {
    void Function(Failure)? onError,
  }) {
    if (onError != null) {
      onError(failure);
    } else {
      onFailure(failure);
    }
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
          // intentionally ignored
          break;
        case ApiError<T>() ||
              NoInternetConnection<T>() ||
              Unauthorized<T>() ||
              TooManyRequests<T>() ||
              UndefinedError<T>():
          final failure = mapResponseToFailure(response);
          _emitFailure(failure, onError: onError);
      }

      return response;
    } finally {
      if (enableProgress) {
        await stopProgress();
      }
    }
  }

  /// Maps [DataResponse] errors to [Failure] objects.
  /// Override this to customize error mapping across the Bloc.
  @protected
  Failure mapResponseToFailure<T>(DataResponse<T> response) {
    return switch (response) {
      ApiError<T>(error: final error, statusCode: final code) =>
        ApiResponseFailure(
          statusCode: code ?? 0,
          message: error.toString(),
        ),
      NoInternetConnection<T>() => const ConnectionFailure(),
      Unauthorized<T>() => const ApiUnauthorizedFailure(),
      TooManyRequests<T>() => const ApiTooManyRequestsFailure(),
      UndefinedError<T>(errorObject: final error, statusCode: final code) =>
        ApiUndefinedFailure(
          message: error.toString(),
          statusCode: code,
        ),
      _ => const ApiUnknownFailure(),
    };
  }

  @override
  Future<void> close() {
    closeProgressStream();
    closeFailureStream();
    return super.close();
  }
}
