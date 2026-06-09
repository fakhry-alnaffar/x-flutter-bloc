import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onix_flutter_bloc/src/bloc/bloc_typedefs.dart';

/// Mixin to provide standard Bloc builder widgets.
mixin class BlocBuildersMixin<B extends StateStreamable<S>, S, SR> {
  /// A wrapper for [BlocConsumer].
  Widget blocConsumer({
    required StateListener<S> builder,
    required ListenDelegate<S> listener,
    BlocBuilderCondition<S>? buildWhen,
    BlocListenerCondition<S>? listenWhen,
  }) {
    return BlocConsumer<B, S>(
      builder: (_, state) => builder(state),
      listener: listener,
      buildWhen: buildWhen,
      listenWhen: listenWhen,
    );
  }

  /// A wrapper for [BlocBuilder].
  Widget blocBuilder({
    required BlocWidgetBuilder<S> builder,
    BlocBuilderCondition<S>? buildWhen,
  }) {
    return BlocBuilder<B, S>(builder: builder, buildWhen: buildWhen);
  }

  /// A wrapper for [BlocListener].
  Widget blocListener({
    required ListenDelegate<S> listener,
    Widget? child,
    BlocListenerCondition<S>? listenWhen,
  }) {
    return BlocListener<B, S>(
      listener: listener,
      listenWhen: listenWhen,
      child: child,
    );
  }
}
