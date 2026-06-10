import 'package:equatable/equatable.dart';

final class UpdateProfileParams extends Equatable {
  const UpdateProfileParams({
    required this.firstName,
    required this.lastName,
    this.phone,
    this.bio,
  });

  final String firstName;
  final String lastName;
  final String? phone;
  final String? bio;

  @override
  List<Object?> get props => [firstName, lastName, phone, bio];
}
