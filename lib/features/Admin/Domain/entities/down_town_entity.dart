import 'package:equatable/equatable.dart';
import 'package:opal_app/features/user/Domain/entities/user_entity.dart';

class DownTownEntity extends Equatable {
  final String? name;
  final String? id;
  final List<UserEntity>? users;

  DownTownEntity({this.id, this.name, this.users});

  @override
  List<Object?> get props => [name, id];
}
