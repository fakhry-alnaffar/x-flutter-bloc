import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:x_flutter_bloc/src/bloc/stream_listener.dart';
import 'package:x_flutter_core_models/x_flutter_core_models.dart';

/// A UI-layer mixin that orchestrates the consumption of infrastructure streams.
///
/// Designed to be used within [State] classes to handle Failures,
/// Progress (Loading), and Single Results (One-time events) automatically.
mixin BaseUiStateMixin<W extends StatefulWidget, SR> on State<W> {
  /// Callback triggered when the BLoC emits a [Failure].
  /// Override this to show snackbars, dialogs, or perform error-specific logic.
  void onFailure(BuildContext context, Failure failure) {}

  /// Callback triggered when the BLoC emits a Single Result [SR].
  /// Typically used for Navigation, Toast, or triggering animations.
  void onSR(BuildContext context, SR sr) {}

  /// Callback triggered when the progress state changes.
  /// The default implementation toggles the [loader_overlay].
  void onProgress(BuildContext context, BaseProgressState progress) {
    if (!mounted) return;

    if (progress is DefaultProgressState) {
      if (progress.showProgress) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }
    }
  }

  /// Orchestrates the listeners for all infrastructure streams.
  ///
  /// This should be called within the [build] method of your [State] class.
  Widget buildUiStreams({
    required Stream<Failure> failureStream,
    required Stream<SR> singleResults,
    required Stream<BaseProgressState> progressStream,
    required Widget child,
  }) {
    return StreamListener<Failure>(
      stream: failureStream,
      onData: (failure) => onFailure(context, failure),
      child: StreamListener<SR>(
        stream: singleResults,
        onData: (sr) => onSR(context, sr),
        child: StreamListener<BaseProgressState>(
          stream: progressStream,
          onData: (progress) => onProgress(context, progress),
          child: child,
        ),
      ),
    );
  }
}
