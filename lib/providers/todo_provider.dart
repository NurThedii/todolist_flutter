import 'package:flutter/material.dart';
import '../../models/todo.dart';
import '../../services/api_service.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];
  final ApiService _apiService = ApiService();

  List<Todo> get todos => _todos;

  Future<void> fetchTodos() async {
    try {
      final response = await _apiService.getTodos();

      print("Response Data: ${response.data}"); // Debugging

      if (response.data == null) {
        throw Exception("Response data is null");
      }

      _todos =
          (response.data as List).map((json) => Todo.fromJson(json)).toList();

      notifyListeners();
    } catch (e) {
      print("Error fetching todos: $e");
    }
  }

  Future<void> addTodo(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.addTodo(data);
      if (response.statusCode == 201) {
        _todos.add(Todo.fromJson(response.data));
        notifyListeners(); // <--- Tambahkan ini
      }
    } catch (e) {
      print("Error adding todo: $e");
    }
  }

  Future<void> updateTodo(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.updateTodo(id as int, data);
      if (response.statusCode == 200) {
        int index = _todos.indexWhere((todo) => todo.id == id);
        if (index != -1) {
          _todos[index] = Todo.fromJson(response.data);
          notifyListeners(); // <--- Tambahkan ini
        }
      }
    } catch (e) {
      print("Error updating todo: $e");
    }
  }

  Future<void> deleteTodo(int id) async {
    // ubah parameter menjadi int
    try {
      final response = await _apiService.deleteTodo(id);
      if (response.statusCode == 200) {
        _todos.removeWhere((todo) => todo.id == id);
        notifyListeners();
      }
    } catch (e) {
      print("Error deleting todo: $e");
    }
  }
}
