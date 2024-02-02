import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewExam extends StatefulWidget {
  final Function addExam;

  const NewExam({Key? key, required this.addExam}) : super(key: key);

  @override
  _NewExamState createState() => _NewExamState();
}

class _NewExamState extends State<NewExam> {
  final _nameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _presentDateTimePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      ).then((pickedTime) {
        if (pickedTime == null) return;
        final DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          _selectedDate = finalDateTime;
        });
      });
    });
  }

  void _submitData() {
    if (_nameController.text.isEmpty) return;
    final enteredName = _nameController.text;
    if (enteredName.isEmpty || _selectedDate == null) {
      return;
    }
    widget.addExam(enteredName, _selectedDate);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        top: 10,
        left: 10,
        right: 10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Exam Name'),
            onSubmitted: (_) => _submitData(),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  'Selected Date: ${DateFormat.yMd().format(_selectedDate)}',
                ),
              ),
              TextButton(
                onPressed: _presentDateTimePicker,
                child: Text('Choose Date and Time'),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _submitData,
            child: Text('Add Exam'),
          ),
        ],
      ),
    );
  }
}
