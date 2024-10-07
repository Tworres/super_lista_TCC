import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class ModelBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String _authId = '1';

  String get table;

  add() {
    _firestore.doc(table).set(this);
  }
}
