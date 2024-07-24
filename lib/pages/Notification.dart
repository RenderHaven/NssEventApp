import "dart:async";

import "package:flutter/material.dart";
import "package:untitled/DataManagment/DataManage.dart";
import "package:untitled/pages/StudentView/EventView.dart";
import "package:untitled/pages/StudentView/MyEventView.dart";
import "package:untitled/pages/Tools/MyButton.dart";

import "../DataManagment/ApiService.dart";
class NotificationView extends StatefulWidget {
  //Student_fram({super.key});
  int mode=1;
  final String UserId;
  NotificationView({required this.UserId});
  @override
  State<NotificationView> createState() => _Notification();
}

class _Notification extends State<NotificationView> {


  bool isloading = true;
  dynamic _MyNote=[];

  @override
  void initState() {
    super.initState();
    if (widget.UserId!='') {
      fetchData();
    }
    else print("empty");
  }

  void fetchData() async {
    try {
      print(widget.UserId);
      dynamic data = await ApiService().getNote(userid: widget.UserId);
      setState(() {
        _MyNote = data;
        isloading = false;
        print("my data is $data");
        //if(MyEvt!=[])widget.iskhali=false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error state or show a message to the user
    }
  }

  void Work(dynamic Note){
    print(Note);
    if(Note['Type']=='NewEvt'){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>EventView(EvtId: Note['EventId'],userid: widget.UserId,isment: widget.UserId.startsWith('Men'),isnew: true,MyStu: [],)));
    }
    if(Note['Type']=='NewSub'){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>MyEventView(EvtId: Note['EventId'], userid:Note['OwnerId'],isment: true,)));
    }

  }




  @override
  Widget build(BuildContext context) {
    double scrwd=MediaQuery.of(context).size.width;
    double scrht=MediaQuery.of(context).size.height;
    return Material(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: scrwd/20,vertical:scrwd/16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Text("Notification",
                    style: TextStyle(
                      fontSize: scrwd/16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  IconButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/setting');
                  },
                  icon:Icon(Icons.settings),
                ) ,
                ]
              ),
              SizedBox(height: scrwd/12,),
              Container(
                //color: Colors.blueAccent,
                constraints: BoxConstraints(
                  maxHeight: scrht/1.2,
                ),
                child:isloading?CircularProgressIndicator():ListView(
                  shrinkWrap: true,
                  children: [
                    for (var evt in _MyNote)
                      Mybutton(evt['Note'],kaam:()=>Work(evt),),
              //     Container(
              //         alignment: Alignment.centerLeft,
              //           height: scrwd/8,
              //           decoration: BoxDecoration(
              //             color: Colors.black12,
              //             borderRadius: BorderRadius.circular(scrwd*0.05),
              //           ),
              //           child: Padding(
              //             padding: EdgeInsets.symmetric(horizontal:scrwd/16),
              //             child: Text(evt['Note']),
              //           )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}