import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:untitled/DataManagment/DataManage.dart';
import 'package:flutter/foundation.dart';
import 'package:untitled/pages/Notification.dart';
import 'package:untitled/pages/ShowEvents.dart';
import 'package:untitled/pages/StudentView/AttendedEvents.dart';
import 'package:untitled/pages/StudentView/HoursView.dart';
import 'package:untitled/pages/StudentView/setting.dart';
import 'package:untitled/pages/Tools/EventCalender.dart';
import 'package:untitled/pages/Tools/tool_slid.dart';
import '../../DataManagment/ApiService.dart';

class StudentView extends StatefulWidget {
  dynamic Mydata;
  dynamic MyInfo = {};
  dynamic Evtlist = [];
  final String MyId;
  StudentView({this.MyId = 'Stu_2201cs76'}) {

  }
  int mode = 0;

  @override
  State<StudentView> createState() => _StudentView();
}

class _StudentView extends State<StudentView> {
  dynamic userdata = {};
  int key=0;
  bool isUserLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      print("Fetching user data...for ${widget.MyId}");
      // userdata = await ApiService().getData(id: widget.MyId, src: 'users');
      userdata = await Datamanage().refresh(widget.MyId);
      print(userdata);
      setState(() {
        key+=1;
        widget.Mydata = userdata;
        widget.MyInfo = userdata['MyInfo'] ?? {};
        widget.Evtlist = userdata['MyEvt'] ?? [];
        isUserLoading = false;
      });
      print("got user data");
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error state or show a message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Building UI...");
    double scrwd = MediaQuery.of(context).size.width;
    double scrht = MediaQuery.of(context).size.height;

    return Material(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: scrwd / 20,
            vertical: scrwd / 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(scrwd, context),
              SizedBox(height: scrht / 16),
              isUserLoading ? CircularProgressIndicator() : _buildUserInfo(scrwd),
              SizedBox(height: scrht / 64),
              _buildToggle(scrwd),
              SizedBox(height: scrht / 64),
              _buildContent(scrht),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double scrwd, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          iconSize: scrwd * 0.25 * 0.25,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => EventCalender()));
          },
          icon: Icon(Icons.calendar_month),
        ),
        Row(
          children: [
            IconButton(
              iconSize: scrwd * 0.25 * 0.25,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationView(UserId: widget.MyId)));
              },
              icon: Icon(Icons.notifications),
            ),
            IconButton(
              iconSize: scrwd * 0.25 * 0.25,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StuSett(
                      MyId: widget.MyId,
                    ),
                  )).then((_){
                  fetchUserData();
                });
              },
              icon: Icon(Icons.settings),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserInfo(double scrwd) {
    return Container(
      child: Text(
        widget.MyInfo['Name'] ?? "Student",
        style: TextStyle(
          fontSize: scrwd / 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildToggle(double scrwd) {
    return ToolSlid(
      initialLabelIndex: widget.mode,
      minWidth: scrwd / 3.8,
      minHeight: scrwd / 10,
      inactiveBgColor: Colors.black12,
      labels: ["Hours\nCompleted", "Upcoming\nEvents", "Attended\nEvents"],
      onToggle: (index) {
        if (index != null) {
          setState(() {
            widget.mode = index;
          });
        }
        print(widget.MyInfo['Attendance']);
        print(widget.Evtlist);
      },
    );
  }

  Widget _buildContent(double scrht) {
    print('sdcsdc');
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.mode == 0)
            Column(
              children: [
                SizedBox(height: scrht / 12),
                HoursView(attended: (widget.MyInfo['Attendance'] ?? 0.0)),
              ],
            ),
          if (widget.mode == 1)
            Showevents(
              key: ValueKey('$key'),  // Add this key
              list: widget.Evtlist,
              getnew: true,
              getattnd: false,
              mentorid: widget.MyInfo['MentorId'],
              // EvtData: eventdata,
              userid: widget.MyId,
            ),
          if (widget.mode == 2)
            Attendedevents(UserId: widget.MyId,key: ValueKey(key),)
        ],
      ),
    );
  }
}
