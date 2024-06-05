import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_user.g.dart';

@JsonSerializable()
class MyUser extends Equatable {
  const MyUser({required this.userId, required this.email, required this.firstName, required this.lastName});

  final String userId;
  final String email;
  final String firstName;
  final String lastName;

  static const empty = MyUser(
    userId: '',
    email: '',
    firstName: '',
    lastName: '',
  );

  MyUser copyWith({
    String? userId,
    String? email,
    String? firstName,
    String? lastName,
  }) {
    return MyUser(
        userId: userId ?? this.userId,
        email: email ?? this.email,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
    );
  }

  factory MyUser.fromJson(Map<String, dynamic> json) => _$MyUserFromJson(json);

  Map<String, dynamic> toJson() => _$MyUserToJson(this);

  @override
  List<Object?> get props => [userId, email, firstName, lastName];
}
