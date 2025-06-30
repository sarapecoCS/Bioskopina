import 'package:bioskopina_mobile/models/bioskopina_list.dart';
import 'package:bioskopina_mobile/providers/base_provider.dart';
import 'package:flutter/foundation.dart';

class BioskopinaListProvider extends BaseProvider<BioskopinaList> {
  BioskopinaListProvider() : super("BioskopinaList");

  @override
  BioskopinaList fromJson(data) {
    try {
      return BioskopinaList.fromJson(data);
    } catch (e, stack) {
      debugPrint('Failed to parse BioskopinaList: $e\n$stack');
      throw FormatException('Invalid BioskopinaList data');
    }
  }

  Future<BioskopinaList> addMovieToList({
    required int listId,
    required int movieId,
  }) async {
    try {
      if (listId <= 0 || movieId <= 0) {
        throw ArgumentError('Invalid listId or movieId');
      }

      final relationship = BioskopinaList(null, listId, movieId, null);
      return await insert(relationship);
    } catch (e, stack) {
      debugPrint('Failed to add movie to list: $e\n$stack');
      throw Exception('Failed to add movie to list. Please try again.');
    }
  }

  Future<bool> removeMovieFromList({
    required int listId,
    required int movieId,
  }) async {
    try {
      if (listId <= 0 || movieId <= 0) {
        throw ArgumentError('Invalid listId or movieId');
      }

      final relationships = await get(filter: {
        'ListId': '$listId',
        'MovieId': '$movieId'
      });

      if (relationships.result.isNotEmpty) {
        final relationship = relationships.result.first;
        if (relationship.id != null) {
          await delete(relationship.id!);
          return true;
        }
      }
      return false;
    } catch (e, stack) {
      debugPrint('Failed to remove movie from list: $e\n$stack');
      throw Exception('Failed to remove movie from list. Please try again.');
    }
  }

  Future<List<BioskopinaList>> getByList(int listId) async {
    try {
      if (listId <= 0) {
        throw ArgumentError('Invalid listId');
      }

      final response = await get(filter: {'ListId': '$listId'});
      return response.result;
    } catch (e, stack) {
      debugPrint('Failed to get by list: $e\n$stack');
      throw Exception('Failed to load list associations. Please try again.');
    }
  }

  Future<List<BioskopinaList>> getByMovie(int movieId) async {
    try {
      if (movieId <= 0) {
        throw ArgumentError('Invalid movieId');
      }

      final response = await get(filter: {'MovieId': '$movieId'});
      return response.result;
    } catch (e, stack) {
      debugPrint('Failed to get by movie: $e\n$stack');
      throw Exception('Failed to load movie associations. Please try again.');
    }
  }

  Future<void> updateMovieLists(int movieId, List<BioskopinaList> newLists) async {
    try {
      // Validate inputs
      if (movieId <= 0) throw ArgumentError('Invalid movie ID');
      if (newLists.any((list) => list.listId == null || list.listId! <= 0)) {
        throw ArgumentError('One or more lists have invalid IDs');
      }

      // Get current associations
      final current = await _safeGetByMovie(movieId);
      final currentListIds = current.map((e) => e.listId).toSet();
      final newListIds = newLists.map((e) => e.listId!).toSet();

      // Remove old associations
      final toRemove = current.where((e) => !newListIds.contains(e.listId)).toList();
      await _removeRelationships(toRemove);

      // Add new associations
      final toAdd = newLists.where((list) => !currentListIds.contains(list.listId)).toList();
      await _addRelationships(toAdd);

    } catch (e, stack) {
      debugPrint('updateMovieLists failed: $e\n$stack');
      throw Exception('Failed to update movie lists: ${e.toString()}');
    }
  }

  Future<List<BioskopinaList>> _safeGetByMovie(int movieId) async {
    try {
      return await getByMovie(movieId);
    } catch (e) {
      debugPrint('Failed to fetch current lists: $e');
      return [];
    }
  }

  Future<void> _removeRelationships(List<BioskopinaList> toRemove) async {
    for (var relation in toRemove) {
      try {
        if (relation.id != null) {
          await delete(relation.id!);
        }
      } catch (e) {
        debugPrint('Failed to remove relationship ${relation.id}: $e');
        // Continue with others
      }
    }
  }

  Future<void> _addRelationships(List<BioskopinaList> toAdd) async {
    for (var list in toAdd) {
      try {
        await insert(list);
      } catch (e) {
        debugPrint('Failed to add relationship ${list.listId}: $e');
        // Continue with others
      }
    }
  }

  Future<int> countByMovie(int movieId) async {
    try {
      final response = await get(filter: {'MovieId': '$movieId'});
      return response.result.length;
    } catch (e, stack) {
      debugPrint('Failed to count by movie: $e\n$stack');
      throw Exception('Failed to count movie associations');
    }
  }

  Future<bool> exists(int listId, int movieId) async {
    try {
      final response = await get(filter: {
        'ListId': '$listId',
        'MovieId': '$movieId'
      });
      return response.result.isNotEmpty;
    } catch (e, stack) {
      debugPrint('Failed to check existence: $e\n$stack');
      throw Exception('Failed to check association existence');
    }
  }
}