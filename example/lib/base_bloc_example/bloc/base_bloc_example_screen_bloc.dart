import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:x_flutter_bloc/x_flutter_bloc.dart';
import 'package:x_flutter_core/x_flutter_core.dart';

part 'base_bloc_example_screen_event.dart';
part 'base_bloc_example_screen_sr.dart';
part 'base_bloc_example_screen_state.dart';

class BaseBlocExampleScreenBloc extends BaseBloc<BaseBlocExampleScreenEvent,
    BaseBlocExampleScreenState, BaseBlocExampleScreenSR> {
  BaseBlocExampleScreenBloc() : super(BaseBlocExampleScreenInitial()) {
    on<BaseBlocExampleScreenEventOnIncrement>((event, emit) async {
      final counter = switch (state) {
        BaseBlocExampleScreenData(:final counter) => counter,
        _ => 0,
      };

      // Simulation of an async operation using performOperation
      await performOperation(
        operation: () async {
          await Future.delayed(const Duration(seconds: 1));
          return DataResponse.success(counter + 1);
        },
        onSuccess: (newCounter) {
          emit(BaseBlocExampleScreenData(newCounter));
          addSr(BaseBlocExampleScreenSRShowDialog('Incremented to $newCounter'));
        },
      );
    });
  }
}
