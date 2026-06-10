import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_flutter_bloc/src/bloc/bloc_typedefs.dart';

/// A convenience mixin providing standardized access to Flutter BLoC builders.
///
/// Reduces boilerplate when using [BlocBuilder], [BlocSelector], etc.,
/// by pre-binding the BLoC type [B] and State type [S].
mixin class BlocBuildersMixin<B extends StateStreamable<S>, S, SR> {
  /// A type-safe wrapper for [BlocConsumer].
  Widget blocConsumer({
    required BlocWidgetBuilder<S> builder,
    required ListenDelegate<S> listener,
    BlocBuilderCondition<S>? buildWhen,
    BlocListenerCondition<S>? listenWhen,
  }) {
    return BlocConsumer<B, S>(
      builder: builder,
      listener: listener,
      buildWhen: buildWhen,
      listenWhen: listenWhen,
    );
  }

  /// A type-safe wrapper for [BlocBuilder].
  Widget blocBuilder({
    required BlocWidgetBuilder<S> builder,
    BlocBuilderCondition<S>? buildWhen,
  }) {
    return BlocBuilder<B, S>(builder: builder, buildWhen: buildWhen);
  }

  /// A type-safe wrapper for [BlocListener].
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

  /// A type-safe wrapper for [BlocSelector].
  ///
  /// Senior Tip: Use this for high-performance UI components that only
  /// care about a specific field of the state.
  Widget blocSelector<T>({
    required BlocWidgetSelector<S, T> selector,
    required BlocWidgetBuilder<T> builder,
  }) {
    return BlocSelector<B, S, T>(
      selector: selector,
      builder: builder,
    );
  }
}
