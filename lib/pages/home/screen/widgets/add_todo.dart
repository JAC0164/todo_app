import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/libs/constants.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/pages/home/screen/widgets/category_choicer.dart';
import 'package:todo_app/pages/home/screen/widgets/date_time_choicer.dart';
import 'package:todo_app/pages/home/screen/widgets/flag_choicer.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/widgets/custom_text_field.dart';

class AddTodo extends ConsumerStatefulWidget {
  final List<TodoCategory> categories;

  const AddTodo({super.key, required this.categories});

  @override
  ConsumerState<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends ConsumerState<AddTodo> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  int _selectedFlag = 1;
  TodoCategory? _selectedCategory;

  void _onSelectedCategory(TodoCategory value) {
    setState(() {
      _selectedCategory = value;
    });
  }

  void _onSelectedDate(DateTime value) {
    setState(() {
      _selectedDate = value;
    });
  }

  void _onSelectedFlag(int value) {
    setState(() {
      _selectedFlag = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authServiceProvider);
    final todoService = ref.read(todoServiceProvider.notifier);

    return Center(
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            height: 276,
            width: MediaQuery.of(context).size.width * 0.92,
            padding: const EdgeInsets.all(Constants.appPaddingX),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              color: Constants.bgModel,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add Task",
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color.fromRGBO(255, 255, 255, 0.87),
                  ),
                ),
                CustomTextField(
                  label: "",
                  controller: _titleController,
                  hintText: "Title",
                  validator: (value) => null,
                ),
                const SizedBox(height: 5),
                CustomTextField(
                  label: "",
                  controller: _descriptionController,
                  hintText: "Description",
                  validator: (value) => null,
                  maxLines: 2,
                  minLines: 2,
                  type: TextInputType.multiline,
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            _showDateTimePicker(context);
                          },
                          icon: const Icon(Icons.alarm, color: Color.fromRGBO(255, 255, 255, 0.87)),
                        ),
                        IconButton(
                          onPressed: () {
                            _showCategoryDialog(context);
                          },
                          icon: const Icon(Icons.label, color: Color.fromRGBO(255, 255, 255, 0.87)),
                        ),
                        IconButton(
                          onPressed: () {
                            _showFlagDialog(context);
                          },
                          icon: const Icon(Icons.flag, color: Color.fromRGBO(255, 255, 255, 0.87)),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () async {
                        final todo = TodoModel.fromJson(
                          {
                            "title": _titleController.text,
                            "description": _descriptionController.text,
                            "date": _selectedDate?.toIso8601String(),
                            "category": _selectedCategory?.toJson(),
                            "priority": _selectedFlag,
                            "userId": authState.user!.uid,
                            "createdAt": DateTime.now().toIso8601String(),
                            "updatedAt": DateTime.now().toIso8601String(),
                          },
                        );

                        await todoService.addTodo(todo);

                        if (context.mounted) Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.send, color: Color.fromRGBO(255, 255, 255, 0.87)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showDateTimePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return DateTimeChoicer(
          onSelected: _onSelectedDate,
          selectedDate: _selectedDate,
        );
      },
    );
  }

  _showFlagDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FlagChoicer(
        onSelected: _onSelectedFlag,
        selectedFlag: _selectedFlag,
      ),
    );
  }

  _showCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CategoryChoicer(
        onSelected: _onSelectedCategory,
        selectedIcon: _selectedCategory,
      ),
    );
  }
}
