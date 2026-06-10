import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:x_flutter_bloc/x_flutter_bloc.dart';
import 'package:x_flutter_core_models/x_flutter_core_models.dart';

/// Mixin to add progress tracking capabilities to a BLoC or Cubit.
///
/// Supports reference counting to prevent premature hiding of the progress
/// indicator when multiple operations are running concurrently.
mixin class ProgressStreamMixin implements ProgressStreamProvider {
  final StreamController<BaseProgressState> _progressStreamController =
      StreamController<BaseProgressState>.broadcast(sync: true);

  int _progressCount = 0;

  /// Stream of progress states.
  @override
  Stream<BaseProgressState> get progressStream =>
      _progressStreamController.stream;

  /// Starts progress overlay.
  ///
  /// Increments the internal progress counter.
  void startProgress({BaseProgressState? state}) {
    _progressCount++;
    if (!_progressStreamController.isClosed && _progressCount == 1) {
      _progressStreamController.add(
        state ?? const DefaultProgressState(showProgress: true),
      );
    }
  }

  /// Stops progress overlay with a small delay to avoid flickering.
  ///
  /// Decrements the internal progress counter. The overlay is only hidden
  /// when the counter reaches zero.
  Future<void> stopProgress({BaseProgressState? state}) async {
    if (_progressCount == 0) return;
    _progressCount--;

    if (_progressCount == 0) {
      // Small delay to ensure the UI has time to register the 'show' state
      // and to prevent flickering on very fast operations.
      await Future<void>.delayed(const Duration(milliseconds: 50));

      if (!_progressStreamController.isClosed && _progressCount == 0) {
        _progressStreamController.add(
          state ?? const DefaultProgressState(showProgress: false),
        );
      }
    }
  }

  /// Closes the progress stream controller.
  @protected
  void closeProgressStream() {
    if (!_progressStreamController.isClosed) {
      _progressStreamController.close();
    }
  }
}
