import 'package:apps_5_crud_firestore/domains/todo/entities/todo_model.dart';
import 'package:apps_5_crud_firestore/domains/todo/repositories/todo_repository.dart';
import 'package:apps_5_crud_firestore/domains/todo/services/todo_service.dart';
import 'package:apps_5_crud_firestore/presentations/todo/widgets/todo_filter_chip_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _formKey = GlobalKey<FormState>();
  List<TodoQuery> _queries = [TodoQuery.unfinished];

  final todoService = TodoService();

  Map<String, dynamic> fields = {
    'name': '',
    'isFinished': false,
    'expiredAt': Timestamp.now()
  };

  Future<void> _submitTodo() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Todo successfully created")));

        await todoService.createTodo(TodoModel.fromJson(fields));
        _formKey.currentState!.reset();
      } catch (e) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed to save due to $e")));
      }
    }
  }

  Future<void> _deleteTodo(String id) async {
    try {
      await todoService.deleteTodo(id);
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to save due to $e")));
    }
  }

  Future<void> _markAsDone(String id, bool currentValue) async {
    try {
      await todoService.markAsDone(id, currentValue);
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to save due to $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo Apps"),
      ),
      body: _todoContainer(),
    );
  }

  Widget _todoForm() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: "Input Your Todo"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onSaved: ((newValue) => setState(() {
                    fields['name'] = newValue;
                  })),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: _submitTodo, child: const Text("Create Todo"))
          ],
        ));
  }

  Widget _todoContainer() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          _todoForm(),
          TodoFilterChipWidget(onFilterChange: ((queries) {
            setState(() {
              _queries = queries;
            });
          })),
          StreamBuilder<QuerySnapshot<TodoModel>>(
            stream: todoService.getTodos(_queries),
            builder: ((context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final data = snapshot.requireData;

              return Column(
                children: data.docs
                    .map((todo) => _todoItem(todo.data(), todo.id))
                    .toList(),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _todoItem(TodoModel todo, String documentId) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(
        todo.expiredAt.millisecondsSinceEpoch);

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.today),
            title: Text(todo.name),
            subtitle: Text(DateFormat('d/MM/yyyy, HH:mm').format(dateTime)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                focusNode: FocusNode(),
                child: Text(
                    !todo.isFinished ? 'Mark as Done' : 'Mark as Undone',
                    style: TextStyle(
                        color: !todo.isFinished ? Colors.blue : Colors.grey)),
                onPressed: () {
                  _markAsDone(documentId, todo.isFinished);
                },
              ),
              const SizedBox(width: 8),
              TextButton(
                child:
                    const Text('Delete', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  _deleteTodo(documentId);
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
