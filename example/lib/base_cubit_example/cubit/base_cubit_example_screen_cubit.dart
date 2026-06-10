import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:x_flutter_bloc/x_flutter_bloc.dart';
import 'package:x_flutter_core/x_flutter_core.dart';

part 'base_cubit_example_screen_sr.dart';
part 'base_cubit_example_screen_state.dart';

class BaseCubitExampleScreenCubit
    extends BaseCubit<BaseCubitExampleScreenState, BaseCubitExampleScreenSR> {
  BaseCubitExampleScreenCubit() : super(BaseCubitExampleScreenInitial());

  Future<void> increment() async {
    final counter = switch (state) {
      BaseCubitExampleScreenData(:final counter) => counter,
      _ => 0,
    };

    await performOperation(
      operation: () async {
        await Future.delayed(const Duration(seconds: 1));
        return DataResponse.success(counter + 1);
      },
      onSuccess: (newCounter) {
        emit(BaseCubitExampleScreenData(newCounter));
        addSr(BaseCubitExampleScreenSRShowDialog('Incremented to $newCounter'));
      },
    );
  }
}
