import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/libs/constants.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/pages/home/screen/widgets/filter_chips.dart';
import 'package:todo_app/pages/home/screen/widgets/todo_list.dart';
import 'package:todo_app/widgets/custom_text_field.dart';

class TodoScreen extends StatefulWidget {
  final List<TodoModel> todos;
  final bool loading;

  const TodoScreen({super.key, required this.todos, required this.loading});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _searchController = TextEditingController();
  final List<String> _filters = ["all", "today", "active", "completed"];
  List<String> _selectedFilter = ["all"];
  String _search = "";

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _search = _searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.todos.isEmpty && !widget.loading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/checklist_rafiki.png"),
            const SizedBox(height: 10),
            Text(
              "What do you want to do today?",
              style: GoogleFonts.lato(
                fontSize: 20,
                color: const Color.fromRGBO(255, 255, 255, .87),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Tap + to add your tasks",
              style: GoogleFonts.lato(
                fontSize: 18,
                color: const Color.fromRGBO(255, 255, 255, .87),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Constants.appPaddingX),
      child: Column(
        children: [
          CustomTextField(
            label: "",
            controller: _searchController,
            hintText: "Search for your task...",
            validator: (value) => null,
            prefixIcon: const Icon(Icons.search),
          ),
          const SizedBox(height: 18),
          FilterChips(
            filters: _filters,
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
            },
          ),
          const SizedBox(height: 18),
          Expanded(
            child: TodoList(
              todos: widget.todos,
              search: _search,
              filters: _selectedFilter,
              loading: widget.loading,
            ),
          ),
        ],
      ),
    );
  }
}
