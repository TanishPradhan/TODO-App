import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'list_model.g.dart';

@HiveType(typeId: 0)
class ListModel extends HiveObject {
  @HiveField(0)
  String? title;
  @HiveField(1)
  bool value;
  ListModel({this.title, required this.value});
}