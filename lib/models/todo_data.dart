import 'package:todo_app/models/todo_model.dart';

class TodoData {
  List<TodoModel> todos = [];
  List<TodoCategory> categories = [];
  bool loadingTodos = true;
  bool loadingCategories = true;

  TodoData({
    required this.todos,
    required this.categories,
    this.loadingTodos = true,
    this.loadingCategories = true,
  });

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
      loadingTodos: loadingTodos ?? this.loadingTodos,
      loadingCategories: loadingCategories ?? this.loadingCategories,
    );
  }

  @override
  String toString() {
    return 'TodoData{todos: $todos, categories: $categories}';
  }
}
