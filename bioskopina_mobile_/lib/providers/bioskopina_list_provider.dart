import 'package:bioskopina_mobile/models/bioskopina_list.dart';
import 'package:bioskopina_mobile/providers/base_provider.dart';

class BioskopinaListProvider extends BaseProvider<BioskopinaList> {
  BioskopinaListProvider() : super("BioskopinaLists");

  @override
  BioskopinaList fromJson(data) {
    return BioskopinaList.fromJson(data);
  }

  Future<BioskopinaList> addMovieToList({
    required int listId,
    required int movieId,
  }) async {
    // Using positional constructor as required by your model
    final relationship = BioskopinaList(null, listId, movieId, null);
    return await insert(relationship);
  }

  Future<bool> removeMovieFromList({
    required int listId,
    required int movieId,
  }) async {
    final relationships = await get(filter: {
      'ListId': '$listId',
      'MovieId': '$movieId'
    });

    if (relationships.result.isNotEmpty) {
      await delete(relationships.result.first.id!);
      return true;
    }
    return false;
  }

  Future<List<BioskopinaList>> getByList(int listId) async {
    final response = await get(filter: {'ListId': '$listId'});
    return response.result;
  }

  Future<List<BioskopinaList>> getByMovie(int movieId) async {
    final response = await get(filter: {'MovieId': '$movieId'});
    return response.result;
  }
  // Add to BioskopinaListProvider class
// Add to BioskopinaListProvider class
Future<void> updateMovieLists(int movieId, List<BioskopinaList> newLists) async {
  try {
    // Get current associations
    final current = await getByMovie(movieId);

    // Determine which to remove (existing but not in new lists)
    final newListIds = newLists.map((e) => e.listId).toList();
    final toRemove = current.where((e) => !newListIds.contains(e.listId));

    // Remove old associations
    for (var relation in toRemove) {
      await delete(relation.id!);
    }

    // Add new associations
    final currentListIds = current.map((e) => e.listId).toList();
    for (var list in newLists) {
      if (!currentListIds.contains(list.listId)) {
        await insert(list);
      }
    }
  } catch (e) {
    throw Exception("Failed to update movie lists: $e");
  }
}
}