import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:x_flutter_bloc/src/bloc/mixins/bloc_builders_mixin.dart';
import 'package:x_flutter_bloc/x_flutter_bloc.dart';

/// Base class for all BLoC-based states using [StatefulWidget].
///
/// Handles BLoC creation, lifecycle, and automatic stream orchestration.
abstract class BaseBlocState<S, B extends IBaseBloc<S, SR>, SR,
        W extends StatefulWidget> extends State<W>
    with BlocBuildersMixin<B, S, SR>, BaseUiStateMixin<W, SR> {
  /// Whether the BLoC should be created lazily.
  bool lazyBloc = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<B>(
      create: (context) {
        final bloc = createBloc();
        onBlocCreated(context, bloc);
        return bloc;
      },
      lazy: lazyBloc,
      child: Builder(
        builder: (context) {
          initParams(context);
          final bloc = blocOf(context);
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
    // Ensure any active overlay is hidden on dispose
    if (context.mounted) {
      context.loaderOverlay.hide();
    }
    super.dispose();
  }

  /// Shortcut to retrieve the BLoC from the current context.
  B blocOf(BuildContext context) => context.read<B>();

  /// Factory method to create the BLoC instance.
  B createBloc();

  /// Callback triggered immediately after the BLoC is created.
  void onBlocCreated(BuildContext context, B bloc) {}

  /// Observes SingleResults manually for a specific widget subtree.
  ///
  /// Useful when you need to listen to events from a nested BLoC or
  /// handle events at a specific point in the widget tree.
  Widget srObserver({
    required BuildContext context,
    required Widget child,
    required SingleResultListener<SR> onSR,
    B? bloc,
  }) {
    return StreamListener<SR>(
      stream: (bloc ?? blocOf(context)).singleResults,
      onData: (data) => onSR(context, data),
      child: child,
    );
  }

  /// Hook for initializing parameters or arguments before [buildWidget].
  void initParams(BuildContext context) {}

  /// The main UI builder.
  ///
  /// Senior Recommendation: Use [BlocSelector] or [context.select] inside this method
  /// for fine-grained rebuilds instead of relying on the whole widget rebuilding.
  Widget buildWidget(BuildContext context);
}
