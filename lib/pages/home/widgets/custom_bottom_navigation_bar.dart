import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: const Color(0xFF363636),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: IconButton(
              icon: const Icon(Icons.home, size: 28),
              onPressed: () => onItemTapped(0),
              color: selectedIndex == 0 ? const Color.fromRGBO(255, 255, 255, .87) : Colors.grey,
            ),
          ),
          Expanded(
            child: IconButton(
              icon: const Icon(Icons.calendar_today_sharp, size: 28),
              onPressed: () => onItemTapped(1),
              color: selectedIndex == 1 ? const Color.fromRGBO(255, 255, 255, .87) : Colors.grey,
            ),
          ),
          const Expanded(
            child: Text(''),
          ),
          Expanded(
            child: IconButton(
              icon: const Icon(Icons.timelapse_sharp, size: 28),
              onPressed: () => onItemTapped(2),
              color: selectedIndex == 2 ? const Color.fromRGBO(255, 255, 255, .87) : Colors.grey,
            ),
          ),
          Expanded(
            child: IconButton(
              icon: const Icon(Icons.person_2, size: 28),
              onPressed: () => onItemTapped(3),
              color: selectedIndex == 3 ? const Color.fromRGBO(255, 255, 255, .87) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
