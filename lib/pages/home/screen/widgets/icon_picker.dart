import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/libs/constants.dart';

class IconPicker extends StatefulWidget {
  final int? selectedIcon;

  const IconPicker({super.key, this.selectedIcon});

  // 50 most useful icons for a task manager app
  static List<IconData> icons = [
    Icons.home,
    Icons.star,
    Icons.settings,
    Icons.search,
    Icons.person,
    Icons.phone,
    Icons.email,
    Icons.calendar_today,
    Icons.check,
    Icons.close,
    Icons.delete,
    Icons.edit,
    Icons.save,
    Icons.share,
    Icons.info,
    Icons.warning,
    Icons.help,
    Icons.notifications,
    Icons.message,
    Icons.attach_file,
    Icons.cloud,
    Icons.download,
    Icons.upload,
    Icons.print,
    Icons.visibility,
    Icons.visibility_off,
    Icons.volume_up,
    Icons.volume_off,
    Icons.wifi,
    Icons.bluetooth,
    Icons.brightness_6,
    Icons.battery_full,
    Icons.battery_alert,
    Icons.airplane_ticket,
    Icons.directions_car,
    Icons.directions_bike,
    Icons.directions_bus,
    Icons.directions_walk,
    Icons.directions_run,
    Icons.fitness_center,
    Icons.restaurant,
    Icons.local_cafe,
    Icons.local_hospital,
    Icons.local_library,
    Icons.local_mall,
    Icons.local_movies,
    Icons.local_offer,
    Icons.local_parking,
  ];

  @override
  State<IconPicker> createState() => _IconPickerState();
}

class _IconPickerState extends State<IconPicker> {
  @override
  Widget build(BuildContext context) {
    return Center(
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
            children: [
              Text(
                "Choose Icon",
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
                  child: SingleChildScrollView(
                child: Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: <Widget>[
                    for (var icon in IconPicker.icons)
                      GestureDetector(
                        onTap: () => Navigator.pop(context, icon),
                        child: Container(
                          width: 50,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Constants.bgColor,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: widget.selectedIcon == icon.codePoint
                                  ? Constants.primaryColor
                                  : Colors.transparent,
                            ),
                          ),
                          child: Icon(
                            icon,
                            size: 30,
                            color: const Color.fromRGBO(255, 255, 255, 0.87),
                          ),
                        ),
                      )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
