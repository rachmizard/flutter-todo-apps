import 'package:apps_5_crud_firestore/domains/todo/entities/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum TodoQuery {
  finished,
  unfinished,
}

abstract class TodoRepository {
  Stream<QuerySnapshot<TodoModel>> getTodos(List<TodoQuery> query);
  Future<void> markAsDone(String id, bool currentValue);
  Future<DocumentReference<Map<String, dynamic>>> createTodo(TodoModel todo);
  Future<void> deleteTodo(String id);
}
