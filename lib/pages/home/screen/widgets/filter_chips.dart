import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/libs/constants.dart';
import 'package:todo_app/libs/extensions.dart';

class FilterChips extends StatelessWidget {
  final List<String> filters;
  final List<String> selectedFilter;
  final ValueChanged<List<String>> onFilterChanged;

  const FilterChips({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 31,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter.contains(filter);

          return GestureDetector(
            onTap: () {
              final updatedFilters = List<String>.from(selectedFilter);

              if (filter == "all") {
                onFilterChanged(["all"]);
                return;
              }

              updatedFilters.remove("all");

              if (isSelected) {
                updatedFilters.remove(filter);
              } else {
                updatedFilters.add(filter);

                if (filter == "active" && updatedFilters.contains("completed")) {
                  updatedFilters.remove("completed");
                } else if (filter == "completed" && updatedFilters.contains("active")) {
                  updatedFilters.remove("active");
                }
              }

              onFilterChanged(updatedFilters.isEmpty ? ["all"] : updatedFilters);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              decoration: BoxDecoration(
                color:
                    isSelected ? Constants.primaryColor : const Color.fromRGBO(255, 255, 255, .2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  filter.capitalize(),
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
