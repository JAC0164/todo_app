import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/libs/constants.dart';
import 'package:time_picker_spinner/time_picker_spinner.dart';

class DateTimeChoicer extends StatefulWidget {
  final DateTime? selectedDate;
  final void Function(DateTime)? onSelected;

  const DateTimeChoicer({super.key, this.selectedDate, this.onSelected});

  @override
  State<DateTimeChoicer> createState() => _DateTimeChoicerState();
}

class _DateTimeChoicerState extends State<DateTimeChoicer> {
  DateTime? _selectedDate;
  int _step = 0;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
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
              if (_step == 0)
                Expanded(
                  child: SfDateRangePicker(
                    view: DateRangePickerView.month,
                    selectionMode: DateRangePickerSelectionMode.single,
                    backgroundColor: Constants.bgModel,
                    initialSelectedDate: _selectedDate,
                    onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                      final value = args.value;

                      if (value is DateTime) {
                        setState(() {
                          _selectedDate = value;
                        });
                      }
                    },
                    // color text
                    monthCellStyle: DateRangePickerMonthCellStyle(
                      textStyle: GoogleFonts.lato(
                        color: const Color.fromRGBO(255, 255, 255, 0.87),
                      ),
                    ),
                    // color header
                    headerStyle: DateRangePickerHeaderStyle(
                      textStyle: GoogleFonts.lato(
                        color: const Color.fromRGBO(255, 255, 255, 0.87),
                      ),
                      backgroundColor: Constants.bgModel,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              if (_step == 1)
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "Choose Time",
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          color: const Color.fromRGBO(255, 255, 255, 0.87),
                        ),
                      ),
                      TimePickerSpinner(
                        locale: const Locale('en', ''),
                        time: _selectedDate,
                        is24HourMode: false,
                        isShowSeconds: true,
                        itemHeight: 80,
                        normalTextStyle: const TextStyle(
                          fontSize: 24,
                          color: Color.fromRGBO(255, 255, 255, 0.87),
                        ),
                        highlightedTextStyle: const TextStyle(
                          fontSize: 24,
                          color: Constants.primaryColor,
                        ),
                        isForce2Digits: true,
                        onTimeChange: (time) {
                          setState(() {
                            _selectedDate = time;
                          });
                        },
                      )
                    ],
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (_step == 0) {
                          Navigator.of(context).pop();
                        } else {
                          setState(() {
                            _step--;
                          });
                        }
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
                      opacity: _selectedDate == null ? 0.5 : 1,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_selectedDate == null) return;

                          if (_step == 1) {
                            widget.onSelected?.call(_selectedDate!);
                            Navigator.of(context).pop(_selectedDate);
                            return;
                          }

                          setState(() {
                            _step++;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Constants.primaryColor,
                        ),
                        child: Text(
                          _step == 0 ? "Choice time" : "Save",
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
