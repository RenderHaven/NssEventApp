import "package:flutter/material.dart";
import "dart:convert";
import "package:untitled/DataManagment/DataManage.dart";
import "package:untitled/pages/Baap/GenView.dart";
import "package:untitled/pages/StudentView/StudentView.dart";
import "package:untitled/pages/Mentor/MentorView.dart";
import "package:untitled/pages/Tools/MyButton.dart";
class RolePage extends StatelessWidget {
  const RolePage({super.key});

  @override
  Widget build(BuildContext context) {
    List <String> _roles=["Student","Mentor","PIC/GenSec"];
    double scrwd=MediaQuery.of(context).size.width;
    double scrht=MediaQuery.of(context).size.height;
    return Material(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: scrht/16,horizontal: scrwd/16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(color: Colors.deepPurple,height: 15,thickness: 5,),
                SizedBox(height: scrht/64+scrwd/64,),
                Text("Your Role",style: TextStyle(
                  fontSize: scrwd/10,
                  fontWeight: FontWeight.bold,
                ),),
                SizedBox(height: scrht/64+scrwd/64,),
                Text("Choose the option which describes your role.",style: TextStyle(
                  fontSize: scrwd/24,
                ),),
                SizedBox(height: scrht/32+scrwd/64,),
                Column(
                  children: [
                    for (var item in _roles)
                      Column(
                        children: [
                          Mybutton(item,bg:Colors.white,fg:Colors.black,w:scrwd/1.2,brdcl: Colors.black,
                            kaam: ()async{

                              //geting data
                              // if(item =='Student') Datamanage().refresh('Stu_2201cs76');
                              // else Datamanage().refresh('Men_2201cb76');
                              //refresing

                              //dynamic _passdata=await Datamanage().getdata();

                              //print(_passdata);

                              //print(item);
                              Navigator.push(
                                context,
                                //MaterialPageRoute(builder: (context) => Loginpage(typ:item,)),
                                 MaterialPageRoute(builder: (context) => item=='PIC/GenSec'?new Genview():(item=='Mentor'?new Mentorview():new StudentView(MyId: 'Stu_2201cs76',)))
                              );
                            },
                          ),
                          SizedBox(height: scrwd/64), // Adjust the height as needed
                        ],
                      ),
                  ],
                ),
                SizedBox(height: scrht/3),
                // Mybutton("Next",w:scrwd/1.2,
                //   kaam: (){
                //     Navigator.pushNamed(context, '/mentorV');
                //   },
                // ),
              ],
            ),
          ),
        ),
    );
  }
}