import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/models/todo_data.dart';
import 'package:todo_app/models/todo_model.dart';

final todoServiceProvider = StateNotifierProvider<TodoService, TodoData>((ref) {
  return TodoService(TodoData(todos: [], categories: []));
});

class TodoService extends StateNotifier<TodoData> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TodoService(super.state);

  // Get all todos
  Future<List<TodoModel>?> getTodos(String userId) async {
    try {
      final QuerySnapshot querySnapshot =
          await _firestore.collection('todos').where('userId', isEqualTo: userId).get();

      final data = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return TodoModel.fromJson(data, id: doc.id);
      }).toList();

      state = state.copyWith(
        todos: data,
        loadingTodos: false,
        categories: state.categories,
        loadingCategories: state.loadingCategories,
      );

      return data;
    } on FirebaseException catch (_) {
      return null;
    }
  }

  // Add todo
  Future<TodoModel?> addTodo(TodoModel todo) async {
    try {
      final createData = todo.toJson();
      createData.remove('id');
      final docRef = await _firestore.collection('todos').add(createData);
      final DocumentSnapshot doc = await docRef.get();
      final data = doc.data() as Map<String, dynamic>;
      final newTodo = TodoModel.fromJson(data, id: doc.id);

      state = state.copyWith(todos: [...state.todos, newTodo], categories: state.categories);

      return newTodo;
    } on FirebaseException catch (_) {
      return null;
    }
  }

  // Update todo
  Future<TodoModel?> updateTodo(TodoModel todo) async {
    try {
      await _firestore.collection('todos').doc(todo.id).update(todo.toJson());

      state = state.copyWith(
        todos: state.todos.map((e) => e.id == todo.id ? todo : e).toList(),
        categories: state.categories,
      );

      return todo;
    } on FirebaseException catch (_) {
      return null;
    }
  }

  // Delete todo
  Future<String?> deleteTodo(String id) async {
    try {
      await _firestore.collection('todos').doc(id).delete();

      state = state.copyWith(
        todos: state.todos.where((e) => e.id != id).toList(),
        categories: state.categories,
      );

      return id;
    } on FirebaseException catch (_) {
      return null;
    }
  }

  // toggle todo
  Future<TodoModel?> toggleTodoDone(String id) async {
    final todo = state.todos.firstWhere((element) => element.id == id);

    try {
      final updatedTodo = todo.copyWith(
        isDone: !todo.isDone,
        updatedAt: DateTime.now().toIso8601String(),
      );

      state = state.copyWith(
        todos: state.todos.map((e) => e.id == id ? updatedTodo : e).toList(),
        categories: state.categories,
      );

      await _firestore.collection('todos').doc(id).update(updatedTodo.toJson());

      return updatedTodo;
    } on FirebaseException catch (_) {
      // undo changes
      state = state.copyWith(
        todos: state.todos.map((e) => e.id == id ? todo : e).toList(),
        categories: state.categories,
      );

      return null;
    } catch (_) {
      // undo changes
      state = state.copyWith(
        todos: state.todos.map((e) => e.id == id ? todo : e).toList(),
        categories: state.categories,
      );

      return null;
    }
  }

  // Get todo by id
  Future<TodoModel?> getTodoById(String id) async {
    try {
      final DocumentSnapshot documentSnapshot = await _firestore.collection('todos').doc(id).get();
      final data = documentSnapshot.data() as Map<String, dynamic>;

      return TodoModel.fromJson(data, id: documentSnapshot.id);
    } on FirebaseException catch (_) {
      return null;
    }
  }

  // Get all categories
  Future<List<TodoCategory>?> getCategories(String userId) async {
    try {
      final QuerySnapshot querySnapshot =
          await _firestore.collection('categories').where('userId', isEqualTo: userId).get();
      final QuerySnapshot querySnapshotPublic =
          await _firestore.collection('todos').where('userId', isEqualTo: "public").get();

      final allResults = [...querySnapshot.docs, ...querySnapshotPublic.docs];

      final data = allResults.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return TodoCategory.fromJson(data, id: doc.id);
      }).toList();

      state = state.copyWith(
        todos: state.todos,
        categories: data,
        loadingCategories: false,
        loadingTodos: state.loadingTodos,
      );

      return data;
    } on FirebaseException catch (_) {
      return null;
    }
  }

  // Add category
  Future<TodoCategory?> addCategory(TodoCategory category) async {
    try {
      final createData = category.toJson();
      createData.remove('id');
      final docRef = await _firestore.collection('categories').add(createData);
      final DocumentSnapshot doc = await docRef.get();
      final data = doc.data() as Map<String, dynamic>;
      final newCategory = TodoCategory.fromJson(data, id: doc.id);

      state = state.copyWith(todos: state.todos, categories: [...state.categories, newCategory]);

      return newCategory;
    } on FirebaseException catch (_) {
      return null;
    }
  }

  // Update category
  Future<TodoCategory?> updateCategory(TodoCategory category) async {
    try {
      await _firestore.collection('categories').doc(category.id).update(category.toJson());

      state = state.copyWith(
        todos: state.todos,
        categories: state.categories.map((e) => e.id == category.id ? category : e).toList(),
      );

      return category;
    } on FirebaseException catch (_) {
      return null;
    }
  }

  // Delete category
  Future<String?> deleteCategory(String id) async {
    try {
      await _firestore.collection('categories').doc(id).delete();

      state = state.copyWith(
        todos: state.todos,
        categories: state.categories.where((e) => e.id != id).toList(),
      );

      return id;
    } on FirebaseException catch (_) {
      return null;
    }
  }

  // Get category by id
  Future<TodoCategory?> getCategoryById(String id) async {
    try {
      final DocumentSnapshot documentSnapshot =
          await _firestore.collection('categories').doc(id).get();
      final data = documentSnapshot.data() as Map<String, dynamic>;

      return TodoCategory.fromJson(data, id: documentSnapshot.id);
    } on FirebaseException catch (_) {
      return null;
    }
  }
}
