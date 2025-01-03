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

// mode edition
enum Mode { add, edit }

class AddTodo extends ConsumerStatefulWidget {
  final List<TodoCategory> categories;
  final Mode mode;
  final TodoModel? todo;

  const AddTodo({super.key, required this.categories, this.mode = Mode.add, this.todo});

  @override
  ConsumerState<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends ConsumerState<AddTodo> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  int _selectedFlag = 1;
  TodoCategory? _selectedCategory;
  final _formKey = GlobalKey<FormState>();

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
  void didChangeDependencies() {
    super.didChangeDependencies();

    final todoData = ref.read(todoServiceProvider);

    if (todoData.categories.isNotEmpty && _selectedCategory == null) {
      _selectedCategory = todoData.categories.first;
    }
  }

  @override
  void initState() {
    super.initState();

    print(widget.todo?.category);

    if (widget.mode == Mode.edit) {
      _titleController.text = widget.todo!.title;
      _descriptionController.text = widget.todo!.description ?? "";
      _selectedDate = DateTime.parse(widget.todo!.date ?? "");
      _selectedFlag = widget.todo!.priority ?? 1;
      _selectedCategory = widget.todo!.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authServiceProvider);
    final todoService = ref.read(todoServiceProvider.notifier);

    return Form(
      key: _formKey,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              height: 300,
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Title cannot be empty";
                      }

                      if (value.length < 3) {
                        return "Title must be at least 3 characters";
                      }

                      if (value.length > 50) {
                        return "Title must be less than 50 characters";
                      }

                      return null;
                    },
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
                            icon:
                                const Icon(Icons.alarm, color: Color.fromRGBO(255, 255, 255, 0.87)),
                          ),
                          IconButton(
                            onPressed: () {
                              _showCategoryDialog(context);
                            },
                            icon:
                                const Icon(Icons.label, color: Color.fromRGBO(255, 255, 255, 0.87)),
                          ),
                          IconButton(
                            onPressed: () {
                              _showFlagDialog(context);
                            },
                            icon:
                                const Icon(Icons.flag, color: Color.fromRGBO(255, 255, 255, 0.87)),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;

                          if (_selectedCategory == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please select a category"),
                              ),
                            );
                            return;
                          }

                          final todo = TodoModel.fromJson(
                            {
                              "title": _titleController.text,
                              "description": _descriptionController.text,
                              "date": _selectedDate.toIso8601String(),
                              "category": _selectedCategory?.toJson(),
                              "priority": _selectedFlag,
                              "userId": authState.user!.uid,
                              "createdAt": DateTime.now().toIso8601String(),
                              "updatedAt": DateTime.now().toIso8601String(),
                            },
                            id: widget.todo?.id,
                          );

                          if (widget.mode == Mode.edit) {
                            await todoService.updateTodo(todo);
                          } else {
                            await todoService.addTodo(todo);
                          }

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
