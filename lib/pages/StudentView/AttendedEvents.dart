import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/pages/StudentView/EventView.dart';

import '../../DataManagment/ApiService.dart';
import 'MyEventView.dart';

class Attendedevents extends StatefulWidget {
  String DefaultWing = "";
  String UserId;
  final bool isment;
  dynamic EvtData;
  final List<String> _wing = [
    "Adhyayan",
    "Technical Skills",
    "Rural Development",
    "Chetana",
    "Teaching",
    "Environmental",
    "Prayatna"
  ];
  Attendedevents({Key?key,required this.UserId,this.isment=false}): super(key: key);
  @override
  State<Attendedevents> createState() => _Event_framState();
}

class _Event_framState extends State<Attendedevents> {

  bool isKhali = true;
  dynamic eventdata = [];
  bool isLoading = true;
  @override
  void initState() {
    print("hi brooooo");
    super.initState();
    fetchEventData();
  }
  Future<void> fetchEventData() async {
    try {
      print("Fetching event data...");
      eventdata = await ApiService().getMyEventList(id: widget.UserId);
      print("got event data---");
      //eventdata.sort((a, b) => a['Date'].compareTo(b['Date']));
      setState(() {
        widget.EvtData=eventdata;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error state or show a message to the user
    }
  }

  @override
  List<Widget> events() {
    double scrwd = MediaQuery.of(context).size.width;
    double scrht = MediaQuery.of(context).size.height;
    List<Widget> textWidgets = [];
    try {
      for(dynamic value in widget.EvtData) {
              textWidgets.add(
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder:(context)=>MyEventView(isment:widget.isment,userid: widget.UserId,EvtId: value['EvtId']))).then((_){
                      fetchEventData();
                    });
                  },
                  child: Container(
                    height: scrwd / 16 + scrht / 12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(scrwd / 24),
                      color:value['IsOk']? Colors.green:Colors.greenAccent ,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: scrwd / 24,
                        vertical: scrht / 64,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                value['Name'] ?? "Not Available",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: (scrwd / 32 + scrht / 42) * 0.8,
                                ),
                              ),
                              Text(
                                value['Wing'] ?? "N/A",
                                style: TextStyle(
                                  fontSize: (scrwd / 32 + scrht / 42) * 0.5,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            value['Date'] ?? "N/A",
                            style: TextStyle(
                              fontSize: (scrwd / 32 + scrht / 42) * 0.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
      };
    }catch(e){};
    print(textWidgets.isEmpty);
    if (textWidgets.isEmpty) {
      textWidgets.add(Text("NOTHING"));
    }
    return textWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              dropdownColor: Colors.white,
              isExpanded: true,
              value: widget.DefaultWing,
              items: [
                const DropdownMenuItem(child: Text("Select Wing"), value: ""),
                for (var item in widget._wing)
                  DropdownMenuItem(
                    child: Container(child: Text(item)),
                    value: item,
                  ),
              ],
              onChanged: (value) {
                setState(() {
                  if (value != null) widget.DefaultWing = value;
                });
              },
            ),
          ),
        ),
        Container(
          alignment: Alignment.topCenter,
          // constraints: BoxConstraints(
          //   maxHeight: scrht / 1.8,
          // ),
          child: isLoading
              ? CircularProgressIndicator()
              : SingleChildScrollView(
            child: Column(
              //shrinkWrap: true,
              children: events(),
            ),
          ),
        ),
      ],
    );
  }
}
