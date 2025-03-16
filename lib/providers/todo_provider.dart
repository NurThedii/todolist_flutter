import 'package:flutter/material.dart';
import 'package:todolist_flutter/models/category.dart';
import 'package:todolist_flutter/models/label.dart';
import '../../models/todo.dart';
import '../../models/category.dart';
import '../../services/api_service.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];
  // Simpan daftar kategori dan label secara global
  List<Category> categories = [];
  List<Label> labels = [];
  final ApiService _apiService = ApiService();

  List<Todo> get todos => _todos;
  Future<void> fetchTodos() async {
    try {
      final response = await _apiService.getTodos();

      print("Response Data: ${response.data}"); // 🔥 Debugging

      if (response.data == null || response.data.isEmpty) {
        throw Exception("Response data is null atau kosong");
      }

      // Pastikan response.data adalah List
      if (response.data is! List) {
        throw Exception("Response data bukan List");
      }

      _todos =
          (response.data as List).map((json) {
            if (json is! Map<String, dynamic>) {
              throw Exception("Data tidak sesuai format");
            }
            return Todo.fromJson(json);
          }).toList();

      notifyListeners();
    } catch (e) {
      print("Error fetching todos: $e"); // 🔥 Debugging
    }
  }

  Future<void> addTodo(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.addTodo(data);

      if (response.statusCode == 201) {
        final todoJson = response.data;

        Todo newTodo = Todo.fromJson(todoJson); // 🔥 Gunakan parsing dari model

        _todos.add(newTodo);
        notifyListeners(); // 🔥 Update UI setelah menambahkan todo
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
