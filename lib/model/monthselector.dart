import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthSelector extends StatefulWidget {
  final Function(DateTime) onMonthChanged;

  const MonthSelector({super.key, required this.onMonthChanged});
  @override
  State createState() => _MonthSelectorState();
}

class _MonthSelectorState extends State<MonthSelector> {
  DateTime _currentDate = DateTime.now();

  void _handlePreviousMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month - 1);
    });
    widget.onMonthChanged(_currentDate); // Call the callback function
  }

  void _handleNextMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + 1);
    });
    widget.onMonthChanged(_currentDate); // Call the callback function
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_left),
          onPressed: _handlePreviousMonth,
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
          child: Text(
            DateFormat.yMMM().format(_currentDate),
            style: const TextStyle(fontSize: 20),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_right),
          onPressed: _handleNextMonth,
        ),
      ],
    );
  }
}
