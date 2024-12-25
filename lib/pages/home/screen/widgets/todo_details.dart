import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/libs/constants.dart';
import 'package:todo_app/libs/extensions.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/pages/home/screen/widgets/todo_card.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:collection/collection.dart';

class Details extends StatefulWidget {
  final String title;
  final IconData titleIcon;
  final String dataTile;
  final IconData? dataIcon;
  final String? dataIconColor;

  const Details({
    super.key,
    required this.title,
    required this.titleIcon,
    required this.dataTile,
    this.dataIcon,
    this.dataIconColor,
  });

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              widget.titleIcon,
              color: const Color(0xFFAFAFAF),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              "${widget.title} :",
              style: GoogleFonts.lato(
                color: const Color.fromRGBO(255, 255, 255, 0.87),
                fontSize: 18,
              ),
            ),
          ],
        ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF444444),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                if (widget.dataIcon != null) ...[
                  Icon(
                    widget.dataIcon,
                    color: widget.dataIconColor?.toColor(),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.dataTile,
                  style: GoogleFonts.lato(
                    color: const Color.fromRGBO(255, 255, 255, .87),
                    fontSize: 12,
                  ),
                ),
              ],
            ))
      ],
    );
  }
}

class TodoDetails extends ConsumerStatefulWidget {
  final TodoModel todo;
  const TodoDetails({super.key, required this.todo});

  @override
  ConsumerState<TodoDetails> createState() => _TodoDetailsState();
}

class _TodoDetailsState extends ConsumerState<TodoDetails> {
  @override
  Widget build(BuildContext context) {
    final todoData = ref.watch(todoServiceProvider);

    final todo = todoData.todos.firstWhereOrNull((element) => element.id == widget.todo.id);

    if (todo == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.92,
          height: MediaQuery.of(context).size.height * 0.92,
          padding: const EdgeInsets.all(Constants.appPaddingX),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: Constants.bgColor,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: Color(0xFF1D1D1D),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xFFFFFFFF),
                        size: 16,
                      ),
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: Color(0xFF1D1D1D),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.repeat,
                        color: Color(0xFFFFFFFF),
                        size: 16,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await ref.read(todoServiceProvider.notifier).toggleTodoDone(todo.id);
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: todo.isDone ? Constants.primaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(59),
                        border: Border.all(color: Constants.primaryColor),
                      ),
                      child: todo.isDone
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.title,
                        style: GoogleFonts.lato(
                          color: const Color.fromRGBO(255, 255, 255, 0.87),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        todo.description ?? "",
                        style: GoogleFonts.lato(
                          color: const Color(0xFFAFAFAF),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.edit_square,
                      color: Color(0xFFAFAFAF),
                      size: 20,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 38),
              Details(
                title: "Task Time",
                titleIcon: Icons.timer_outlined,
                dataTile: formatDate(todo.date),
              ),
              const SizedBox(height: 34),
              Details(
                title: "Task Category",
                titleIcon: Icons.label_outline,
                dataTile: todo.category?.name ?? "",
                dataIcon: IconData(
                  todo.category?.icon ?? 0xe900,
                  fontFamily: 'MaterialIcons',
                ),
                dataIconColor: todo.category?.color,
              ),
              const SizedBox(height: 34),
              Details(
                title: "Task Priority",
                titleIcon: Icons.flag_outlined,
                dataTile: todo.priority.toString(),
              ),
              const SizedBox(height: 34),
              GestureDetector(
                onTap: () async {
                  await ref.read(todoServiceProvider.notifier).deleteTodo(todo.id);
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Delete Task",
                          style: GoogleFonts.lato(
                            color: Colors.red,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Container()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
