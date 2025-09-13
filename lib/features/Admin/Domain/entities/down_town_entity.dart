import 'package:equatable/equatable.dart';

import '../../../user/Domain/entities/user_entity.dart';

class DownTownEntity extends Equatable {
  final String? name;
  final String? id;
  final List<UserEntity>? users;

  DownTownEntity({this.id, this.name, this.users});
  DownTownEntity copyWith({String? id, String? name}) {
    return DownTownEntity(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  List<Object?> get props => [name, id];
}
