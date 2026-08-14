import 'package:hive/hive.dart';

part 'wilaya_model.g.dart';

@HiveType(typeId: 10)
class Wilaya extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String nameFr;
  
  @HiveField(2)
  final String nameAr;
  
  @HiveField(3)
  final int code;

  Wilaya({
    required this.id,
    required this.nameFr,
    required this.nameAr,
    required this.code,
  });
}
