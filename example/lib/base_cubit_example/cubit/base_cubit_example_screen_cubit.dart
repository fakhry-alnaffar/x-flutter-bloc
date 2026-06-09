import 'package:flutter/foundation.dart';
import 'package:onix_flutter_bloc/onix_flutter_bloc.dart';
import 'package:onix_flutter_core/onix_flutter_core.dart';

part 'base_cubit_example_screen_sr.dart';
part 'base_cubit_example_screen_state.dart';

class BaseCubitExampleScreenCubit
    extends BaseCubit<BaseCubitExampleScreenState, BaseCubitExampleScreenSR> {
  BaseCubitExampleScreenCubit() : super(BaseCubitExampleScreenInitial());

  Future<void> increment() async {
    int counter = state is BaseCubitExampleScreenData
        ? (state as BaseCubitExampleScreenData).counter
        : 0;

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
