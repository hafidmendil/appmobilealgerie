import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/directory_models.dart';
import '../repositories/directory_repository.dart';

final wilayasProvider = FutureProvider<List<Wilaya>>((ref) async {
  return ref.watch(directoryRepositoryProvider).getWilayas();
});

final searchResultsProvider = FutureProvider.family<List<SearchResult>, SearchParams>((ref, params) async {
  return ref.watch(directoryRepositoryProvider).search(
    query: params.query,
    wilayaId: params.wilayaId,
    type: params.type,
  );
});

class SearchParams {
  final String? query;
  final int? wilayaId;
  final String? type;

  SearchParams({this.query, this.wilayaId, this.type});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchParams &&
          runtimeType == other.runtimeType &&
          query == other.query &&
          wilayaId == other.wilayaId &&
          type == other.type;

  @override
  int get hashCode => query.hashCode ^ wilayaId.hashCode ^ type.hashCode;
}

final selectedWilayaProvider = StateProvider<Wilaya?>((ref) => null);
final searchTypeProvider = StateProvider<String?>((ref) => null); // professional, cabinet, public
final searchQueryProvider = StateProvider<String>((ref) => '');
