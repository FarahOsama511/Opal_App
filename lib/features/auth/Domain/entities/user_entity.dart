import 'package:equatable/equatable.dart';
import 'package:opal_app/features/Tours/Domain/entities/tour.dart';

class UserEntity extends Equatable {
  final String? id;
  final String? name;
  final String? phone;
  final String? role;
  final String? universityId;
  final String? universityCardId;
  final LineEntity? line;

  UserEntity({
    this.id,
    this.name,
    this.phone,
    this.role,
    this.universityId,
    this.universityCardId,
    this.line,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    phone,
    role,
    universityId,
    universityCardId,
    line,
  ];
}

// [
//   {
//     "id": "cm123abc456def789",
//     "name": "Ahmed Hassan",
//     "phone": "01234567890",
//     "role": "student",
//     "universityId": "EGY001",
//     "universityCardId": "20210001",
//     "lineId": "cm123line456def",
//     "isActivated": true,
//     "createdAt": "2024-01-15T10:30:00Z",
//     "updatedAt": "2024-01-15T10:30:00Z",
//     "university": {
//       "id": "EGY001",
//       "name": "Cairo University",
//       "location": "Giza, Egypt",
//       "createdAt": "2024-01-01T00:00:00Z",
//       "updatedAt": "2024-01-01T00:00:00Z"
//     },
//     "line": {
//       "id": "cm123line456def",
//       "name": "Cairo University - Heliopolis",
//       "createdAt": "2024-01-01T00:00:00Z",
//       "updatedAt": "2024-01-01T00:00:00Z"
//     }
//   }
// ]
