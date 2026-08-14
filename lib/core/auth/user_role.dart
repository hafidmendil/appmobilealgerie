import 'package:hive/hive.dart';

part 'user_role.g.dart';

@HiveType(typeId: 0)
enum UserRole {
  @HiveField(0)
  guest,
  @HiveField(1)
  user,
  @HiveField(2)
  psychologist,
  @HiveField(3)
  admin,
}
