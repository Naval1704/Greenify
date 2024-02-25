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
    collection = db!.collection(COLLECTION);
  }

  static Future<void> insertLeafData(
      String uniqueKey, String leafProblem, String leafName, String solution) async {
    await collection.insertOne({
      '_id': uniqueKey,
      'leafproblem': leafProblem,
      'leafname': leafName,
      'solution': solution
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
  String solution,
) async {
  try {
    final response = await collection.update(
      // Use leafName and leafProblem as the filter criteria
      where.eq('leafname', currentLeafName).eq('leafproblem', currentLeafProblem),
      modify.set('leafname', updatedLeafName).set('leafproblem', updatedLeafProblem).set('solution', solution),
    );

    // _logger.debug('Updated ${response.nModified} document(s)');
  } catch (e) {
    // _logger.debug('Update error: $e');
  }
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
        'leafname': leafData['leafname'],
        'leafproblem': leafData['leafproblem'],
      };
    } else {
      return null;
    }
  }
}
