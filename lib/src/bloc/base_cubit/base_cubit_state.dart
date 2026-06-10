import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:x_flutter_bloc/src/bloc/mixins/bloc_builders_mixin.dart';
import 'package:x_flutter_bloc/x_flutter_bloc.dart';

/// Base class for all Cubit-based states using [StatefulWidget].
///
/// Provides integrated support for Loading overlays, Error handling, and Single Results.
abstract class BaseCubitState<S, C extends IBaseBloc<S, SR>, SR,
        W extends StatefulWidget> extends State<W>
    with BlocBuildersMixin<C, S, SR>, BaseUiStateMixin<W, SR> {
  /// Whether the Cubit should be created lazily.
  bool lazyCubit = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<C>(
      create: (context) {
        final cubit = createCubit();
        onCubitCreated(context, cubit);
        return cubit;
      },
      lazy: lazyCubit,
      child: Builder(
        builder: (context) {
          initParams(context);
          final cubit = cubitOf(context);
          return buildUiStreams(
            failureStream: cubit.failureStream,
            singleResults: cubit.singleResults,
            progressStream: cubit.progressStream,
            child: buildWidget(context),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    if (context.mounted) {
      context.loaderOverlay.hide();
    }
    super.dispose();
  }

  /// Shortcut to retrieve the Cubit from the current context.
  C cubitOf(BuildContext context) => context.read<C>();

  /// Factory method to create the Cubit instance.
  C createCubit();

  /// Callback triggered immediately after the Cubit is created.
  void onCubitCreated(BuildContext context, C cubit) {}

  /// Observes SingleResults manually for a specific widget subtree.
  ///
  /// Useful when you need to listen to events from a nested Cubit or
  /// handle events at a specific point in the widget tree.
  Widget srObserver({
    required BuildContext context,
    required Widget child,
    required SingleResultListener<SR> onSR,
    C? cubit,
  }) {
    return StreamListener<SR>(
      stream: (cubit ?? cubitOf(context)).singleResults,
      onData: (data) => onSR(context, data),
      child: child,
    );
  }

  /// Hook for initializing parameters or arguments before [buildWidget].
  void initParams(BuildContext context) {}

  /// The main UI builder.
  Widget buildWidget(BuildContext context);
}
