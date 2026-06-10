import '../../domain/entity/user_profile.dart';
import '../dto/user_profile_dto.dart';

extension UserProfileDtoMapper on UserProfileDto {
  UserProfile toEntity() => UserProfile(
        id: id,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        avatarUrl: avatarUrl,
        bio: bio,
        memberSince: DateTime.tryParse(memberSince) ?? DateTime.now(),
      );
}
