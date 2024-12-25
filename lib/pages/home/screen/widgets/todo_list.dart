import 'package:flutter/material.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/pages/home/screen/widgets/todo_card.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:todo_app/pages/home/screen/widgets/todo_details.dart';

class TodoList extends StatelessWidget {
  final List<TodoModel> todos;
  final bool loading;
  final String search;
  final List<String> filters;

  const TodoList({
    super.key,
    required this.todos,
    required this.search,
    required this.filters,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    final filteredTodos = todos.where((todo) {
      final isSearchMatch = todo.title.toLowerCase().contains(search.toLowerCase()) ||
          (todo.description ?? '').toLowerCase().contains(search.toLowerCase());

      final date = DateTime.parse(todo.date ?? "");
      final now = DateTime.now();
      final isToday = date.day == now.day && date.month == now.month && date.year == now.year;
      final isStatusFilter = filters.contains("active") || filters.contains("completed");
      final isTodayFilter = filters.contains("today");

      if (isStatusFilter && isTodayFilter) {
        return isSearchMatch && isToday && filters.contains("completed")
            ? todo.isDone
            : !todo.isDone;
      }

      if (isStatusFilter) {
        return isSearchMatch && filters.contains("completed") ? todo.isDone : !todo.isDone;
      }

      if (isTodayFilter) {
        return isSearchMatch && isToday;
      }

      return isSearchMatch;
    }).toList();

    return Skeletonizer(
      effect: ShimmerEffect(
        baseColor: Colors.grey[600]!,
        highlightColor: Colors.grey[400]!,
        duration: const Duration(seconds: 1),
      ),
      enabled: loading,
      child: ListView.builder(
        itemCount: loading ? 10 : filteredTodos.length,
        itemBuilder: (context, index) {
          final TodoModel todo = loading ? TodoModel(id: "", title: "") : filteredTodos[index];

          return GestureDetector(
            onTap: () {
              if (!loading) _showTodoDetails(todo, context);
            },
            child: TodoCard(
              todo: todo,
              isSkeleton: loading,
            ),
          );
        },
      ),
    );
  }

  void _showTodoDetails(TodoModel todo, BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => TodoDetails(
        todo: todo,
      ),
    );
  }
}
