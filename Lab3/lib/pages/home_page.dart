import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab3/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lab3/models/Exam.dart';
import 'package:lab3/widgets/new_exam.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = Auth().currentUser;
  List<Exam> exams = [];

  Future<void> signOut() async {
    await Auth().signOut();
  }

  void _addNewExam(String name, DateTime dateTime) {
    final newExam = Exam(name: name, dateTime: dateTime);
    setState(() {
      exams.add(newExam);
    });
  }

  void _startAddNewExam(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {},
          child: NewExam(addExam: (name, dateTime) {
            _addNewExam(name, dateTime);
          }),
        );
      },
    );
  }

  Widget _buildExamCard(Exam exam) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(exam.name, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              DateFormat('dd MMMM yyyy HH:mm').format(exam.dateTime),
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exam App"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _startAddNewExam(context),
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: signOut,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: exams.length,
          itemBuilder: (context, index) {
            return _buildExamCard(exams[index]);
          },
        ),
      ),
    );
  }

}
