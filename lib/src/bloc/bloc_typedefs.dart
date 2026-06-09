import 'package:flutter/material.dart';

/// Delegate for listening to state changes.
typedef ListenDelegate<S> = void Function(BuildContext context, S state);

/// Builder for state widgets.
typedef StateListener<S> = Widget Function(S state);

/// Listener for Single Results.
typedef SingleResultListener<SR> = void Function(
  BuildContext context,
  SR singleResult,
);

/// Protocol for providing a stream of events [SingleResult]
abstract interface class SingleResultProvider<SingleResult> {
  /// Stream of single results.
  Stream<SingleResult> get singleResults;
}

/// Protocol for receiving events [SingleResult]
abstract interface class SingleResultEmitter<SingleResult> {
  /// Emits a single result.
  void addSr(SingleResult sr);
}
