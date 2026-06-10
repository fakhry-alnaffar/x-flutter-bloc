import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_flutter_bloc/src/bloc/mixins/single_result_mixin.dart';

/// Standard BlocObserver for the application.
///
/// Logs events, transitions, errors and SingleResults in debug mode.
class AppBlocObserver extends SrBlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    if (kDebugMode) {
      debugPrint('AppBlocObserver :: onEvent in ${bloc.runtimeType}');
      debugPrint('Event: $event');
    }
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      debugPrint('AppBlocObserver :: onChange in ${bloc.runtimeType}');
      debugPrint('Change: $change');
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if (kDebugMode) {
      debugPrint('AppBlocObserver :: onTransition in ${bloc.runtimeType}');
      debugPrint('Transition: $transition');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      debugPrint('AppBlocObserver :: onError in ${bloc.runtimeType}');
      debugPrint('Error: $error');
      debugPrint('StackTrace: $stackTrace');
    }
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onSr(BlocBase bloc, dynamic sr) {
    super.onSr(bloc, sr);
    if (kDebugMode) {
      debugPrint('AppBlocObserver :: onSingleResult in ${bloc.runtimeType}');
      debugPrint('SR: $sr');
    }
  }
}
