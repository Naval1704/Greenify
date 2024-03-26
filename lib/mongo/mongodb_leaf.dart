import 'package:mongo_dart/mongo_dart.dart';
import 'package:greenify/mongo/constant.dart';

class MongoDatabase {
  static Db? db;
  static late DbCollection collection;

  static Future<void> connect() async {
    db = await Db.create(MONGO_URL);
    await db!.open();
    var status = db!.serverStatus();
    print(status);
    collection = db!.collection(COLLECTION_LEAF);
  }

  static Future<void> insertLeafData(String uniqueKey, String leafProblem,
      String leafName, String solution, bool checked, String date) async {
    await collection.insertOne({
      '_id': uniqueKey,
      'leafproblem': leafProblem,
      'leafname': leafName,
      'solution': solution,
      'checked': checked,
      'date': date,
    });
    print(await collection.find().toList());
  }

  static Future<void> deleteLeafData(String uniqueKey) async {
    await collection.deleteOne({
      '_id': uniqueKey,
    });
    print(await collection.find().toList());
  }

  static Future<void> updateData(
    String currentLeafName,
    String currentLeafProblem,
    String updatedLeafProblem,
    String updatedLeafName,
  ) async {
    try {
      final response = await collection.update(
          // Use leafName and leafProblem as the filter criteria
          where
              .eq('leafname', currentLeafName)
              .eq('leafproblem', currentLeafProblem),
          modify
              .set('leafname', updatedLeafName)
              .set('leafproblem', updatedLeafProblem));

      // _logger.debug('Updated ${response.nModified} document(s)');
    } catch (e) {
      // _logger.debug('Update error: $e');
    }
  }

  static Future<void> updateSolutions(
    String uniqueKey,
    String solution,
    bool checkUpdated,
  ) async {
    try {
      final response = await collection.update(
        // Use uniqueKey as the filter criteria
        where.eq('_id', uniqueKey),
        modify
            .set('solution', solution) // Update solution field
            .set('checked', checkUpdated), // Update checked field
      );
    } catch (e) {
      // Handle update error
      print('Update error: $e');
    }
  }

  static Future<int> getImageCountByUserAndDate(
      String uniqueKey, String date) async {
    final regex = RegExp('^$uniqueKey');
    final count = await collection.count(
      where.eq('_id', regex).eq('date', date),
    );
    return count;
  }

  static Future<Map<String, dynamic>?> fetchLeafDataById(
      String uniqueKey) async {
    return await collection.findOne(where.eq('_id', uniqueKey));
  }

  static Future<Map<String, dynamic>?> fetchLeafNameAndProblemById(
      String uniqueKey) async {
    Map<String, dynamic>? leafData = await fetchLeafDataById(uniqueKey);

    if (leafData != null) {
      return {
        '_id': leafData['_id'],
        'leafname': leafData['leafname'],
        'leafproblem': leafData['leafproblem'],
        'solution': leafData['solution'],
        'checked': leafData['checked'],
        'date': leafData['date'],
      };
    } else {
      return null;
    }
  }
}
