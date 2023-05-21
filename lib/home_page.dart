import 'package:flutter/material.dart';
import 'package:calendar/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  User? _currentUser;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  bool _isTwoWeeksView = false;
  Map<DateTime, List<Event>> _events = {
    DateTime(2023, 5, 1): [
      Event('Event A', 'Notes for Event A', DateTime.now()),
      Event('Event B', 'Notes for Event B', DateTime.now()),
    ],
    DateTime(2023, 5, 2): [
      Event('Event C', 'Notes for Event C', DateTime.now()),
    ],
    DateTime(2023, 5, 3): [
      Event('Event D', 'Notes for Event D', DateTime.now()),
    ],
  };

  TextEditingController _eventTitleController = TextEditingController();
  TextEditingController _eventNotesController = TextEditingController();
  @override
  void dispose() {
    _eventTitleController.dispose();
    _eventNotesController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfileScreen(_currentUser!.uid)),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        title: Text('Takvim'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              setState(() {
                _isTwoWeeksView = !_isTwoWeeksView;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              startingDayOfWeek: StartingDayOfWeek.monday,
              firstDay: DateTime(0),
              lastDay: DateTime(2050),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: _isTwoWeeksView
                  ? CalendarFormat.twoWeeks
                  : CalendarFormat.month,
              eventLoader: _getEventsForDay,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                markersAnchor: 0.7,
              ),
            ),
            SizedBox(height: 20),
            Text('$_selectedDay:'),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _events[_selectedDay]?.length ?? 0,
              itemBuilder: (context, index) {
                Event event = _events[_selectedDay]![index];
                return InkWell(
                  onTap: () => _editEvent(event),
                  child: ListTile(
                    title: Text(event.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('saat: ${event.time.hour}:${event.time.minute
                            .toString().padLeft(2, '0')}'),
                        Text('Not: ${event.notes}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteEvent(event);
                      },
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showAddEventDialog();
        },
      ),
    );
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }
 
  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Profile',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
  }

  void _showAddEventDialog() {
    DateTime selectedTime = DateTime.now();
    TextEditingController _timeController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Not Ekleme'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _eventTitleController,
                    decoration: InputDecoration(labelText: 'Başlık'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _eventNotesController,
                    decoration: InputDecoration(labelText: 'Not'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _timeController,
                    readOnly: true,
                    onTap: () {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(selectedTime),
                      ).then((time) {
                        if (time != null) {
                          setState(() {
                            selectedTime = DateTime(
                              selectedTime.year,
                              selectedTime.month,
                              selectedTime.day,
                              time.hour,
                              time.minute,
                            );
                            _timeController.text =
                            '${selectedTime.hour}:${selectedTime.minute
                                .toString().padLeft(2, '0')}';
                          });
                        }
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'saat (HH:mm)',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  _addEvent(selectedTime);
                  Navigator.pop(context);
                },
                child: Text('Ekle'),
              ),
            ],
          ),
    );
  }
   void _editEvent(Event event) {
    DateTime selectedTime = event.time;
    
    _eventTitleController.text = event.title;
    _eventNotesController.text = event.notes;

    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Not Güncelleme'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _eventTitleController,
                    decoration: InputDecoration(labelText: 'Başlık'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _eventNotesController,
                    decoration: InputDecoration(labelText: 'Not'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    
                    readOnly: true,
                    onTap: () {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(selectedTime),
                      ).then((time) {
                        
                          setState(() {
                            
                          
                          });
                        }
                      );
                    },
                    decoration: InputDecoration(
                      labelText: 'Time (HH:mm)',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  _updateEvent(event, selectedTime);
                  Navigator.pop(context);
                },
                child: Text('Kaydet'),
              ),
            ],
          ),
    );
  }

  void _addEvent(DateTime selectedTime) {
    final title = _eventTitleController.text;
    final notes = _eventNotesController.text;
    final time = selectedTime;
    if (title.isNotEmpty && notes.isNotEmpty) {
      final newEvent = Event(title, notes, time);
      _events[_selectedDay] ??= [];
      _events[_selectedDay]!.add(newEvent);
      setState(() {});
    }
    else {
      print('not veya başlık boş olamaz');
    }
  }
  void _updateEvent(Event event, DateTime selectedTime) {
    final title = _eventTitleController.text;
    final notes = _eventNotesController.text;
    final time = selectedTime;
    if (title.isNotEmpty && notes.isNotEmpty) {
      event.title = title;
      event.notes = notes;
      event.time = time;
      setState(() {});
    }
    else{
      print('not veya başlık boş olamaz');
    }
  }
   void _deleteEvent(Event event) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(

            content: Text('Bu Notu Silmek İstediğinizden Emin Misiniz?'),
            actions: [
               ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the confirmation dialog
                    _removeEvent(event); // Delete the event
                  },
                  child: Text('SİL'),
                ),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the confirmation dialog
                },
                child: Text('VAZGEÇ'),
              ),
            ],
          ),
    );
  }
void _removeEvent(Event event) {
    _events[_selectedDay]?.remove(event);
    setState(() {});
  }
}

 class Event {
  String title;
  String notes;
  DateTime time;

  Event(this.title, this.notes, this.time);
}