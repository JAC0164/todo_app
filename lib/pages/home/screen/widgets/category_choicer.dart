import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/libs/constants.dart';
import 'package:todo_app/libs/extensions.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/pages/home/screen/widgets/add_category.dart';
import 'package:todo_app/services/todo_service.dart';

class CategoryChoicer extends ConsumerStatefulWidget {
  final TodoCategory? selectedIcon;
  final void Function(TodoCategory)? onSelected;

  const CategoryChoicer({
    super.key,
    required this.selectedIcon,
    this.onSelected,
  });

  @override
  ConsumerState<CategoryChoicer> createState() => _CategoryChoicerState();
}

class _CategoryChoicerState extends ConsumerState<CategoryChoicer> {
  TodoCategory? _selectedCategory;
  //
  bool isAdaptive = true;
  bool showTooltips = false;
  bool showSearch = true;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedIcon;
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(todoServiceProvider).categories;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          height: 700,
          width: MediaQuery.of(context).size.width * 0.92,
          padding: const EdgeInsets.all(Constants.appPaddingX),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Constants.bgModel,
          ),
          child: Column(
            children: [
              Expanded(
                  child: Column(
                children: [
                  Text(
                    "Choose Category",
                    style: GoogleFonts.lato(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromRGBO(255, 255, 255, 0.87),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Divider(
                    color: Color(0xFF979797),
                    thickness: 1,
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final isSelected = _selectedCategory?.id == categories[index].id;

                        final TodoCategory category = categories[index];

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = category;
                            });

                            widget.onSelected?.call(category);

                            Navigator.pop(context);
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: category.color?.toColor() ?? Constants.primaryColor,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: isSelected ? Colors.white : Colors.transparent,
                                    width: 1,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: Colors.white.withOpacity(0.8),
                                            blurRadius: 10,
                                            offset: const Offset(0, 5),
                                          )
                                        ]
                                      : null,
                                ),
                                width: 64,
                                height: 64,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        IconData(category.icon ?? 0, fontFamily: 'MaterialIcons'),
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                category.name,
                                style: GoogleFonts.lato(
                                  fontSize: 12,
                                  color: const Color.fromRGBO(255, 255, 255, 0.87),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Opacity(
                      opacity: _selectedCategory == null ? 0.5 : 1,
                      child: ElevatedButton(
                        onPressed: () {
                          _showAddCategory(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Constants.primaryColor,
                        ),
                        child: Text(
                          "Add Category",
                          style: GoogleFonts.lato(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showAddCategory(BuildContext context) {
    showDialog(context: context, builder: (context) => const AddCategory());
  }
}
