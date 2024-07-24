import "package:flutter/material.dart";
import "package:untitled/homepage.dart";
import "package:untitled/pages/Baap/AddEvent.dart";
import "package:untitled/pages/Baap/GenView.dart";
import "package:untitled/pages/Baap/StudentDetails.dart";
import "package:untitled/pages/Notification.dart";
import "package:untitled/pages/Tools/EventImageView.dart";
import "package:untitled/pages/Your_Role.dart";
import "package:untitled/pages/login.dart";
import "package:untitled/pages/Mentor/MentorView.dart";
import "package:untitled/pages/StudentView/EventView.dart";
import "package:untitled/pages/StudentView/StudentView.dart";
import "package:untitled/pages/StudentView/setting.dart";
import "package:untitled/pages/onboard.dart";

import 'package:google_fonts/google_fonts.dart';
void main(){
  runApp(Myapp());
}
class Myapp extends StatefulWidget {
  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  void forceRefresh() {
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.transparent,
      //home: NotificationView(),
      home:Startpage(),
      //home:ImageView(),
      theme: ThemeData(
        fontFamily : GoogleFonts.lato().fontFamily,
        colorScheme: ColorScheme.light(),
      ),
      routes: {
        //'/':Homepage(),
        "/home": (context) => new Homepage(),
        "/login": (context) => new Loginpage(),
        "/start" :(context) => new Startpage(),
        "/studentV" :(context) =>new StudentView(),
        //"/setting" :(context) => new StuSett(),
        //"/eventV" :(context) => new EventView(),
        "/role" :(context)=> new RolePage(),
        //"/mentorV":(context)=>new Mentorview(),
        "/note":(context)=>new NotificationView(UserId: 'Stu_2201cs76'),
      },
    );
  }
}