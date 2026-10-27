import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:projetmascara/core/data/local_database.dart';

/// Generic abstract interface for local repositories in NeuroSync Clean Architecture.
abstract class LocalRepository<T> {
  Future<void> save(dynamic key, T item);
  T? get(dynamic key);
  List<T> getAll();
  Future<void> delete(dynamic key);
  Future<void> clear();
  ValueListenable<Box<T>> listenable({List<dynamic>? keys});
}

/// Generic base class implementation for Hive-backed repositories.
abstract class BaseHiveRepository<T> implements LocalRepository<T> {
  final String boxName;
  final LocalDatabase db;

  BaseHiveRepository(this.boxName, {LocalDatabase? database})
    : db = database ?? LocalDatabase.instance;

  Box<T> get box => db.getBox<T>(boxName);

  @override
  Future<void> save(dynamic key, T item) async {
    await box.put(key, item);
  }

  @override
  T? get(dynamic key) => box.get(key);

  @override
  List<T> getAll() => box.values.toList();

  @override
  Future<void> delete(dynamic key) async {
    await box.delete(key);
  }

  @override
  Future<void> clear() async {
    await box.clear();
  }

  @override
  ValueListenable<Box<T>> listenable({List<dynamic>? keys}) {
    return box.listenable(keys: keys);
  }
}
