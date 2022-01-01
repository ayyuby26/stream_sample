import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../bloc/cart_bloc.dart';

// buat collection/database
final users = FirebaseFirestore.instance.collection('users');

final products = FirebaseFirestore.instance.collection("products");

final cartBloc = CartBloc();

String currencyFormat(int x) {
  final _temp = NumberFormat("#,##0", "ID_id");
  return _temp.format(x);
}

void movePage(BuildContext context, Widget widget) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
  );
}
