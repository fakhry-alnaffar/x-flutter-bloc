import 'package:x_flutter_core/x_flutter_core.dart';

import '../entity/change_password_params.dart';
import '../entity/update_profile_params.dart';
import '../entity/user_profile.dart';

abstract interface class UserProfileRepository {
  Future<DataResponse<UserProfile>> getProfile();
  Future<DataResponse<UserProfile>> updateProfile(UpdateProfileParams params);
  Future<DataResponse<bool>> changePassword(ChangePasswordParams params);
  Future<DataResponse<bool>> logout();
}
