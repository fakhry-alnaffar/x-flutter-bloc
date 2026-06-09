import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:onix_flutter_bloc/src/bloc/base_cubit/base_cubit.dart';
import 'package:onix_flutter_bloc/src/bloc/bloc_typedefs.dart';
import 'package:onix_flutter_bloc/src/bloc/mixins/base_ui_state_mixin.dart';
import 'package:onix_flutter_bloc/src/bloc/mixins/bloc_builders_mixin.dart';
import 'package:onix_flutter_bloc/src/bloc/stream_listener.dart';

/// Base class for all Cubit-based states.
///
/// Handles Cubit creation, lifecycle, and auxiliary streams (failure, progress, single results).
abstract class BaseCubitState<S, C extends BaseCubit<S, SR>, SR,
        W extends StatefulWidget> extends State<W>
    with BlocBuildersMixin<C, S, SR>, BaseUiStateMixin<W, SR> {
  bool lazyCubit = false;
  C? _cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<C>(
      create: (context) {
        final cubit = createCubit();
        _cubit = cubit;
        onCubitCreated(context, cubit);
        return cubit;
      },
      lazy: lazyCubit,
      child: Builder(
        builder: (context) {
          initParams(context);
          final cubit = _cubit ?? cubitOf(context);
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
    // Note: The Cubit is closed by BlocProvider
    if (context.mounted) {
      context.loaderOverlay.hide();
    }
    super.dispose();
  }

  /// Shortcut to get the Cubit from the context.
  C cubitOf(BuildContext context) => context.read<C>();

  /// Factory method to create the Cubit.
  C createCubit();

  /// Observes SingleResults and triggers [onSR].
  Widget srObserver({
    required BuildContext context,
    required Widget child,
    required SingleResultListener<SR> onSR,
  }) {
    return StreamListener<SR>(
      stream: (_cubit ?? cubitOf(context)).singleResults,
      onData: (data) => onSR(context, data),
      child: child,
    );
  }

  /// Called after the Cubit is created.
  void onCubitCreated(BuildContext context, C cubit) {}

  /// Initialization of parameters before [buildWidget].
  // ignore: no-empty-block
  void initParams(BuildContext context) {}

  /// Main UI builder method.
  Widget buildWidget(BuildContext context);
}
