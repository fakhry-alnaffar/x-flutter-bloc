import 'package:equatable/equatable.dart';

import '../../domain/entity/user_profile.dart';

sealed class MyAccountState extends Equatable {
  const MyAccountState();
}

final class MyAccountInitial extends MyAccountState {
  const MyAccountInitial();

  @override
  List<Object?> get props => [];
}

final class MyAccountLoaded extends MyAccountState {
  const MyAccountLoaded(this.profile);

  final UserProfile profile;

  @override
  List<Object?> get props => [profile];
}
