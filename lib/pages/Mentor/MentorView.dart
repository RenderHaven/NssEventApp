import "package:flutter/material.dart";
import "package:untitled/pages/Baap/StudentList.dart";
import "package:untitled/pages/Mentor/MarkAttendence.dart";
import "package:untitled/pages/Tools/tool_slid.dart";

import "../../DataManagment/ApiService.dart";
import "../Notification.dart";
import "../ShowEvents.dart";
import "../StudentView/setting.dart";
import "../Tools/EventCalender.dart";
class Mentorview extends StatefulWidget {
  //Student_fram({super.key});
  dynamic MyInfo={};
  dynamic MyStu=[];
  dynamic Mydata={};
  final String MyId;
  Mentorview({this.MyId='Men_2201cb76'}){
    // this.MyInfo=Mydata['MyInfo']??{};
    // this.MyStu=Mydata['MyStu']??{};
  }
  int mode=0;
  @override
  State<Mentorview> createState() => _Mentor_framState();
}

class _Mentor_framState extends State<Mentorview> {
  int key=0;
  dynamic userdata = {};
  bool isUserLoading=false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    //fetchData();
  }
  Future<void> fetchUserData() async {
    try {
      print("Fetching user data...");
      userdata = await ApiService().getData(id: widget.MyId);
      print("got user data  $userdata");
      setState(() {
        widget.Mydata=userdata;
        widget.MyInfo = userdata['MyInfo'] ?? {};
        widget.MyStu = userdata['MyStu'] ?? [];
        isUserLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error state or show a message to the user
    }
  }
  @override
  Widget build(BuildContext context) {
    final double scrwd=MediaQuery.of(context).size.width;
    final double scrht=MediaQuery.of(context).size.height;
    return Material(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: scrwd/20,vertical:scrwd/12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              _buildHeader(scrwd, context),
              SizedBox(height: scrht / 16),
              _buildUserInfo(scrwd),
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
                      MyId:widget.MyId
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
  Widget _buildUserInfo(double scrwd){
    return Text(widget.MyInfo['Name']??"Mentor",
      style: TextStyle(
        fontSize: scrwd/12,
        fontWeight: FontWeight.bold,
      ),
    );
  }
  Widget _buildToggle(double scrwd){
    return ToolSlid(
      //radiusStyle: true,
      initialLabelIndex: widget.mode,
      minWidth: scrwd/3.8,
      minHeight: scrwd/8,
      inactiveBgColor: Colors.black12,
      labels: ["Mark Attendence", "Events Picture","MyStudents"],
      onToggle: (index) {
        if (index != null) widget.mode = index;
        //isLoading=true;
        setState(() {

        });
      },
    );
  }
  Widget _buildContent(double scrht){
    return Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: widget.mode==0?true:false,
                child: Column(
                  children: [
                    SizedBox(height: scrht*0.05,),
                    isUserLoading?CircularProgressIndicator():MarkAttendence(MyStu:widget.MyStu),
                  ],
                ),
              ),
              Visibility(
                  visible: widget.mode==1?true:false,
                  child:Showevents(list:[],getall:true,getnew: true,isment: true,userid: 'None',key: ValueKey('$key'),mystu: widget.MyStu,)
              ),
              Visibility(
                  visible: widget.mode==2?true:false,
                  child:Studentlist(ByMentId: widget.MyId,isment: true,),
              ),
            ]
        )
    );
  }
}