import 'package:projetmascara/core/services/logger_service.dart';

enum ConflictResolutionPolicy {
  lastWriteWins,
  serverWins,
  clientWins,
  manualOrReview,
}

class ConflictResult<T> {
  final T resolvedData;
  final bool wasConflict;
  final String resolutionReason;

  const ConflictResult({
    required this.resolvedData,
    required this.wasConflict,
    required this.resolutionReason,
  });
}

class ConflictResolver {
  final ConflictResolutionPolicy defaultPolicy;

  const ConflictResolver({
    this.defaultPolicy = ConflictResolutionPolicy.lastWriteWins,
  });

  /// Detects if a conflict exists between local and remote entity states.
  bool hasConflict({
    required DateTime localUpdatedAt,
    required DateTime remoteUpdatedAt,
    int? localVersion,
    int? remoteVersion,
  }) {
    if (localVersion != null &&
        remoteVersion != null &&
        localVersion != remoteVersion) {
      return true;
    }
    // Conflict exists if local data was updated independently after remote record
    return localUpdatedAt.isAfter(remoteUpdatedAt);
  }

  /// Resolves conflicts using policy and timestamps/version metadata.
  ConflictResult<Map<String, dynamic>> resolvePayload({
    required Map<String, dynamic> localPayload,
    required Map<String, dynamic> remotePayload,
    required DateTime localUpdatedAt,
    required DateTime remoteUpdatedAt,
    int localVersion = 1,
    int remoteVersion = 1,
    bool isSensitiveEntity = false,
    ConflictResolutionPolicy? policy,
  }) {
    final activePolicy = isSensitiveEntity
        ? ConflictResolutionPolicy.manualOrReview
        : (policy ?? defaultPolicy);

    final conflictExists = hasConflict(
      localUpdatedAt: localUpdatedAt,
      remoteUpdatedAt: remoteUpdatedAt,
      localVersion: localVersion,
      remoteVersion: remoteVersion,
    );

    if (!conflictExists) {
      return ConflictResult(
        resolvedData: remotePayload,
        wasConflict: false,
        resolutionReason: 'No conflict detected; remote accepted.',
      );
    }

    logger.w(
      'Conflict detected! Local updated: $localUpdatedAt (v$localVersion), Remote updated: $remoteUpdatedAt (v$remoteVersion)',
    );

    switch (activePolicy) {
      case ConflictResolutionPolicy.serverWins:
        return ConflictResult(
          resolvedData: remotePayload,
          wasConflict: true,
          resolutionReason: 'Resolved by ServerWins policy.',
        );

      case ConflictResolutionPolicy.clientWins:
        return ConflictResult(
          resolvedData: localPayload,
          wasConflict: true,
          resolutionReason: 'Resolved by ClientWins policy.',
        );

      case ConflictResolutionPolicy.manualOrReview:
        // Flag for human/professional review without silent overwrite
        final merged = Map<String, dynamic>.from(localPayload);
        merged['_conflictFlag'] = true;
        merged['_remoteState'] = remotePayload;
        merged['_conflictDetectedAt'] = DateTime.now().toIso8601String();
        return ConflictResult(
          resolvedData: merged,
          wasConflict: true,
          resolutionReason:
              'Sensitive entity flagged for manual/controlled review.',
        );

      case ConflictResolutionPolicy.lastWriteWins:
      default:
        if (localUpdatedAt.isAfter(remoteUpdatedAt)) {
          return ConflictResult(
            resolvedData: localPayload,
            wasConflict: true,
            resolutionReason: 'Resolved by LastWriteWins (Local is newer).',
          );
        } else {
          return ConflictResult(
            resolvedData: remotePayload,
            wasConflict: true,
            resolutionReason: 'Resolved by LastWriteWins (Remote is newer).',
          );
        }
    }
  }
}
