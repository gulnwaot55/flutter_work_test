import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_work_test/datalist_model.dart';

class DataBaseService {
  DataBaseService._();

  static Future<void> createData(String? text,int number) async {
    final docRef = FirebaseFirestore.instance.collection("Data").doc();

    final data = DataListModel(
      id: docRef.id,
      text: text,
      number: number
    );
    final json = data.toJson();
    docRef.set(json);
    print('$json');
  }
}
