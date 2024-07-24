import 'dart:convert';
import 'dart:math';

import "package:flutter/material.dart";
import 'package:pie_chart/pie_chart.dart';
import 'package:untitled/DataManagment/ApiService.dart';
import 'package:untitled/pages/Baap/StudentList.dart';
import 'package:untitled/pages/ShowEvents.dart';
import 'package:untitled/pages/StudentView/AttendedEvents.dart';
import 'package:untitled/pages/Tools/MyButton.dart';
import '../Tools/MyDropeDown.dart';

class Studentdetails extends StatefulWidget {
  final String UserId;
  final bool isment;
  dynamic UserInfo={};
  dynamic UserEventList=[];
  @override
  State<Studentdetails> createState() => _StudentdetailsState();
  Studentdetails({required this.UserId,this.isment=false}){
    print(UserId);
    print(isment);
  }
}
class _StudentdetailsState extends State<Studentdetails> {
  dynamic isUserLoading=true;
  void initState(){
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      dynamic userdata;
      print("Fetching user data...for ${widget.UserId}");
      // userdata = await ApiService().getData(id: widget.MyId, src: 'users');
      userdata = await ApiService().getData(id:widget.UserId,src: 'users');
      setState(() {
        widget.UserInfo = userdata['MyInfo'] ?? {};
        widget.UserEventList = userdata['MyEvt'] ?? [];
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
    double scrwd = MediaQuery.of(context).size.width;
    double scrht = MediaQuery.of(context).size.height;

    return Material(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: scrwd / 12, horizontal: scrht / 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: scrwd / 16),
              _buildTitle(scrwd),
              SizedBox(height: scrwd / 16),
              isUserLoading?CircularProgressIndicator():_buildStudentInfo(scrwd, scrht),
              SizedBox(height: scrwd / 16),
              isUserLoading
                  ? CircularProgressIndicator()
                  : _buildContent(scrwd),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(double scrwd) {
    return Text(
      "Student Details",
      style: TextStyle(
        fontSize: scrwd / 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
  Widget _buildContent(double scrwd) {
    if ((widget.UserId.toLowerCase()).startsWith('stu')) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPieChart(scrwd,widget.UserInfo['Attendance']??0.0),
          SizedBox(height: scrwd / 16),
          Attendedevents(UserId: widget.UserId,isment: widget.isment,),
        ],
      );
    } else if ((widget.UserId.toLowerCase()).startsWith('men')) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Mybutton("STUDENTS"),
          SizedBox(height: scrwd / 16),
          Studentlist(ByMentId: widget.UserId),
        ],
      );
    } else {
      return SizedBox(); // or any other default widget
    }
  }

  Widget _buildStudentInfo(double scrwd, double scrht) {
    return Container(
      height: scrht / 5 + scrwd / 16,
      width: scrwd / 1.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: scrwd / 16),
              Text(
                widget.UserInfo['Name']??'N/A',
                style: TextStyle(
                  fontSize: min(scrwd / 12, 25),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(widget.UserInfo['Roll']??'N/A',),
              SizedBox(height: min(scrwd / 32, 30)),
              Text(widget.UserInfo['Email']??'N/A',),
            ],
          ),
          Container(
            width: scrht / 6,
            height: scrht / 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: (widget.UserInfo.isEmpty || widget.UserInfo['ProfileImage'] == null)
                    ? AssetImage('assets/Icon/profile.png')
                    : MemoryImage(base64Decode(widget.UserInfo['ProfileImage'])),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart(double scrwd,double value) {
    return Column(
      children: [
        Container(
          child: PieChart(
            chartRadius: scrwd * 0.2,
            dataMap: {
              'Got': value,
              'Miss': 120-value,
            },
            chartType: ChartType.ring,
            colorList: [Colors.deepPurple, Colors.grey],
            chartValuesOptions: const ChartValuesOptions(
              showChartValues: false,
            ),
            legendOptions: const LegendOptions(showLegends: false),
          ),
        ),
        SizedBox(height: 5,),
        Text("Attendance :$value"),
      ],
    );
  }
}
