import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onix_flutter_bloc/src/bloc/mixins/failure_stream_mixin.dart';
import 'package:onix_flutter_bloc/src/bloc/mixins/operation_orchestrator.dart';
import 'package:onix_flutter_bloc/src/bloc/mixins/progress_stream_mixin.dart';
import 'package:onix_flutter_bloc/src/bloc/mixins/single_result_mixin.dart';

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
        OperationOrchestrator {
  BaseBloc(super.initialState);

  @override
  Future<void> close() {
    closeProgressStream();
    closeFailureStream();
    return super.close();
  }
}
