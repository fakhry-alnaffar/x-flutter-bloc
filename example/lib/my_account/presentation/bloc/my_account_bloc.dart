import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_flutter_bloc/x_flutter_bloc.dart';

import '../../domain/use_case/change_password_use_case.dart';
import '../../domain/use_case/get_user_profile_use_case.dart';
import '../../domain/use_case/logout_use_case.dart';
import '../../domain/use_case/update_user_profile_use_case.dart';
import 'my_account_event.dart';
import 'my_account_sr.dart';
import 'my_account_state.dart';

final class MyAccountBloc
    extends BaseBloc<MyAccountEvent, MyAccountState, MyAccountSR> {
  MyAccountBloc({
    required this._getProfile,
    required this._updateProfile,
    required this._changePassword,
    required this._logout,
  })  : super(const MyAccountInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<ChangePassword>(_onChangePassword);
    on<Logout>(_onLogout);
  }

  final GetUserProfileUseCase _getProfile;
  final UpdateUserProfileUseCase _updateProfile;
  final ChangePasswordUseCase _changePassword;
  final LogoutUseCase _logout;

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<MyAccountState> emit,
  ) async {
    await performOperation(
      operation: _getProfile.call,
      onSuccess: (profile) => emit(MyAccountLoaded(profile)),
    );
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<MyAccountState> emit,
  ) async {
    await performOperation(
      operation: () => _updateProfile(event.params),
      onSuccess: (profile) {
        emit(MyAccountLoaded(profile));
        addSr(const ProfileUpdated());
      },
    );
  }

  Future<void> _onChangePassword(
    ChangePassword event,
    Emitter<MyAccountState> emit,
  ) async {
    await performOperation<bool>(
      operation: () => _changePassword(event.params),
      onSuccess: (_) => addSr(const PasswordChanged()),
    );
  }

  Future<void> _onLogout(
    Logout event,
    Emitter<MyAccountState> emit,
  ) async {
    await performOperation<bool>(
      operation: _logout.call,
      onSuccess: (_) => addSr(const LoggedOut()),
    );
  }
}
