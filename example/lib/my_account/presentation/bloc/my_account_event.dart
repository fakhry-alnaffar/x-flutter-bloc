import '../../domain/entity/change_password_params.dart';
import '../../domain/entity/update_profile_params.dart';

sealed class MyAccountEvent {
  const MyAccountEvent();
}

final class LoadProfile extends MyAccountEvent {
  const LoadProfile();
}

final class UpdateProfile extends MyAccountEvent {
  const UpdateProfile(this.params);

  final UpdateProfileParams params;
}

final class ChangePassword extends MyAccountEvent {
  const ChangePassword(this.params);

  final ChangePasswordParams params;
}

final class Logout extends MyAccountEvent {
  const Logout();
}
