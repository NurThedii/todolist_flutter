import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../providers/category_provider.dart';
import '../providers/label_provider.dart';
import '../widgets/custom_modal.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<TodoProvider>(context, listen: false).fetchTodos();
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
      Provider.of<LabelProvider>(context, listen: false).fetchLabels();
    });
  }

  void _showAddTodoModal(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(
      context,
      listen: false,
    );
    final labelProvider = Provider.of<LabelProvider>(context, listen: false);
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);

    showDialog(
      context: context,
      builder:
          (context) => CustomModal(
            title: "Tambah Todo",
            fields: [
              CustomModalField(name: "title", label: "Judul"),
              CustomModalField(name: "description", label: "Deskripsi"),
              CustomModalField(
                name: "category_id",
                label: "Kategori",
                type: FieldType.dropdown,
                options:
                    categoryProvider.categories
                        .map((c) => DropdownOption(c.id, c.title))
                        .toList(),
              ),
              CustomModalField(
                name: "label_id",
                label: "Label",
                type: FieldType.dropdown,
                options:
                    labelProvider.labels
                        .map((l) => DropdownOption(l.id, l.title))
                        .toList(),
              ),
              CustomModalField(
                name: "status",
                label: "Status",
                type: FieldType.dropdown,
                options: [
                  DropdownOption(1, "rendah"),
                  DropdownOption(2, "sedang"),
                  DropdownOption(3, "tinggi"),
                ],
              ),
              CustomModalField(
                name: "deadline",
                label: "Deadline",
                type: FieldType.date,
              ),
            ],
            onSubmit: (data) async {
              try {
                // Pastikan category_id dan label_id bertipe int
                int categoryId =
                    (data["category_id"] is int)
                        ? data["category_id"]
                        : int.tryParse(data["category_id"].toString()) ?? 0;

                int labelId =
                    (data["label_id"] is int)
                        ? data["label_id"]
                        : int.tryParse(data["label_id"].toString()) ?? 0;

                int statusIndex =
                    (data["status"] is int)
                        ? data["status"]
                        : int.tryParse(data["status"].toString()) ?? 1;

                // Konversi status menjadi string yang sesuai
                List<String> statusList = ["rendah", "sedang", "tinggi"];
                String statusString =
                    (statusIndex > 0 && statusIndex <= statusList.length)
                        ? statusList[statusIndex - 1]
                        : "rendah"; // Default "rendah" jika terjadi error

                // Pastikan deadline dalam format string yang benar
                String? deadline =
                    (data["deadline"] != null)
                        ? data["deadline"].toString()
                        : null;

                // Debugging sebelum mengirim data ke API
                print("=== Data yang dikirim ===");
                print("Title: ${data["title"]}");
                print("Description: ${data["description"]}");
                print(
                  "Category ID: $categoryId (Type: ${categoryId.runtimeType})",
                );
                print("Label ID: $labelId (Type: ${labelId.runtimeType})");
                print("Status: $statusString (Index: $statusIndex)");
                print("Deadline: $deadline");
                print("==========================");

                // Kirim data ke API
                await todoProvider.addTodo({
                  "title": data["title"],
                  "description": data["description"],
                  "category_id": categoryId,
                  "label_id": labelId,
                  "status": statusString,
                  "deadline": deadline,
                });
                await todoProvider.fetchTodos();
              } catch (e) {
                print("Error adding todo: $e");
              }
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todos"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddTodoModal(context),
          ),
        ],
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          if (todoProvider.todos.isEmpty) {
            return Center(child: Text("Belum ada tugas!"));
          }
          return ListView.builder(
            itemCount: todoProvider.todos.length,
            itemBuilder: (context, index) {
              final todo = todoProvider.todos[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ListTile(
                  title: Text(todo.title),
                  subtitle: Text(todo.description ?? "Tidak ada deskripsi"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      Provider.of<TodoProvider>(
                        context,
                        listen: false,
                      ).deleteTodo(todo.id as int);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
