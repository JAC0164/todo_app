import 'package:todo_app/models/todo_model.dart';

class TodoData {
  List<TodoModel> todos = [];
  List<TodoCategory> categories = [];
  bool loadingTodos = false;
  bool loadingCategories = false;

  TodoData({required this.todos, required this.categories});

  TodoData.fromJson(Map<String, dynamic> json) {
    if (json['todos'] != null) {
      todos = <TodoModel>[];
      json['todos'].forEach((v) {
        todos.add(TodoModel.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = <TodoCategory>[];
      json['categories'].forEach((v) {
        categories.add(TodoCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['todos'] = todos.map((v) => v.toJson()).toList();
    data['categories'] = categories.map((v) => v.toJson()).toList();
    return data;
  }

  TodoData copyWith({
    List<TodoModel>? todos,
    List<TodoCategory>? categories,
    bool? loadingTodos,
    bool? loadingCategories,
  }) {
    return TodoData(
      todos: todos ?? this.todos,
      categories: categories ?? this.categories,
    );
  }

  @override
  String toString() {
    return 'TodoData{todos: $todos, categories: $categories}';
  }
}
