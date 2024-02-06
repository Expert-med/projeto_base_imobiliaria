import 'package:cloud_firestore/cloud_firestore.dart';

class BuscasLocaisArm {
  Future<List<Map<String, dynamic>>> fetchSubLocals(
      DocumentReference localArmDoc) async {
        print('entrou');
    QuerySnapshot subLocaisSnapshot =
        await localArmDoc.collection('sublocais').get();
    return subLocaisSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}
