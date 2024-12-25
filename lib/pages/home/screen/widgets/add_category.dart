import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/libs/constants.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/widgets/custom_color_picker.dart';
import 'package:todo_app/widgets/custom_icon_button_picker.dart';
import 'package:todo_app/widgets/custom_text_field.dart';

class AddCategory extends ConsumerStatefulWidget {
  const AddCategory({super.key});

  @override
  ConsumerState<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends ConsumerState<AddCategory> {
  final _nameController = TextEditingController();
  int? _selectedIcon;
  String? _selectedColor;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final todoService = ref.read(todoServiceProvider.notifier);
    final authState = ref.watch(authServiceProvider);

    return Form(
      key: _formKey,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.92,
            padding: const EdgeInsets.all(Constants.appPaddingX),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Constants.bgModel,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create new category",
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
                  child: SizedBox(
                    child: Column(
                      children: [
                        CustomTextField(
                          label: "Category name :",
                          controller: _nameController,
                          hintText: "Category name",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter category name";
                            }

                            if (value.length < 3) {
                              return "Category name must be at least 3 characters";
                            }

                            if (value.length > 25) {
                              return "Category name must be less than 25 characters";
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomIconButtonPicker(
                          label: "Category icon :",
                          hintText: "Choose icon from library",
                          initialValue: _selectedIcon,
                          onSelected: (value) {
                            setState(() {
                              _selectedIcon = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomColorPicker(
                          label: "Category color :",
                          hintText: "Choose color",
                          initialValue: _selectedColor,
                          onSelected: (value) {
                            setState(() {
                              _selectedColor = value;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Constants.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Opacity(
                        opacity: _nameController.text.isEmpty ||
                                _selectedIcon == null ||
                                _selectedColor == null
                            ? 0.5
                            : 1,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_nameController.text.isEmpty) return;
                            if (_selectedIcon == null) return;
                            if (_selectedColor == null) return;
                            if (authState.user == null) return;

                            final category = TodoCategory.fromJson(
                              {
                                "name": _nameController.text,
                                "icon": _selectedIcon,
                                "color": _selectedColor,
                                "userId": authState.user!.uid,
                                "createdAt": DateTime.now().toIso8601String(),
                                "updatedAt": DateTime.now().toIso8601String(),
                              },
                            );

                            await todoService.addCategory(category);

                            if (context.mounted) Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Constants.primaryColor,
                          ),
                          child: Text(
                            "Save",
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
      ),
    );
  }
}
