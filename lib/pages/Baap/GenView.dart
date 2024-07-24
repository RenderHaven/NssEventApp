import 'package:flutter/material.dart';
import 'package:untitled/pages/Baap/AddEvent.dart';
import 'package:untitled/pages/Baap/StudentList.dart';
import 'package:untitled/pages/ShowEvents.dart';
import 'package:untitled/pages/Tools/tool_slid.dart';
import '../StudentView/setting.dart';
import '../Tools/EventCalender.dart';

class Genview extends StatefulWidget {
  int mode = 0;
  @override
  State<Genview> createState() => _GenviewState();
}
class _GenviewState extends State<Genview> {
  dynamic key=0;
  dynamic data = {};
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final double scrwd = MediaQuery.of(context).size.width;
    final double scrht = MediaQuery.of(context).size.height;

    return Material(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: scrwd / 20, vertical: scrwd / 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(scrwd,context),
              SizedBox(height: scrht / 16),
              _buildGreeting(scrwd),
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

  Widget _buildHeader(double scrwd,BuildContext context) {
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
                //Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationView(id: widget.Mydata['UserId'])));
              },
              icon: Icon(Icons.person),
            ),
            IconButton(
              iconSize: scrwd * 0.25 * 0.25,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StuSett(
                      MyId: "Vipin \n 2201cb65",
                    ),
                  ),
                );
              },
              icon: Icon(Icons.settings),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGreeting(double scrwd) {
    return Text(
      'Hey Vikram',
      style: TextStyle(
        fontSize: scrwd / 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildToggle(double scrwd) {
    return ToolSlid(
      initialLabelIndex: widget.mode,
      minWidth: scrwd / 3.8,
      minHeight: scrwd / 8,
      inactiveBgColor: Colors.black12,
      labels: ["Student List", "Events"],
      onToggle: (index) {
        if (index != null) widget.mode = index;
          setState(() {
            widget.mode=index!;
          });
      },
    );
  }

  Widget _buildContent(double scrht) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.mode == 0) ...[
            SizedBox(height: scrht * 0.05),
            Studentlist(),
          ],
          if (widget.mode == 1) ...[
            Showevents(list: [], getall: true, isgen: true,userid: 'None',key:ValueKey(key)),
            Container(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => new Addevent()),
                  ).then((_){
                    setState(() {
                      key++;
                    });
                  });
                },
                icon: Icon(Icons.add),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
