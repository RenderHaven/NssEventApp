import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:untitled/pages/ShowEvents.dart';

import '../../DataManagment/ApiService.dart';
class EventCalender extends StatefulWidget {
  @override
  State<EventCalender> createState() => _framState();

  EventCalender();
}

class _framState extends State<EventCalender> {
  bool isLoading = true;
  DateTime _selectedDay=DateTime.now();
  DateTime _focusedDay=DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  dynamic data = {};
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      print("Fetching data...");
      data = await ApiService().getData(id: 'all', src: 'events');
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error state or show a message to the user
    }
  }

  Widget build(BuildContext context) {
    double scrwd = MediaQuery.of(context).size.width;
    double scrht = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title:Text("Event Calender")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay; // update `_focusedDay` here as well
                  print(DateFormat('dd-MM-yyyy').format(_focusedDay));
                });
              },
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            Showevents(list:[''],getnew: true,getall: true,date: DateFormat('dd-MM-yy').format(_focusedDay),EvtData: data,isloading: isLoading,userid: 'None',),
          ],
        ),
      )
    );
  }
}
