import 'package:equatable/equatable.dart';

final class UserProfile extends Equatable {
  const UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.bio,
    required this.memberSince,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String? bio;
  final DateTime memberSince;

  String get fullName => '$firstName $lastName'.trim();

  String get initials {
    final f = firstName.isNotEmpty ? firstName[0] : '';
    final l = lastName.isNotEmpty ? lastName[0] : '';
    return '$f$l'.toUpperCase();
  }

  UserProfile copyWith({
    String? firstName,
    String? lastName,
    String? phone,
    String? bio,
    String? avatarUrl,
  }) =>
      UserProfile(
        id: id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email,
        phone: phone ?? this.phone,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        bio: bio ?? this.bio,
        memberSince: memberSince,
      );

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phone,
        avatarUrl,
        bio,
        memberSince,
      ];
}
