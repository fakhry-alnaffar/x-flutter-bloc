import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:onix_flutter_bloc/src/bloc/base_bloc/base_bloc.dart';
import 'package:onix_flutter_bloc/src/bloc/bloc_typedefs.dart';
import 'package:onix_flutter_bloc/src/bloc/mixins/base_ui_state_mixin.dart';
import 'package:onix_flutter_bloc/src/bloc/mixins/bloc_builders_mixin.dart';
import 'package:onix_flutter_bloc/src/bloc/stream_listener.dart';

/// Base class for all BLoC-based states.
///
/// Handles BLoC creation, lifecycle, and auxiliary streams (failure, progress, single results).
abstract class BaseState<S, B extends BaseBloc<dynamic, S, SR>, SR,
        W extends StatefulWidget> extends State<W>
    with BlocBuildersMixin<B, S, SR>, BaseUiStateMixin<W, SR> {
  bool lazyBloc = false;
  B? _bloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<B>(
      create: (context) {
        final bloc = createBloc();
        _bloc = bloc;
        onBlocCreated(context, bloc);
        return bloc;
      },
      lazy: lazyBloc,
      child: Builder(
        builder: (context) {
          initParams(context);
          final bloc = _bloc ?? blocOf(context);
          return buildUiStreams(
            failureStream: bloc.failureStream,
            singleResults: bloc.singleResults,
            progressStream: bloc.progressStream,
            child: buildWidget(context),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    // Note: The Bloc is closed by BlocProvider
    if (context.mounted) {
      context.loaderOverlay.hide();
    }
    super.dispose();
  }

  /// Shortcut to get the BLoC from the context.
  B blocOf(BuildContext context) => context.read<B>();

  /// Factory method to create the BLoC.
  B createBloc();

  /// Observes SingleResults and triggers [onSR].
  Widget srObserver({
    required BuildContext context,
    required Widget child,
    required SingleResultListener<SR> onSR,
  }) {
    return StreamListener<SR>(
      stream: (_bloc ?? blocOf(context)).singleResults,
      onData: (data) => onSR(context, data),
      child: child,
    );
  }

  /// Called after the BLoC is created.
  void onBlocCreated(BuildContext context, B bloc) {}

  /// Initialization of parameters before [buildWidget].
  // ignore: no-empty-block
  void initParams(BuildContext context) {}

  /// Main UI builder method.
  Widget buildWidget(BuildContext context);
}
