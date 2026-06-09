import 'package:flutter/foundation.dart';
import 'package:onix_flutter_bloc/onix_flutter_bloc.dart';
import 'package:onix_flutter_core/onix_flutter_core.dart';

part 'base_bloc_example_screen_event.dart';
part 'base_bloc_example_screen_sr.dart';
part 'base_bloc_example_screen_state.dart';

class BaseBlocExampleScreenBloc extends BaseBloc<BaseBlocExampleScreenEvent,
    BaseBlocExampleScreenState, BaseBlocExampleScreenSR> {
  BaseBlocExampleScreenBloc() : super(BaseBlocExampleScreenInitial()) {
    on<BaseBlocExampleScreenEventOnIncrement>((event, emit) async {
      int counter = state is BaseBlocExampleScreenData
          ? (state as BaseBlocExampleScreenData).counter
          : 0;

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
