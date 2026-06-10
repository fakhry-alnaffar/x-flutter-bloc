import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:x_flutter_bloc/x_flutter_bloc.dart';
import 'package:x_flutter_core_models/x_flutter_core_models.dart';

/// The ultimate Stateless UI template for Enterprise Flutter Apps.
///
/// [BaseStatelessScreen] provides a purely declarative way to build screens
/// that are automatically synchronized with a [BaseBloc] or [BaseCubit].
///
/// Features:
/// - Automatic [BlocProvider] scoping.
/// - Integrated [failureStream] listening (Errors).
/// - Integrated [progressStream] orchestration (Loading).
/// - Integrated [singleResults] orchestration (Navigation/Toast).
///
/// [S] represents the UI State.
/// [B] represents the BLoC/Cubit (must implement [IBaseBloc]).
/// [SR] represents the Single Result (One-time event).
abstract class BaseStatelessScreen<S, B extends IBaseBloc<S, SR>, SR>
    extends StatelessWidget {
  const BaseStatelessScreen({super.key});

  /// Factory method to create the BLoC/Cubit instance.
  B createBloc(BuildContext context);

  /// Called automatically when a [Failure] is emitted from the BLoC.
  void onFailure(BuildContext context, Failure failure) {}

  /// Called automatically when a [SR] (Single Result) is emitted.
  void onSR(BuildContext context, SR sr) {}

  /// Called automatically when the progress/loading state changes.
  /// Default implementation uses [loader_overlay].
  void onProgress(BuildContext context, BaseProgressState progress) {
    if (progress is DefaultProgressState) {
      if (progress.showProgress) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }
    }
  }

  /// Helper to get the BLoC instance from the context.
  B blocOf(BuildContext context) => context.read<B>();

  /// The UI builder method.
  ///
  /// Senior Tip: Keep this method "Pure". Use [BlocSelector] inside your
  /// widget tree to minimize rebuilds.
  Widget buildScreen(BuildContext context);

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    return BlocProvider<B>(
      create: (context) => createBloc(context),
      child: Builder(
        builder: (context) {
          final bloc = blocOf(context);

          return StreamListener<Failure>(
            stream: bloc.failureStream,
            onData: (failure) => onFailure(context, failure),
            child: StreamListener<SR>(
              stream: bloc.singleResults,
              onData: (sr) => onSR(context, sr),
              child: StreamListener<BaseProgressState>(
                stream: bloc.progressStream,
                onData: (progress) => onProgress(context, progress),
                child: buildScreen(context),
              ),
            ),
          );
        },
      ),
    );
  }
}
