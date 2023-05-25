import 'package:flutter/material.dart';
import 'package:calendar/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import 'screens/event.dart';
import 'screens/Add_Event.dart';
import 'screens/edit_event.dart';
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
  
  @override
  void dispose() {
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
              itemCount: _events[_selectedDay]?.length ?? 0,
              itemBuilder: (context, index) {
                Event event = _events[_selectedDay]![index];
                return InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => EditEventDialog(
                        event: event,
                        onUpdateEvent: (updatedEvent) {
                          _updateEvent(updatedEvent as Event);
                        },
                        onDeleteEvent: (deletedEvent) {
                          _deleteEvent(deletedEvent as Event);
                        },
                      ),
                    ).then((value) {
                      setState(() {}); // Güncelleme işleminden sonra yenileme
                    });
                  },
                  child: ListTile(
                    title: Text(event.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Time: ${event.time.hour}:${event.time.minute.toString().padLeft(2, '0')}',
                        ),
                        Text('Note: ${event.notes}'),
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEventPage(
                onEventAdded: (title, notes, time) {
                  addEvent(title, notes, time);
                },
              ),
            ),
          ).then((value) {
            setState(() {}); // Ekleme işleminden sonra yenileme
          });
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
   
  void addEvent(String title, String notes, DateTime time) {
    final newEvent = Event(title, notes, time);
    _events[_selectedDay] ??= [];
    _events[_selectedDay]!.add(newEvent);
  }

  void _updateEvent(Event event) {
    int? index = _events[_selectedDay]?.indexWhere((e) => e.time == event.time);
    if (index != null && index >= 0) {
      _events[_selectedDay]![index] = event;
    }
  }

  void _deleteEvent(Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('Bu Notu Silmek İstediğinize emin misiniz?'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); 
              _removeEvent(event); 
              setState(() {}); // Silme işleminden sonra yenileme
            },
            child: Text('SİL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); 
            },
            child: Text('cancel'),
          ),
        ],
      ),
    );
  }

  void _removeEvent(Event event) {
    _events[_selectedDay]?.remove(event);
  }
}
