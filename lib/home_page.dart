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
      Event('Event A', 'Notes for Event A'),
      Event('Event B', 'Notes for Event B'),
    ],
    DateTime(2023, 5, 2): [
      Event('Event C', 'Notes for Event C'),
    ],
    DateTime(2023, 5, 3): [
      Event('Event D', 'Notes for Event D'),
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
      appBar: AppBar(title: Text('takvim'),

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
    child: Column(
    children: [
    TableCalendar(
    firstDay: DateTime(0),
    lastDay: DateTime(2050),
    focusedDay: _focusedDay,
    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
    calendarFormat: _isTwoWeeksView ? CalendarFormat.twoWeeks : CalendarFormat.month,
    eventLoader: _getEventsForDay,
    onDaySelected: (selectedDay, focusedDay) {
    setState(() {
    _selectedDay = selectedDay;
    _focusedDay = focusedDay;
    });
    },
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
    Text('$_selectedDay'),
    ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: _events[_selectedDay]?.length ?? 0,
    itemBuilder: (context, index) {
    Event event = _events[_selectedDay]![index];
    return ListTile(
    title: Text(event.title),
    subtitle: Text(event.notes),
    trailing: IconButton(
    icon: Icon(Icons.delete),
    onPressed: () {
    _deleteEvent(event);
    },
    ),
    );
    },
    ),
    SizedBox(height: 20),
    Align(
    alignment: Alignment.bottomCenter,
    child: Container(
    margin: EdgeInsets.only(bottom: 10.0),
    child:ElevatedButton(
    onPressed: () {
    _showAddEventDialog();
    },
    child: Text('+'),
    style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30.0),
    ),
    )
    ),
    ))],
    ),
    ),
    );
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

/*Center(child: Text('Ana Sayfa')),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),*/

void _showAddEventDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Add Event'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _eventTitleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _eventNotesController,
            decoration: InputDecoration(labelText: 'Notes'),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            _addEvent();
            Navigator.pop(context);
          },
          child: Text('Add'),
        ),
      ],
    ),
  );
}

void _addEvent() {
  final title = _eventTitleController.text;
  final notes = _eventNotesController.text;
  if (title.isNotEmpty && notes.isNotEmpty) {
    final newEvent = Event(title, notes);
    _events[_selectedDay] ??= [];
    _events[_selectedDay]?.add(newEvent);
    setState(() {});
  }
}

void _deleteEvent(Event event) {
  _events[_selectedDay]?.remove(event);
  setState(() {});
}
}

class Event {
  final String title;
  final String notes;

  Event(this.title, this.notes);
}
