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

@HiveType(typeId: 7)
enum SyncStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  syncing,
  @HiveField(2)
  synced,
  @HiveField(3)
  failed,
  @HiveField(4)
  conflict,
  @HiveField(5)
  cancelled,
}

@HiveType(typeId: 6)
class SyncItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String type; // e.g., 'assessment', 'violence_report', 'access_request'

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

  @HiveField(7)
  final String? entityId;

  @HiveField(8)
  final DateTime? updatedAt;

  @HiveField(9)
  final SyncStatus syncStatus;

  @HiveField(10)
  final int priority; // 0: low, 1: normal, 2: high, 3: urgent

  @HiveField(11)
  final String? userId;

  @HiveField(12)
  final String? consentContext;

  @HiveField(13)
  final int version;

  SyncItem({
    required this.id,
    required this.type,
    required this.operation,
    required this.payload,
    required this.createdAt,
    this.retries = 0,
    this.lastError,
    this.entityId,
    this.updatedAt,
    this.syncStatus = SyncStatus.pending,
    this.priority = 1,
    this.userId,
    this.consentContext,
    this.version = 1,
  });

  // Aliases for requirement compliance
  String get entityType => type;
  int get retryCount => retries;
  String? get ownerId => userId;

  SyncItem copyWith({
    String? id,
    String? type,
    SyncOperation? operation,
    Map<String, dynamic>? payload,
    DateTime? createdAt,
    int? retries,
    String? lastError,
    String? entityId,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
    int? priority,
    String? userId,
    String? consentContext,
    int? version,
  }) {
    return SyncItem(
      id: id ?? this.id,
      type: type ?? this.type,
      operation: operation ?? this.operation,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      retries: retries ?? this.retries,
      lastError: lastError ?? this.lastError,
      entityId: entityId ?? this.entityId,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      priority: priority ?? this.priority,
      userId: userId ?? this.userId,
      consentContext: consentContext ?? this.consentContext,
      version: version ?? this.version,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'entityType': entityType,
    'entityId': entityId ?? id,
    'operation': operation.name,
    'payload': payload,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': (updatedAt ?? createdAt).toIso8601String(),
    'syncStatus': syncStatus.name,
    'retryCount': retries,
    'lastError': lastError,
    'priority': priority,
    'userId': userId,
    'consentContext': consentContext,
    'version': version,
  };

  factory SyncItem.fromJson(Map<String, dynamic> json) => SyncItem(
    id: json['id'] as String,
    type: (json['type'] ?? json['entityType']) as String,
    operation: SyncOperation.values.byName(json['operation'] as String),
    payload: Map<String, dynamic>.from(json['payload'] as Map),
    createdAt: DateTime.parse(json['createdAt'] as String),
    retries: json['retryCount'] ?? json['retries'] ?? 0,
    lastError: json['lastError'] as String?,
    entityId: json['entityId'] as String?,
    updatedAt: json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'] as String)
        : null,
    syncStatus: json['syncStatus'] != null
        ? SyncStatus.values.byName(json['syncStatus'] as String)
        : SyncStatus.pending,
    priority: json['priority'] as int? ?? 1,
    userId: json['userId'] as String?,
    consentContext: json['consentContext'] as String?,
    version: json['version'] as int? ?? 1,
  );
}
