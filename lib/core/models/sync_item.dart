import 'package:hive/hive.dart';

part 'sync_item.g.dart';

@HiveType(typeId: 5)
enum SyncOperation {
  @HiveField(0)
  create,
  @HiveField(1)
  update,
  @HiveField(2)
  delete,
}

@HiveType(typeId: 6)
class SyncItem extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String type; // e.g., 'assessment', 'access_request'
  
  @HiveField(2)
  final SyncOperation operation;
  
  @HiveField(3)
  final Map<String, dynamic> payload;
  
  @HiveField(4)
  final DateTime createdAt;
  
  @HiveField(5)
  final int retries;
  
  @HiveField(6)
  final String? lastError;

  SyncItem({
    required this.id,
    required this.type,
    required this.operation,
    required this.payload,
    required this.createdAt,
    this.retries = 0,
    this.lastError,
  });

  SyncItem copyWith({
    int? retries,
    String? lastError,
  }) {
    return SyncItem(
      id: id,
      type: type,
      operation: operation,
      payload: payload,
      createdAt: createdAt,
      retries: retries ?? this.retries,
      lastError: lastError ?? this.lastError,
    );
  }
}
