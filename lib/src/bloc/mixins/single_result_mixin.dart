import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onix_flutter_bloc/src/bloc/bloc_typedefs.dart';

/// Mixin for extending the block's capabilities to support SingleResult -
/// events that need to be rendered 1 time
/// - Navigation
/// - Toast
/// - Snack
/// - Some interaction with the animation
mixin SingleResultMixin<State, SR> on BlocBase<State>
    implements SingleResultProvider<SR>, SingleResultEmitter<SR> {
  @protected
  final StreamController<SR> _srController = StreamController.broadcast();

  @override
  Stream<SR> get singleResults => _srController.stream;

  @override
  void addSr(SR sr) {
    final observer = Bloc.observer;
    if (observer is SrBlocObserver) observer.onSr(this, sr);
    if (!_srController.isClosed) _srController.add(sr);
  }

  @override
  Future<void> close() =>
      _srController.close().then((_) => super.close());
}

/// Extending Observer to support logging SingleResult events
class SrBlocObserver extends BlocObserver {
  @protected
  @mustCallSuper
  //ignore: no-empty-block,avoid-unused-parameters
  void onSr(BlocBase bloc, dynamic sr) {}
}
