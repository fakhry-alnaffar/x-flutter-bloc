final class UpdateProfileRequestDto {
  const UpdateProfileRequestDto({
    required this.firstName,
    required this.lastName,
    this.phone,
    this.bio,
  });

  final String firstName;
  final String lastName;
  final String? phone;
  final String? bio;

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        if (phone != null) 'phone': phone,
        if (bio != null) 'bio': bio,
      };
}
