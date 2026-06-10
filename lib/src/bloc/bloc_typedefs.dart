import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_flutter_core_models/x_flutter_core_models.dart';

/// Delegate for listening to state changes.
typedef ListenDelegate<S> = void Function(BuildContext context, S state);

/// Listener for Single Results (Navigation, Toasts, etc).
typedef SingleResultListener<SR> = void Function(
  BuildContext context,
  SR singleResult,
);

/// Protocol for providing a stream of failures.
abstract interface class FailureStreamProvider {
  /// Stream of domain or API failures.
  Stream<Failure> get failureStream;
}

/// Protocol for providing a stream of progress states (Loading).
abstract interface class ProgressStreamProvider {
  /// Stream of progress/loading states.
  Stream<BaseProgressState> get progressStream;
}

/// Protocol for providing a stream of one-time events [SingleResult].
abstract interface class SingleResultProvider<SingleResult> {
  /// Stream of single results.
  Stream<SingleResult> get singleResults;
}

/// Protocol for emitting one-time events [SingleResult].
abstract interface class SingleResultEmitter<SingleResult> {
  /// Emits a single result.
  void addSr(SingleResult sr);
}

/// The ultimate interface for Blocs/Cubits in the X ecosystem.
///
/// Combines state management with progress, failure, and single result streams.
abstract interface class IBaseBloc<S, SR>
    implements
        StateStreamableSource<S>,
        FailureStreamProvider,
        ProgressStreamProvider,
        SingleResultProvider<SR> {}
