sealed class MyAccountSR {
  const MyAccountSR();
}

final class ProfileUpdated extends MyAccountSR {
  const ProfileUpdated();
}

final class PasswordChanged extends MyAccountSR {
  const PasswordChanged();
}

final class LoggedOut extends MyAccountSR {
  const LoggedOut();
}
