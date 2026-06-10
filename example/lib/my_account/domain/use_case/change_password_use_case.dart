import 'package:x_flutter_core/x_flutter_core.dart';

import '../entity/change_password_params.dart';
import '../repository/user_profile_repository.dart';

final class ChangePasswordUseCase {
  const ChangePasswordUseCase(this._repository);

  final UserProfileRepository _repository;

  Future<DataResponse<bool>> call(ChangePasswordParams params) =>
      _repository.changePassword(params);
}
