import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:onix_flutter_bloc/src/bloc/stream_listener.dart';
import 'package:onix_flutter_core_models/onix_flutter_core_models.dart';

/// Mixin to provide common UI stream listening logic (Failure, SR, Progress).
mixin BaseUiStateMixin<W extends StatefulWidget, SR> on State<W> {
  /// Called when a failure is emitted.
  void onFailure(BuildContext context, Failure failure) {}

  /// Called when a single result is emitted.
  void onSR(BuildContext context, SR sr) {}

  /// Called when progress state changes.
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

  /// Wraps [child] with listeners for [failureStream], [singleResults], and [progressStream].
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
