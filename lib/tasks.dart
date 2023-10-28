import 'package:flutter/material.dart';

class Tasks extends StatefulWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Pending Tasks',
              style: TextStyle(
                fontFamily: 'Sans',
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            TaskTile(
              imagePath: 'assets/Mango.png',
              taskName: 'Task 1 Name',
              taskDate: 'Task 1 Date',
              taskType: 'Task 1 Type',
              taskDescription: 'This is the description for Task 1.',
            ),
            TaskTile(
              imagePath: 'path_to_image2.png',
              taskName: 'Task 2 Name',
              taskDate: 'Task 2 Date',
              taskType: 'Task 2 Type',
              taskDescription: 'This is the description for Task 2.',
            ),
            // Add more TaskTiles for additional tasks
          ],
        ),
      ),
    );
  }
}

class TaskTile extends StatelessWidget {
  final String imagePath;
  final String taskName;
  final String taskDate;
  final String taskType;
  final String taskDescription;

  TaskTile({
    required this.imagePath,
    required this.taskName,
    required this.taskDate,
    required this.taskType,
    required this.taskDescription,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showTaskDetails(context);
      },
      child: Padding(
        padding:
            const EdgeInsets.only(bottom: 20.0), // Add spacing between boxes
        child: Card(
          elevation: 3, // Add elevation for a card-like effect
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Image.asset(
                imagePath,
                height: 150, // Adjust the height as needed
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      taskName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Date: $taskDate\nType: $taskType',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTaskDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                imagePath,
                height: 150, // Adjust the height as needed
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Text(
                taskName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text('Date: $taskDate'),
              Text('Type: $taskType'),
              Text('Description: $taskDescription'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
