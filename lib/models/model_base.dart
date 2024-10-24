import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ModelBase {
   static final FirebaseFirestore db = FirebaseFirestore.instance;


  static String get uid {
    return db.collection('user1').doc().id;
  }
}
