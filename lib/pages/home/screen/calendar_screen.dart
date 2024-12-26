import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/libs/constants.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/pages/home/screen/widgets/todo_list.dart';
import 'package:calendar_timeline/calendar_timeline.dart';

class CalendarScreen extends StatefulWidget {
  final List<TodoModel> todos;
  final bool loading;

  const CalendarScreen({super.key, required this.todos, required this.loading});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<String> _selectedFilter = ["all"];
  String _selected = "today";
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
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
          const SizedBox(height: 10),
          CalendarTimeline(
            initialDate: _selectedDate,
            firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
            lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
            activeBackgroundDayColor: Constants.primaryColor,
            activeDayColor: Colors.white,
            dayColor: Colors.white,
            monthColor: Colors.white,
            fontSize: 12,
            height: 56,
            width: 40,
            eventDates: widget.todos.map((e) => DateTime.parse(e.date ?? "")).toList(),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF4C4C4C),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selected = "today";
                        _selectedFilter = ["all"];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selected == "today" ? Constants.primaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                        border: _selected == "today"
                            ? Border.all(color: Colors.transparent, width: 1)
                            : Border.all(color: const Color(0xFF979797), width: 1),
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Center(
                          child: Text(
                        "Today",
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      )),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selected = "completed";
                        _selectedFilter = ["all", "active"];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            _selected == "completed" ? Constants.primaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                        border: _selected == "completed"
                            ? Border.all(color: Colors.transparent, width: 1)
                            : Border.all(color: const Color(0xFF979797), width: 1),
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Center(
                          child: Text(
                        "Completed",
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      )),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TodoList(
              todos: widget.todos,
              search: "",
              filters: _selectedFilter,
              loading: widget.loading,
              filterDate: _selectedDate,
            ),
          ),
        ],
      ),
    );
  }
}
