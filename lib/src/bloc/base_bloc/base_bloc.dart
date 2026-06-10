import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_flutter_bloc/src/bloc/bloc_typedefs.dart';
import 'package:x_flutter_bloc/src/bloc/mixins/failure_stream_mixin.dart';
import 'package:x_flutter_bloc/src/bloc/mixins/operation_orchestrator.dart';
import 'package:x_flutter_bloc/src/bloc/mixins/progress_stream_mixin.dart';
import 'package:x_flutter_bloc/src/bloc/mixins/single_result_mixin.dart';

/// Base class for all BLoCs in the system.
///
/// Features:
/// - Single Result support (Navigation, Toasts, etc.)
/// - Progress Stream (Loading overlays)
/// - Failure Stream (Error handling)
/// - Integrated [DataResponse] processing via [OperationOrchestrator]
abstract class BaseBloc<Event, State, SR> extends Bloc<Event, State>
    with
        SingleResultMixin<State, SR>,
        ProgressStreamMixin,
        FailureStreamMixin,
        OperationOrchestrator
    implements IBaseBloc<State, SR> {
  BaseBloc(super.initialState);

  @override
  @mustCallSuper
  Future<void> close() {
    closeProgressStream();
    closeFailureStream();
    closeSingleResultStream();
    return super.close();
  }
}
