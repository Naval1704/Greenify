import 'package:mongo_dart/mongo_dart.dart';
import 'package:greenify/mongo/constant.dart';

class MongoDatabase2 {
  static Db? db;
  static late DbCollection collection;

  static Future<void> connect() async {
    db = await Db.create(MONGO_URL);
    await db!.open();
    var status = db!.serverStatus();
    print(status);
    collection = db!.collection(COLLECTION_USER);
  }

  static Future<void> insertLeafData(
      String username, String email, String phone, String group) async {
    await collection.insertOne({
      '_id': email,
      'username': username,
      'email': email,
      'phone': phone,
      'group': group,
    });
    print("ADDED DATA");
  }

  static Future<Map<String, dynamic>?> fetchLeafDataById(
      String uniqueKey) async {
    return await collection.findOne(where.eq('_id', uniqueKey));
  }
}
