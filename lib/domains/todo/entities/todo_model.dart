import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String name;
  bool isFinished;
  Timestamp expiredAt;

  TodoModel(
      {required this.name, this.isFinished = false, required this.expiredAt});

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
        name: json['name'],
        expiredAt: json['expiredAt'],
        isFinished: json['isFinished']);
  }

  toJson(TodoModel todo) {
    return {
      name: todo.name,
      expiredAt: todo.expiredAt,
      isFinished: todo.isFinished
    };
  }
}
