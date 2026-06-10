part of 'base_cubit_example_screen_cubit.dart';

@immutable
sealed class BaseCubitExampleScreenState extends Equatable {
  const BaseCubitExampleScreenState();

  @override
  List<Object?> get props => [];
}

final class BaseCubitExampleScreenInitial extends BaseCubitExampleScreenState {
  const BaseCubitExampleScreenInitial();
}

final class BaseCubitExampleScreenData extends BaseCubitExampleScreenState {
  final int counter;

  const BaseCubitExampleScreenData(this.counter);

  @override
  List<Object?> get props => [counter];
}
