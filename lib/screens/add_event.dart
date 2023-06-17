import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// StatefulWidget'ı kullanarak, etkinlik eklemek için bir form oluşturuldu
class AddEvent extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? selectedDate;
 
  const AddEvent(
      {Key? key,
      required this.firstDate,
      required this.lastDate,
      this.selectedDate})
      : super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _selectedDate = widget.selectedDate ?? DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  // UI kısmı
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Etkinlik Ekle")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Row(
            children: [
              // Tarih seçmek için  form alanı
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
              // Saat seçmek için bir düğme alanı
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
              _addEvent();
            },
            child: const Text("Kaydet"),
          ),
        ],
      ),
    );
  }

  // Formdan gelen verileri Firebase'e eklendigi yer
  void _addEvent() async {
    final title = _titleController.text;
    final description = _descController.text;

    if (title.isEmpty) {
      print('Başlık boş olamaz');
      return;
    }
    // Seçilen tarih ve saatle bir DateTime oluşturulma alanı
    final eventDateTime = DateTime(_selectedDate.year, _selectedDate.month,
        _selectedDate.day, _selectedTime.hour, _selectedTime.minute);
    // Firebase veritabanına bir etkinlik ekleme yeri
    await FirebaseFirestore.instance.collection('events').add({
      "title": title,
      "description": description,
      "date": Timestamp.fromDate(eventDateTime),
    });
    // Eğer widget ağaçta ise, önceki sayfaya dönmek için kullanıldı
    if (mounted) {
      Navigator.pop<bool>(context, true);
    }
  }
}
