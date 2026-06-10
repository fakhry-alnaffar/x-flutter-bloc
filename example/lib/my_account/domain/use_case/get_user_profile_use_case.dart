import 'package:x_flutter_core/x_flutter_core.dart';

import '../entity/user_profile.dart';
import '../repository/user_profile_repository.dart';

final class GetUserProfileUseCase {
  const GetUserProfileUseCase(this._repository);

  final UserProfileRepository _repository;

  Future<DataResponse<UserProfile>> call() => _repository.getProfile();
}
