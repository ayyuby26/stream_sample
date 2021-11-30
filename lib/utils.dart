import 'package:cloud_firestore/cloud_firestore.dart';

// buat collection/database
final users = FirebaseFirestore.instance.collection('users');
