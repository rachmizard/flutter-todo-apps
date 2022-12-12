import 'package:apps_5_crud_firestore/domains/todo/entities/todo_model.dart';
import 'package:apps_5_crud_firestore/domains/todo/repositories/todo_repository.dart';
import 'package:apps_5_crud_firestore/drivers/firestore_driver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

extension on Query<TodoModel> {
  Query<TodoModel> queryBy(List<TodoQuery> queries) {
    if (queries.isNotEmpty) {
      return where("isFinished",
          whereIn: queries
              .map((e) => e == TodoQuery.finished ? true : false)
              .toList());
    }

    return where("isFinished", whereIn: [false, true]);
  }
}

class TodoService implements TodoRepository {
  final firestoreCollection = firestore.collection("todos");

  @override
  getTodos(List<TodoQuery> queries) {
    final todosRef = firestoreCollection.withConverter<TodoModel>(
        fromFirestore: ((snapshot, options) =>
            TodoModel.fromJson(snapshot.data()!)),
        toFirestore: ((todo, options) => todo.toJson(todo)));

    return todosRef.queryBy(queries).snapshots();
  }

  @override
  createTodo(TodoModel todo) async {
    try {
      return await firestoreCollection.add({
        'name': todo.name,
        'isFinished': todo.isFinished,
        'expiredAt': todo.expiredAt
      });
    } catch (error) {
      rethrow;
    }
  }

  @override
  deleteTodo(String id) async {
    try {
      await firestoreCollection.doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }

  @override
  markAsDone(String id, bool currentValue) async {
    try {
      await firestoreCollection.doc(id).update({'isFinished': !currentValue});
    } catch (e) {
      rethrow;
    }
  }
}
