import "dart:convert";

import "package:flutter/material.dart";
import "package:untitled/DataManagment/DataManage.dart";
import "package:untitled/pages/Mentor/MentorView.dart";
import "package:untitled/pages/StudentView/StudentView.dart";
import "package:untitled/pages/Tools/EventImageView.dart";
import "package:untitled/pages/Tools/MyButton.dart";
import "package:untitled/pages/Your_Role.dart";
import "package:untitled/pages/login.dart";

import "../DataManagment/ApiService.dart";


class Startpage extends StatelessWidget {
  const Startpage({super.key});
  @override
  Widget build(BuildContext context) {
    double scrwd=MediaQuery.of(context).size.width;
    double scrht=MediaQuery.of(context).size.height;
    return Material(
        child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: scrht/8,),
                SizedBox(
                  height: scrht/4,
                  child: Image.asset("assets/img/NssLogo.png",
                    height: scrht/4,
                  ),
                ),
                SizedBox(height: scrht/20,),
                Text( " NOT ME BUT YOU ",
                  style: TextStyle(
                    fontSize :scrwd/16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: scrht/2.5),
          
                Mybutton('Get Started',
                  w :scrwd/1.2,
                  kaam: ()async {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> RolePage()));

                    // showDialog(
                    //   context: context,
                    //   builder: (BuildContext context) {
                    //     return ImageView(); // Replace with actual userId and eventId
                    //   },
                    // );


                    // print("ho gya");
                    // dynamic _data = await Datamanage().getdata();
                    // print("love u");
                    // print(_data);
                    // if (_data == "New") {
                    //   print("yaha hu");
                    //   Navigator.push(context, MaterialPageRoute(
                    //     builder: (context) => RolePage(),));
                    // } else {
                    //
                    //   //old member
                    //   print("papa");
                    //   //refress and load
                    //   //dynamic _ref_data = await Datamanage().refresh(_data["UserId"]);
                    //   print("ye mila $_data");
                    //   if(_data["UserId"].contains('Stu')){
                    //     Navigator.push(context, MaterialPageRoute(
                    //       builder: (context) => StudentView(Mydata: _data)));
                    //   }
                    //   else{
                    //     Navigator.push(context, MaterialPageRoute(
                    //         builder: (context) => Mentorview(Mydata: _data)));
                    //   };
                    // }
                  },
                )
              ],
            ),
          ),
        );
  }
}