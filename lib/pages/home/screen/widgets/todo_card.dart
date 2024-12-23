import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/libs/constants.dart';
import 'package:todo_app/libs/extensions.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/services/todo_service.dart';

String formatDate(String? date) {
  if (date == null) return '';

  final DateTime dateTime = DateTime.parse(date);
  final DateTime now = DateTime.now();
  final Duration difference = now.difference(dateTime);
  final isToday =
      now.day == dateTime.day && now.month == dateTime.month && now.year == dateTime.year;

  final String time =
      "${dateTime.hour < 10 ? '0' : ''}${dateTime.hour}:${dateTime.minute < 10 ? '0' : ''}${dateTime.minute}";
  if (difference.inDays == 0 && isToday) {
    return 'Today at $time';
  } else if (difference.inDays == 1 || (difference.inDays == 0 && !isToday)) {
    return 'Yesterday at $time';
  } else if (difference.inDays == -1) {
    return 'Tomorrow at $time';
  } else if (difference.isNegative) {
    return '${difference.inDays.abs()} days from now';
  } else {
    return '${difference.inDays} days ago';
  }
}

class TodoCard extends ConsumerStatefulWidget {
  final TodoModel todo;

  const TodoCard({super.key, required this.todo});

  @override
  ConsumerState<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends ConsumerState<TodoCard> {
  @override
  Widget build(BuildContext context) {
    final todoService = ref.read(todoServiceProvider.notifier);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF363636),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Check box
          GestureDetector(
            onTap: () async {
              await todoService.toggleTodoDone(widget.todo.id);
            },
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: widget.todo.isDone ? Constants.primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(59),
                border: Border.all(color: Constants.primaryColor),
              ),
              child: widget.todo.isDone
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.todo.title,
                  style: GoogleFonts.lato(
                    color: const Color.fromRGBO(255, 255, 255, 0.87),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatDate(widget.todo.createdAt),
                      style: GoogleFonts.lato(
                        color: const Color(0xFFAFAFAF),
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: widget.todo.category?.color?.toColor() ?? Constants.primaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(children: [
                            Icon(
                              IconData(widget.todo.category?.icon ?? 0,
                                  fontFamily: 'MaterialIcons'),
                              color: Colors.white,
                              size: 12,
                            ),
                            const SizedBox(width: 5),
                            Text(widget.todo.category?.name ?? "",
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 12,
                                )),
                          ]),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF363636),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Constants.primaryColor),
                          ),
                          child: Row(children: [
                            const Icon(
                              Icons.flag,
                              color: Colors.white,
                              size: 12,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              widget.todo.priority.toString(),
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
