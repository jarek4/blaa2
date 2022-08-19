import 'package:flutter/material.dart';

void showSnack(BuildContext context, String? msg) {
  final SnackBar _snack = SnackBar(content: Text(msg ?? 'Ups, something went wrong'));
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(_snack);
}