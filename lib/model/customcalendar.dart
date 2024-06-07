import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatefulWidget {
  final Function(DateTime) onDaySelected;

  const CustomCalendar({super.key, required this.onDaySelected});
  @override
  // ignore: library_private_types_in_public_api
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  DateTime? _selectedDay;
  DateTime? _focusedDay;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -80),
      child: Transform.scale(
        scale: 0.7,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                color: Color(0x33000000),
                offset: Offset(0, 0.0),
                spreadRadius: 2,
              )
            ],
          ),
          child: TableCalendar(
            // Customize your calendar here
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay ?? DateTime.now(),
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) {
              return _selectedDay != null && isSameDay(_selectedDay!, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              widget.onDaySelected(selectedDay); // Call the callback function
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              // Customize your calendar style here
              defaultTextStyle:
                  const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              weekendTextStyle: const TextStyle(color: Colors.red),
              todayDecoration: BoxDecoration(
                color: isSameDay(_selectedDay, DateTime.now())
                    ? const Color.fromARGB(255, 255, 0, 0)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              todayTextStyle: TextStyle(
                color: isSameDay(_selectedDay, DateTime.now())
                    ? Colors.white
                    : Colors.black,
              ),
              selectedDecoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
        ),
      ),
    );
  }
}
