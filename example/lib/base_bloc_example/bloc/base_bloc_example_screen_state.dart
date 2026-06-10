part of 'base_bloc_example_screen_bloc.dart';

@immutable
sealed class BaseBlocExampleScreenState extends Equatable {
  const BaseBlocExampleScreenState();

  @override
  List<Object?> get props => [];
}

final class BaseBlocExampleScreenInitial extends BaseBlocExampleScreenState {
  const BaseBlocExampleScreenInitial();
}

final class BaseBlocExampleScreenData extends BaseBlocExampleScreenState {
  final int counter;

  const BaseBlocExampleScreenData(this.counter);

  @override
  List<Object?> get props => [counter];
}
