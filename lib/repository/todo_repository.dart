///get - ListTodo
///post - CreateTodo
///delete - DeleteTodo
import 'package:bloc_tutorial/model/todo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';

class TodoRepository {
  Future<List<Map<String, dynamic>>> listTodo() async {
    await Future.delayed(Duration(seconds: 1));

    return [
      {
        'id': 1,
        'title': 'Flutter 배우기',
        'createdAt': DateTime.now().toString(),
      },
      {
        'id': 2,
        'title': 'Dart 배우기',
        'createdAt': DateTime.now().toString(),
      },
    ];
  }

  Future<Map<String, dynamic>> createTodo(Todo todo) async {
    /// body - request - response - return
    await Future.delayed(Duration(seconds: 1));

    return todo.toJson();
  }

  Future<Map<String, dynamic>> deleteTodo(Todo todo) async {
    await Future.delayed(Duration(seconds: 1));

    return todo.toJson();
  }
}