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
  String? selectedLocation;
  double? latitude;
  double? longitude;

  final List<Map<String, dynamic>> locations = [
    {'name': 'FINKI', 'latitude': 42.00449, 'longitude': 21.4068957},
    {'name': 'FDU', 'latitude': 42.0046379, 'longitude': 21.4013135},
    {'name': 'FEIT', 'latitude': 42.0049817, 'longitude': 21.4038073},
    {'name': 'HQ', 'latitude': 37.7900161, 'longitude': -122.3925895},
  ];

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
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      });
    });
  }

  void _submitData() {
    if (_nameController.text.isEmpty || latitude == null || longitude == null) {
      return;
    }
    final enteredName = _nameController.text;
    widget.addExam(enteredName, _selectedDate, latitude!, longitude!);
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade400, width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedLocation,
                isExpanded: true,
                hint: Text("Select Location"),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.black, fontSize: 16),
                onChanged: (newValue) {
                  setState(() {
                    selectedLocation = newValue;
                    latitude = locations.firstWhere((location) => location['name'] == newValue)['latitude'];
                    longitude = locations.firstWhere((location) => location['name'] == newValue)['longitude'];
                  });
                },
                items: locations.map<DropdownMenuItem<String>>((Map<String, dynamic> location) {
                  return DropdownMenuItem<String>(
                    value: location['name'],
                    child: Text(location['name']),
                  );
                }).toList(),
              ),
            ),
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
