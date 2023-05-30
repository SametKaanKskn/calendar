import 'package:calendar/models/event_model.dart';
import 'package:flutter/material.dart';

class EventItem extends StatelessWidget {
  final Event event;
  final Function() onDelete;
  final Function()? onTap;

  const EventItem({
    Key? key,
    required this.event,
    required this.onDelete,
    this.onTap,
  }) : super(key: key);

  // UI Kısmı
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Etkinlik başlığı
              Text(
                event.title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.0),
              // Etkinlik açıklaması
              Text(
                event.description,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          // Etkinlik tarihi
          subtitle: Text(
            event.date.toString(),
          ),
          onTap: onTap, // Card'a tıklanma işlevi eklendi
          trailing: IconButton(
            icon: const Icon(Icons.delete), // Silme düğmesi eklendi
            onPressed: onDelete,
          ),
        ),
      ),
    );
  }
}
