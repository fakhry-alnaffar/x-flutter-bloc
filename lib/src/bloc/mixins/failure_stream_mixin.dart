import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:x_flutter_bloc/x_flutter_bloc.dart';
import 'package:x_flutter_core_models/x_flutter_core_models.dart';

/// Mixin to add failure reporting capabilities to a BLoC or Cubit.
mixin class FailureStreamMixin implements FailureStreamProvider {
  final StreamController<Failure> _errorStreamController =
      StreamController<Failure>.broadcast(sync: true);

  /// Stream of failures.
  @override
  Stream<Failure> get failureStream => _errorStreamController.stream;

  /// Emits a failure to [failureStream].
  void emitFailure(Failure failure) {
    if (!_errorStreamController.isClosed) {
      _errorStreamController.add(failure);
    }
  }

  /// Closes the failure stream controller.
  @protected
  void closeFailureStream() {
    if (!_errorStreamController.isClosed) {
      _errorStreamController.close();
    }
  }
}
