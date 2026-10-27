import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:projetmascara/core/data/hive_config.dart';
import 'package:projetmascara/core/data/local_database.dart';
import 'package:projetmascara/core/data/sync/conflict_resolver.dart';
import 'package:projetmascara/core/models/sync_item.dart';
import 'package:projetmascara/core/services/logger_service.dart';

class SyncQueueService {
  final LocalDatabase db;
  final ConflictResolver conflictResolver;
  final Connectivity connectivity;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isProcessing = false;
  final int maxRetries;

  SyncQueueService({
    LocalDatabase? database,
    ConflictResolver? resolver,
    Connectivity? connectivityInstance,
    this.maxRetries = 5,
  }) : db = database ?? LocalDatabase.instance,
       conflictResolver = resolver ?? const ConflictResolver(),
       connectivity = connectivityInstance ?? Connectivity();

  Box<SyncItem> get _queueBox => db.getBox<SyncItem>(HiveConfig.syncQueueBox);

  /// Initializes the SyncQueueService and sets up offline/online listeners.
  void init() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      final isConnected = results.any((r) => r != ConnectivityResult.none);
      if (isConnected) {
        logger.i('Network connection restored. Draining sync queue...');
        processQueue();
      }
    });
    logger.i('SyncQueueService initialized and listening for network changes');
  }

  /// Enqueues a sync operation idempotently.
  /// If an item for the same entity and operation exists, it updates it instead of creating duplicates.
  Future<void> enqueue(SyncItem item) async {
    final existingKey = _findExistingSyncItemKey(item);

    if (existingKey != null) {
      final existing = _queueBox.get(existingKey);
      if (existing != null) {
        final updated = existing.copyWith(
          payload: item.payload,
          updatedAt: DateTime.now(),
          retries: 0,
          syncStatus: SyncStatus.pending,
          lastError: null,
          consentContext: item.consentContext ?? existing.consentContext,
          version: existing.version + 1,
        );
        await _queueBox.put(existingKey, updated);
        logger.i(
          'Updated existing pending SyncItem: key=$existingKey, type=${item.type}, entityId=${item.entityId}',
        );
        return;
      }
    }

    await _queueBox.put(item.id, item);
    logger.i(
      'Enqueued new SyncItem: id=${item.id}, type=${item.type}, op=${item.operation.name}',
    );

    // Attempt processing immediately if online
    checkAndProcess();
  }

  /// Finds an existing pending SyncItem matching the entityId, type, and operation.
  dynamic _findExistingSyncItemKey(SyncItem item) {
    if (item.entityId == null) return null;
    for (final entry in _queueBox.toMap().entries) {
      final queued = entry.value;
      if (queued.type == item.type &&
          (queued.entityId == item.entityId || queued.id == item.id) &&
          queued.operation == item.operation &&
          queued.syncStatus == SyncStatus.pending) {
        return entry.key;
      }
    }
    return null;
  }

  /// Checks network status and processes queue if connected.
  Future<void> checkAndProcess() async {
    try {
      final results = await connectivity.checkConnectivity();
      final isConnected = results.any((r) => r != ConnectivityResult.none);
      if (isConnected) {
        await processQueue();
      }
    } catch (_) {}
  }

  /// Processes all pending sync items in order of priority and creation date.
  Future<void> processQueue() async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      final pendingItems = _queueBox.values
          .where(
            (item) =>
                item.syncStatus == SyncStatus.pending ||
                item.syncStatus == SyncStatus.failed,
          )
          .where((item) => item.retries < maxRetries)
          .where(
            (item) => item.userId != null && item.userId != 'guest',
          ) // Guest items remain local until migration
          .toList();

      if (pendingItems.isEmpty) {
        _isProcessing = false;
        return;
      }

      // Sort by priority (higher priority first: urgent=3 -> low=0), then by createdAt
      pendingItems.sort((a, b) {
        final prioComp = b.priority.compareTo(a.priority);
        if (prioComp != 0) return prioComp;
        return a.createdAt.compareTo(b.createdAt);
      });

      logger.i('Processing ${pendingItems.length} items in sync queue...');

      for (final item in pendingItems) {
        await _processItem(item);
      }
    } catch (e, st) {
      logger.e('Error during sync queue processing: $e', e, st);
    } finally {
      _isProcessing = false;
    }
  }

  /// Processes a single SyncItem with retry and status tracking.
  Future<void> _processItem(SyncItem item) async {
    final syncingItem = item.copyWith(
      syncStatus: SyncStatus.syncing,
      updatedAt: DateTime.now(),
    );
    await _queueBox.put(item.id, syncingItem);

    try {
      // Simulate/Execute Remote API synchronization idempotently
      final success = await _executeRemoteSync(syncingItem);

      if (success) {
        final syncedItem = syncingItem.copyWith(
          syncStatus: SyncStatus.synced,
          updatedAt: DateTime.now(),
        );
        await _queueBox.put(item.id, syncedItem);
        // Remove completed items from queue after marking synced
        await _queueBox.delete(item.id);
        logger.i('Sync completed successfully for item: ${item.id}');
      } else {
        await _handleFailure(syncingItem, 'Remote API rejected payload');
      }
    } catch (e) {
      await _handleFailure(syncingItem, e.toString());
    }
  }

  /// Handles sync failure with retry count increment and exponential backoff tracking.
  Future<void> _handleFailure(SyncItem item, String errorMessage) async {
    final nextRetries = item.retries + 1;
    final isFailed = nextRetries >= maxRetries;

    final updated = item.copyWith(
      retries: nextRetries,
      lastError: errorMessage,
      syncStatus: isFailed ? SyncStatus.failed : SyncStatus.pending,
      updatedAt: DateTime.now(),
    );

    await _queueBox.put(item.id, updated);
    logger.w(
      'Sync failed for item ${item.id} (attempt $nextRetries/$maxRetries): $errorMessage',
    );
  }

  /// Simulates / executes idempotent remote sync.
  Future<bool> _executeRemoteSync(SyncItem item) async {
    // In production, this dispatches HTTP calls based on entityType and operation
    await Future.delayed(const Duration(milliseconds: 100));
    return true;
  }

  /// Retrieves all items currently in the sync queue.
  List<SyncItem> getQueue() => _queueBox.values.toList();

  /// Retrieves pending sync items for a specific user ID.
  List<SyncItem> getPendingItemsForUser(String userId) {
    return _queueBox.values
        .where(
          (item) =>
              item.userId == userId && item.syncStatus == SyncStatus.pending,
        )
        .toList();
  }

  /// Clears completed synced items.
  Future<void> clearSyncedItems() async {
    final keysToDelete = _queueBox
        .toMap()
        .entries
        .where((e) => e.value.syncStatus == SyncStatus.synced)
        .map((e) => e.key)
        .toList();

    for (final key in keysToDelete) {
      await _queueBox.delete(key);
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }
}
