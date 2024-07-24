import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:untitled/pages/Tools/MyButton.dart";
class Loginpage extends StatefulWidget {
  Map <String,String> _rout={"Student":'/studentV',"Mentor":'/mentorV',"Gen":'/start'};

  final String typ;
  Loginpage({this.typ='Student'});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {


  late Map<String, dynamic> usersData;
  bool isLoading = true;

  final _web=TextEditingController();
  final _pass=TextEditingController();
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final String content = await rootBundle.loadString('assets/Data/Users.txt');
    setState(() {
      usersData = jsonDecode(content);
      isLoading = false;
      print(usersData);
    });
  }
  @override
  Widget build(BuildContext context) {
    double scrwd=MediaQuery.of(context).size.width;
    double scrht=MediaQuery.of(context).size.height;
    print("papa ${widget.typ}");
    return Material(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: (10),horizontal: (32)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height:scrht/12),
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/img/NssLogo.png",
                    height:scrht/4 ,
                  ),
                ),
                SizedBox(height:scrht/12),
                Text( " WELCOME ",
                  style: TextStyle(
                    fontSize : scrwd/16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding:EdgeInsets.all(scrwd/64),
                  child: Column(

                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          //hintText: "outlook mail",
                          labelText: "Outlook mail",
                        ),
                        controller: _web,
                      ),
                      SizedBox(height: scrht/64,),
                      TextFormField(
                        decoration: const InputDecoration(
                          //hintText: "password ",
                          labelText: "Password",
                        ),
                        controller: _pass,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: scrht/8,),
                Container(
                  alignment: Alignment.center,
                  child: Mybutton("Login",
                    kaam: (){
                      print(usersData);
                      String _user=_web.text==''?'@':_web.text;
                      String _pas=_pass.text==''?'@':_pass.text;
                      if(usersData[_user]!=null){
                        if(usersData[_user]["pass"]==_pas && usersData[_user]["typ"]==widget.typ) {
                          Navigator.pushNamed(
                              context, "${widget._rout[widget.typ]}");
                        }
                        else {
                          print(usersData[_user]["pass"]==_pas);
                        }
                      }
                      else {
                        print("hii");
                      }
                    },
                  )
                ),
              ],
            ),
          ),
        )
    );
  }
}