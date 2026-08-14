import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'package:projetmascara/core/models/sync_item.dart';
import 'package:projetmascara/core/data/remote_data_source.dart';
import 'package:projetmascara/core/services/logger_service.dart';
import 'package:projetmascara/core/data/hive_config.dart';
import 'package:uuid/uuid.dart';

class SyncService {
  static const String _boxName = 'sync_queue';
  final AssessmentRemoteDataSource _assessmentRemote;
  final ProfessionalRemoteDataSource _professionalRemote;
  final _uuid = const Uuid();
  
  bool _isSyncing = false;
  StreamSubscription? _connectivitySubscription;

  SyncService({
    required AssessmentRemoteDataSource assessmentRemote,
    required ProfessionalRemoteDataSource professionalRemote,
  }) : _assessmentRemote = assessmentRemote,
       _professionalRemote = professionalRemote {
    _init();
  }

  void _init() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) {
      if (results.any((r) => r != ConnectivityResult.none)) {
        processQueue();
      }
    });
  }

  Future<void> addToQueue(String type, SyncOperation operation, Map<String, dynamic> payload) async {
    final encryptionCipher = await HiveConfig.getEncryptionCipher();
    final box = await Hive.openBox<SyncItem>(_boxName, encryptionCipher: encryptionCipher);
    final item = SyncItem(
      id: _uuid.v4(),
      type: type,
      operation: operation,
      payload: payload,
      createdAt: DateTime.now(),
    );
    await box.put(item.id, item);
    processQueue();
  }

  Future<void> processQueue() async {
    if (_isSyncing) return;
    
    final results = await Connectivity().checkConnectivity();
    if (results.every((r) => r == ConnectivityResult.none)) return;

    _isSyncing = true;
    final encryptionCipher = await HiveConfig.getEncryptionCipher();
    final box = await Hive.openBox<SyncItem>(_boxName, encryptionCipher: encryptionCipher);
    final items = box.values.toList()..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    for (var item in items) {
      try {
        await _syncItem(item);
        await box.delete(item.id);
        logger.i('Synced item ${item.id}');
      } catch (e) {
        final updatedItem = item.copyWith(
          retries: item.retries + 1,
          lastError: e.toString(),
        );
        
        // Exponential backoff delay simulation or strategy could be added here
        if (updatedItem.retries > 5) {
          logger.e('Item ${item.id} failed after max retries. Moving to dead letter.');
          await box.delete(item.id); 
        } else {
          logger.w('Retry ${updatedItem.retries} for item ${item.id}');
          await box.put(item.id, updatedItem);
        }
        break;
      }
    }
    
    _isSyncing = false;
  }

  Future<void> _syncItem(SyncItem item) async {
    switch (item.type) {
      case 'assessment':
        // Conversion logic from payload to model would be here
        // For now, assume it's handled by remote DS
        // await _assessmentRemote.uploadAssessment(...)
        break;
      case 'access_request':
        // await _professionalRemote.updateAccessRequest(...)
        break;
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }
}
