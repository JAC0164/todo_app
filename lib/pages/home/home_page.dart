import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/libs/constants.dart';
import 'package:todo_app/models/todo_data.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/pages/home/screen/todo_screen.dart';
import 'package:todo_app/pages/home/screen/widgets/add_todo.dart';
import 'package:todo_app/pages/home/widgets/avatar_widget.dart';
import 'package:todo_app/pages/home/widgets/custom_bottom_navigation_bar.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/services/todo_service.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> buildScreens(TodoData data) {
    return [
      TodoScreen(todos: data.todos),
      const Center(child: Text('Search Page', style: TextStyle(fontSize: 24))),
      const Center(child: Text('Profile Page', style: TextStyle(fontSize: 24))),
      const Center(child: Text('Profile Page', style: TextStyle(fontSize: 24))),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authServiceProvider);
    final todoData = ref.watch(todoServiceProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.sort, color: Color.fromRGBO(255, 255, 255, .87)),
        ),
        actions: [
          AvatarWidget(photoURL: authState.user!.photoURL),
        ],
        title: const Text('Index'),
        centerTitle: true,
        titleTextStyle: GoogleFonts.lato(
          color: const Color.fromRGBO(255, 255, 255, .87),
          fontSize: 20,
        ),
        backgroundColor: Constants.bgColor,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: buildScreens(todoData)[_selectedIndex],
      ),
      backgroundColor: Constants.bgColor,
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTodoDialog(context, todoData.categories);
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        ),
        backgroundColor: Constants.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _showAddTodoDialog(BuildContext context, List<TodoCategory> categories) {
    showDialog(
      context: context,
      builder: (_) => AddTodo(
        categories: categories,
      ),
    );
  }
}
