import 'package:calendar/models/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// StatefulWidget'ı kullanarak, etkinlik düzenleme alanı
class EditEvent extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final Event event;

  const EditEvent(
      {Key? key,
      required this.firstDate,
      required this.lastDate,
      required this.event})
      : super(key: key);

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late TextEditingController _titleController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();

    _selectedDate = widget.event.date;
    _selectedTime = TimeOfDay(
        hour: widget.event.date.hour, minute: widget.event.date.minute);
    _titleController = TextEditingController(text: widget.event.title);
    _descController = TextEditingController(text: widget.event.description);
  }

  // UI  Kısmı .
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Etkinlik Düzenle")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Row(
            children: [
              // Tarih seçmek için bir form alanı
              Expanded(
                child: InputDatePickerFormField(
                  firstDate: widget.firstDate,
                  lastDate: widget.lastDate,
                  initialDate: _selectedDate,
                  onDateSubmitted: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                ),
              ),
              // Saat seçmek için bir buton alanı
              IconButton(
                icon: Icon(Icons.access_time),
                onPressed: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: _selectedTime,
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedTime = picked;
                    });
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 10.0),
          // Başlık için bir form alanı
          TextField(
            controller: _titleController,
            maxLines: 1,
            decoration: InputDecoration(
              labelText: 'Başlık',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
          ),
          SizedBox(height: 10.0),
          // Açıklama için bir form alanı
          TextField(
            controller: _descController,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Açıklama',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
          ),
          // Formu kaydetmek için bir buton
          ElevatedButton(
            onPressed: () {
              _editEvent();
            },
            child: const Text("Kaydet"),
          ),
        ],
      ),
    );
  }

  // Formdan gelen verileri kullanarak etkinliği güncelleme
  void _editEvent() async {
    final title = _titleController.text;
    final description = _descController.text;
    if (title.isEmpty) {
      print('Başlık boş olamaz');
      return;
    }
    final eventDateTime = DateTime(_selectedDate.year, _selectedDate.month,
        _selectedDate.day, _selectedTime.hour, _selectedTime.minute);
    await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.id)
        .update({
      "title": title,
      "description": description,
      "date": Timestamp.fromDate(eventDateTime),
    });

    if (mounted) {
      Navigator.pop<bool>(context, true);
    }
  }
}
