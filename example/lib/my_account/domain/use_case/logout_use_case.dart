import 'package:x_flutter_core/x_flutter_core.dart';

import '../repository/user_profile_repository.dart';

final class LogoutUseCase {
  const LogoutUseCase(this._repository);

  final UserProfileRepository _repository;

  Future<DataResponse<bool>> call() => _repository.logout();
}
