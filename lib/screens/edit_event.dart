import 'package:flutter/material.dart';
import 'package:calendar/screens/event.dart';
class EditEventDialog extends StatefulWidget {
  final Event event;
  final Function(Event) onUpdateEvent;
  final Function(Event) onDeleteEvent;
  const EditEventDialog({
    required this.event,
    required this.onUpdateEvent,
    required this.onDeleteEvent,
  });

  @override
  _EditEventDialogState createState() => _EditEventDialogState();
}

class _EditEventDialogState extends State<EditEventDialog> {
  late TextEditingController _titleController;
  late TextEditingController _notesController;
  late TimeOfDay _selectedTime;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _notesController = TextEditingController(text: widget.event.notes);
    _selectedTime = TimeOfDay.fromDateTime(widget.event.time);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _updateEvent() {
    String title = _titleController.text;
    String notes = _notesController.text;

    if (title.isEmpty || notes.isEmpty) {
      setState(() {
        _errorMessage = 'Başlık veya not alanı boş bırakılamaz.';
      });
      return;
    }


    Event updatedEvent = Event(title, notes, widget.event.time);
    widget.onUpdateEvent(updatedEvent);
    Navigator.pop(context); // Close the dialog
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('NOT GÜNCELLEME'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'BAŞLIK',
              ),
            ),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'NOT',
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                ).then((selectedTime) {
                  if (selectedTime != null) {
                    setState(() {
                      _selectedTime = selectedTime;
                    });
                  }
                });
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'SAAT (HH:mm)',
                ),
                child: Text(
                  _selectedTime.format(context),
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: _updateEvent,
          child: Text('GÜNCELLE'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: Text('İPTAL'),
        ),
      ],
    );
  }
}

