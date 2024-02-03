import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:lab3/models/Exam.dart';
import 'package:intl/intl.dart';

class StudentScheduleCalendar extends StatefulWidget {
  final List<Exam> exams;

  StudentScheduleCalendar({Key? key, required this.exams}) : super(key: key);

  @override
  _StudentScheduleCalendarState createState() => _StudentScheduleCalendarState();
}

class _StudentScheduleCalendarState extends State<StudentScheduleCalendar> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
  }

  List<Exam> _getExamsForDay(DateTime day) {
    return widget.exams.where((exam) => isSameDay(exam.dateTime, day)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Schedule'),
      ),
      body: TableCalendar(
        firstDay: DateTime.utc(2010, 1, 1),
        lastDay: DateTime.utc(2030, 1, 1),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          _showExamsForSelectedDay(selectedDay);
        },
        eventLoader: _getExamsForDay,
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            var examsForDay = _getExamsForDay(day);
            if (examsForDay.isNotEmpty) {
              return Center(
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    shape: BoxShape.rectangle,
                  ),
                  child: Text(
                    '${day.day}',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              );
            }
            return null;
          },
          markerBuilder: (context, date, events) {
            if (events.isNotEmpty) {
              return _buildEventsMarker(date, events);
            }
          },
        ),
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date, List<dynamic> exams) {
    return Positioned(
      right: 1,
      bottom: 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue,
        ),
        width: 16,
        height: 16,
        child: Center(
          child: Text(
            '${exams.length}',
            style: TextStyle().copyWith(
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
        ),
      ),
    );
  }

  void _showExamsForSelectedDay(DateTime selectedDay) {
    final exams = _getExamsForDay(selectedDay);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(DateFormat('dd-MM-yyyy').format(selectedDay)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: exams
              .map((exam) => ListTile(
            title: Text(exam.name),
            subtitle: Text(DateFormat('HH:mm').format(exam.dateTime)),
          ))
              .toList(),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
