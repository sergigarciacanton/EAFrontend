//https://www.youtube.com/watch?v=KvaKVud0Jx0

import 'dart:async';

import 'package:ea_frontend/routes/event_service.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/event.dart';

class BuildCalendar extends StatefulWidget {
  const BuildCalendar({Key? key}) : super(key: key);

  @override
  State<BuildCalendar> createState() => _BuildCalendarState();
}

class _BuildCalendarState extends State<BuildCalendar> {
  List<Event> _events = [];
  Map<DateTime, List<Event>> selectedEvents = {};
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    getEvents();
    super.initState();
  }

  Future<void> getEvents() async {
    _events = await EventService.getEvents();
    int count = 0;
    _events.forEach((element) {
      print(DateTime.parse(
          element.eventDate.toString().split(" ")[0] + " 00:00:00.000Z"));
      if (selectedEvents[DateTime.parse(
              element.eventDate.toString().split(" ")[0] + " 00:00:00.000Z")] !=
          null) {
        selectedEvents[DateTime.parse(
                element.eventDate.toString().split(" ")[0] + " 00:00:00.000Z")]
            ?.add(element);
      } else {
        selectedEvents[DateTime.parse(
            element.eventDate.toString().split(" ")[0] + " 00:00:00.000Z")] = [
          element
        ];
      }
    });
    print(selectedEvents);
  }

  List<Event> _getEventsfromDay(DateTime date) {
    print(selectedEvents[date]);
    print(date);
    return selectedEvents[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: selectedDay,
            firstDay: DateTime(1990),
            lastDay: DateTime(2050),
            calendarFormat: format,
            onFormatChanged: (CalendarFormat _format) {
              setState(() {
                print("1");
                format = _format;
              });
            },
            startingDayOfWeek: StartingDayOfWeek.monday,
            daysOfWeekVisible: true,

            //Day Changed
            onDaySelected: (DateTime selectDay, DateTime focusDay) {
              setState(() {
                selectedDay = DateTime.parse(selectDay.toString());
                focusedDay = focusDay;
              });
              _getEventsfromDay(selectDay);
            },
            selectedDayPredicate: (DateTime date) {
              return isSameDay(selectedDay, date);
            },

            eventLoader: _getEventsfromDay,

            //To style the Calendar
            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              selectedTextStyle: TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(
                color: Colors.purpleAccent,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              defaultDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              weekendDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5.0),
              ),
              formatButtonTextStyle: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ..._getEventsfromDay(selectedDay).map(
            (Event event) => ListTile(
              title: Text(
                event.name,
              ),
            ),
          ),
          Text(selectedDay.toString()),
        ],
      ),
    );
  }
}
