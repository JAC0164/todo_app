import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/libs/extensions.dart';

class CustomColorPicker extends StatefulWidget {
  final String label;
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType type;
  final String? initialValue;
  final int? maxLines;
  final int? minLines;
  final void Function(String)? onSelected;

  const CustomColorPicker({
    super.key,
    required this.label,
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.initialValue,
    this.type = TextInputType.text,
    this.maxLines = 1,
    this.minLines = 1,
    this.onSelected,
  });

  @override
  State<CustomColorPicker> createState() => _CustomColorPickerState();
}

class _CustomColorPickerState extends State<CustomColorPicker> {
  final List<String> _colors = [
    '#C9CC41',
    '#66CC41',
    '#41CCA7',
    '#4181CC',
    '#41A2CC',
    '#CC8441',
    '#9741CC',
    '#CC4173',
    '#CC4141',
    '#CC41A2',
  ];
  String? _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label.isNotEmpty)
            Text(
              widget.label,
              style: GoogleFonts.lato(
                color: const Color.fromRGBO(255, 255, 255, .87),
                fontSize: 16,
              ),
            ),
          const SizedBox(height: 8),
          SizedBox(
            height: 36,
            width: double.infinity,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _colors.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = _colors[index];
                      widget.onSelected!(_selectedColor!);
                    });
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: _colors[index].toColor(),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: _selectedColor == _colors[index]
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
