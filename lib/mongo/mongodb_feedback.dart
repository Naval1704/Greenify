import 'package:mongo_dart/mongo_dart.dart';
import 'package:greenify/mongo/constant.dart';

class MongoDatabase3 {
  static Db? db;
  static late DbCollection collection;

  static Future<void> connect() async {
    db = await Db.create(MONGO_URL);
    await db!.open();
    var status = db!.serverStatus();
    print(status);
    collection = db!.collection(COLLECTION_FORM);
  }

  static Future<void> insertFeedbackData(String userId, String feedback) async {
    await collection.insertOne({
      'id':userId,
      'userId': userId,
      'feedback': feedback,
      'timestamp': DateTime.now(),
    });
    print("ADDED FEEDBACK DATA");
  }

  static Future<Map<String, dynamic>?> fetchLeafDataById(
      String uniqueKey) async {
    return await collection.findOne(where.eq('_id', uniqueKey));
  }
}
