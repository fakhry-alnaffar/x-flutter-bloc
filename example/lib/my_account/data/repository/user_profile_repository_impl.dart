import 'package:x_flutter_core/x_flutter_core.dart';

import '../../domain/entity/change_password_params.dart';
import '../../domain/entity/update_profile_params.dart';
import '../../domain/entity/user_profile.dart';
import '../../domain/repository/user_profile_repository.dart';
import '../dto/user_profile_dto.dart';
import '../mapper/user_profile_mapper.dart';

/// Mock implementation. Replace with a real [Dio]-backed data source.
///
/// Demo password for [changePassword]: `Pass@1234`
final class UserProfileRepositoryImpl implements UserProfileRepository {
  UserProfileRepositoryImpl();

  static const _simulatedDelay = Duration(milliseconds: 900);

  // Mutable mock store — simulates server-side persistence.
  UserProfile _store = const UserProfileDto(
    id: 'usr_001',
    firstName: 'Fakhry',
    lastName: 'Al-Naffar',
    email: 'fakhry@tyrhal.com',
    phone: '+966 50 000 0000',
    avatarUrl: null,
    bio: 'Senior Flutter Developer & Software Architect',
    memberSince: '2022-01-15T00:00:00.000Z',
  ).toEntity();

  @override
  Future<DataResponse<UserProfile>> getProfile() async {
    await Future<void>.delayed(_simulatedDelay);
    return DataResponse.success(_store);
  }

  @override
  Future<DataResponse<UserProfile>> updateProfile(
    UpdateProfileParams params,
  ) async {
    await Future<void>.delayed(_simulatedDelay);
    _store = _store.copyWith(
      firstName: params.firstName,
      lastName: params.lastName,
      phone: params.phone,
      bio: params.bio,
    );
    return DataResponse.success(_store);
  }

  @override
  Future<DataResponse<bool>> changePassword(ChangePasswordParams params) async {
    await Future<void>.delayed(_simulatedDelay);
    if (params.currentPassword != 'Pass@1234') {
      return DataResponse.apiError('Current password is incorrect', 401);
    }
    return DataResponse.success(true);
  }

  @override
  Future<DataResponse<bool>> logout() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return DataResponse.success(true);
  }
}
