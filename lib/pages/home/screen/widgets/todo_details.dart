import 'package:flutter/material.dart';
import 'package:todo_app/libs/constants.dart';
import 'package:todo_app/models/todo_model.dart';

class TodoDetails extends StatefulWidget {
  final TodoModel todo;
  const TodoDetails({super.key, required this.todo});

  @override
  State<TodoDetails> createState() => _TodoDetailsState();
}

class _TodoDetailsState extends State<TodoDetails> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.92,
          padding: const EdgeInsets.all(Constants.appPaddingX),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: Constants.bgModel,
          ),
          child: Column(
            children: [
              Text(widget.todo.title),
              Text(widget.todo.description ?? ""),
              Text(widget.todo.createdAt ?? ""),
            ],
          ),
        ),
      ),
    );
  }
}
