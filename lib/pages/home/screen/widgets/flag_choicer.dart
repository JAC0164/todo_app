import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/libs/constants.dart';

class FlagChoicer extends StatefulWidget {
  final int selectedFlag;
  final void Function(int)? onSelected;

  const FlagChoicer({super.key, required this.selectedFlag, this.onSelected});

  @override
  State<FlagChoicer> createState() => _FlagChoicerState();
}

class _FlagChoicerState extends State<FlagChoicer> {
  int? _selectedFlag;

  @override
  void initState() {
    super.initState();
    _selectedFlag = widget.selectedFlag;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          height: 400,
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
                    "Task Priority",
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
                  GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        final flag = index + 1;
                        final isSelected = _selectedFlag == flag;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedFlag = flag;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? Constants.primaryColor : const Color(0xFF272727),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.flag_outlined,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color.fromRGBO(255, 255, 255, 0.87),
                                  ),
                                  Text(
                                    flag.toString(),
                                    style: GoogleFonts.lato(
                                      fontSize: 20,
                                      color: isSelected
                                          ? Colors.white
                                          : const Color.fromRGBO(255, 255, 255, 0.87),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ],
              )),
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
                      opacity: _selectedFlag == null ? 0.5 : 1,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_selectedFlag == null) return;

                          widget.onSelected?.call(_selectedFlag ?? 1);

                          Navigator.of(context).pop();
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
    );
  }
}
