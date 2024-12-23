import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/pages/home/screen/widgets/icon_picker.dart';

class CustomIconButtonPicker extends StatefulWidget {
  final String label;
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType type;
  final int? initialValue;
  final int? maxLines;
  final int? minLines;
  final void Function(int)? onSelected;

  const CustomIconButtonPicker({
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
  State<CustomIconButtonPicker> createState() => _CustomIconButtonPickerState();
}

class _CustomIconButtonPickerState extends State<CustomIconButtonPicker> {
  int? _selectedIcon;

  @override
  void initState() {
    super.initState();
    _selectedIcon = widget.initialValue;
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
          GestureDetector(
            onTap: () {
              _showIconPicker(context);
            },
            child: Container(
              child: _selectedIcon == null
                  ? TextFormField(
                      obscureText: widget.obscureText,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: widget.type,
                      minLines: widget.minLines,
                      enabled: false,
                      maxLines: widget.maxLines,
                      decoration: InputDecoration(
                        labelText: widget.hintText,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        fillColor: const Color.fromRGBO(255, 255, 255, 0.21),
                        filled: true,
                        labelStyle: GoogleFonts.lato(
                          color: const Color.fromRGBO(255, 255, 255, 0.87),
                          fontSize: 16,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF535353)),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF535353)),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        suffixIcon: widget.suffixIcon,
                        prefixIcon: widget.prefixIcon,
                      ),
                    )
                  : Container(
                      width: 50,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 255, 255, 0.21),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        IconData(_selectedIcon!, fontFamily: 'MaterialIcons'),
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _showIconPicker(BuildContext context) async {
    final icon = await showDialog(
      context: context,
      builder: (context) => IconPicker(
        selectedIcon: _selectedIcon,
      ),
    );

    if (icon != null) {
      setState(() {
        _selectedIcon = icon.codePoint;
      });

      if (widget.onSelected != null) {
        widget.onSelected!(icon.codePoint);
      }

      // unfocus the text field
      if (context.mounted) FocusScope.of(context).unfocus();
    }
  }
}
