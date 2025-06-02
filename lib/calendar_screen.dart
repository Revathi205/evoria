// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../mock_data.dart';
import '../event.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  
  final Map<DateTime, List<Event>> _events = {};
  
  @override
  void initState() {
    super.initState();
    _loadEvents();
    _selectedDay = _focusedDay;
  }
  
  void _loadEvents() {
    // Demo: Convert mock events to calendar format
    // In a real app, you'd load these from a database or API
    for (final event in MockData.sampleEvents) {
      // Simple date parsing for demo purposes
      // Format: 'Jun 15-16', 'Jul 21', etc.
      try {
        final List<String> dateComponents = event.date.split(' ')[0].split('-');
        final String monthStr = dateComponents[0];
        final int day = int.parse(dateComponents[1]);
        
        // Map month string to number
        const Map<String, int> months = {
          'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
          'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12
        };
        
        final int month = months[monthStr] ?? 1;
        final int year = DateTime.now().year;
        
        final DateTime eventDate = DateTime(year, month, day);
        if (_events[eventDate] == null) {
          _events[eventDate] = [];
        }
        _events[eventDate]!.add(event);
      } catch (e) {
        // Skip events with invalid dates for demo
        print('Error parsing date for event: ${event.title}');
      }
    }
  }
  
  List<Event> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Calendar', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Calendar Widget
          TableCalendar(
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              markerDecoration: BoxDecoration(
                color: Colors.pink,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.pink.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.pink,
                shape: BoxShape.circle,
              ),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          SizedBox(height: 8),
          
          // Events List
          Expanded(
            child: _buildEventsList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEventsList() {
    final events = _getEventsForDay(_selectedDay!);
    
    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey[300]),
            SizedBox(height: 16),
            Text(
              'No events for this day',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Card(
          margin: EdgeInsets.only(bottom: 16),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.pink.withOpacity(0.2),
              ),
              child: Center(
                child: Icon(
                  Icons.event,
                  color: Colors.pink,
                ),
              ),
            ),
            title: Text(
              event.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(event.time),
                SizedBox(height: 2),
                Text(event.location),
              ],
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/event_details',
                arguments: event,
              );
            },
          ),
        );
      },
    );
  }
}