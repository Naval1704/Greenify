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

  static Future<void> insertLeafData(String leafProblem, String leafName) async {
    await collection.insertOne({
      '_id': ObjectId(),
      'leafproblem': leafProblem,
      'leafname': leafName,
    });
    print(await collection.find().toList());
  }
}
