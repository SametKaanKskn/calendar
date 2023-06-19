import 'package:flutter/material.dart';

class AddEventPage extends StatelessWidget {
  final Function(String, String, DateTime) onEventAdded;

  AddEventPage({required this.onEventAdded});

  TextEditingController _eventTitleController = TextEditingController();
  TextEditingController _eventNotesController = TextEditingController();
  DateTime selectedTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _eventTitleController,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _eventNotesController,
              decoration: InputDecoration(
                labelText: 'Notes',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: TextEditingController(
                text: '${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}',
              ),
              readOnly: true,
              onTap: () {
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(selectedTime),
                ).then((time) {
                  if (time != null) {
                    selectedTime = DateTime(
                      selectedTime.year,
                      selectedTime.month,
                      selectedTime.day,
                      time.hour,
                      time.minute,
                    );
                  }
                });
              },
              decoration: InputDecoration(
                labelText: 'Time (HH:mm)',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final title = _eventTitleController.text;
                final notes = _eventNotesController.text;
                if (title.isNotEmpty && notes.isNotEmpty) {
                  onEventAdded(title, notes, selectedTime);
                  Navigator.pop(context);
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Title and notes cannot be empty.'),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text('Add Event'),
            ),
          ],
        ),
      ),
    );
  }
}

