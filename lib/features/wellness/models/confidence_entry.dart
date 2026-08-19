import 'package:hive/hive.dart';

part 'confidence_entry.g.dart';

@HiveType(typeId: 4)
class ConfidenceEntry extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final DateTime date;
  
  @HiveField(2)
  final String strength;
  
  @HiveField(3)
  final String success;
  
  @HiveField(4)
  final String goal;

  ConfidenceEntry({
    required this.id,
    required this.date,
    required this.strength,
    required this.success,
    required this.goal,
  });
}
