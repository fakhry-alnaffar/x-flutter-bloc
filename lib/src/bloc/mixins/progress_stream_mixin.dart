import 'dart:async';

import 'package:onix_flutter_core_models/onix_flutter_core_models.dart';

/// Mixin to add progress tracking capabilities to a BLoC or Cubit.
mixin class ProgressStreamMixin {
  final StreamController<BaseProgressState> _progressStreamController =
      StreamController<BaseProgressState>.broadcast();

  /// Stream of progress states.
  Stream<BaseProgressState> get progressStream =>
      _progressStreamController.stream;

  /// Starts progress overlay.
  void startProgress({BaseProgressState? state}) {
    if (!_progressStreamController.isClosed) {
      _progressStreamController.add(
        state ?? const DefaultProgressState(showProgress: true),
      );
    }
  }

  /// Stops progress overlay with a small delay to avoid flickering.
  Future<void> stopProgress({BaseProgressState? state}) async {
    // Small delay to ensure the UI has time to register the 'show' state
    // and to prevent flickering on very fast operations.
    await Future<void>.delayed(const Duration(milliseconds: 50));
    if (!_progressStreamController.isClosed) {
      _progressStreamController.add(
        state ?? const DefaultProgressState(showProgress: false),
      );
    }
  }

  /// Closes the progress stream controller.
  void closeProgressStream() {
    if (!_progressStreamController.isClosed) {
      _progressStreamController.close();
    }
  }
}
