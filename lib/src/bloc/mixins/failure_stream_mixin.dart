import 'dart:async';

import 'package:onix_flutter_core_models/onix_flutter_core_models.dart';

/// Mixin to add failure reporting capabilities to a BLoC or Cubit.
mixin class FailureStreamMixin {
  final StreamController<Failure> _errorStreamController =
      StreamController<Failure>.broadcast();

  /// Stream of failures.
  Stream<Failure> get failureStream => _errorStreamController.stream;

  /// Emits a failure.
  void onFailure(Failure failure) {
    if (!_errorStreamController.isClosed) {
      _errorStreamController.add(failure);
    }
  }

  /// Closes the failure stream controller.
  void closeFailureStream() {
    if (!_errorStreamController.isClosed) {
      _errorStreamController.close();
    }
  }
}
