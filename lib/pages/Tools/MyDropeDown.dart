import "dart:math";

import "package:flutter/material.dart";
import "package:untitled/pages/Tools/MyButton.dart";

class MyDropeDown extends StatefulWidget {
  bool _isopen=false;
  bool ismulti;
  double value=50;
  List <String> iteam=[];
  dynamic iteamchk=[];
  dynamic intial;
  String faltu;
  double ht;
  double wd;
  double maxht;
  Color hcl;
  Color bgcl;
  Color atcl;
  MyDropeDown({this.value=50,required this.iteam,this.faltu="papa ji",this.ht=50,this.wd=200,this.maxht=200,this.ismulti=true,this.hcl=Colors.white,this.bgcl=Colors.white,this.atcl=Colors.black12,this.iteamchk}){
    if(!this.ismulti){
      this.iteamchk=List.generate(this.iteam.length, (indx) {return false;});
    };
    this.intial=List.from(iteamchk);
  }

  @override
  State<MyDropeDown> createState() => _DropeState();
}
class _DropeState extends State<MyDropeDown>{
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.bgcl,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: widget.ht,
            width: widget.wd,
            decoration: BoxDecoration(
              color: widget.hcl,
              borderRadius: BorderRadius.circular(15),
            ),
            child:Padding(
              padding:EdgeInsets.symmetric(horizontal: widget.wd/32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.faltu,
                  style: TextStyle(
                    color: Colors.black,
                    //fontSize: 20,
                    fontSize: min(widget.wd/16+widget.ht/16,20),
                  ),),

                  IconButton(onPressed: (){
                        widget._isopen=widget._isopen?false:true;
                        setState(() {
                        });
                  }, icon: Icon(widget._isopen?Icons.arrow_drop_up : Icons.arrow_drop_down)),
                ],
              ),
            ),
          ),
          if(widget._isopen)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: widget.wd,
                constraints: BoxConstraints(
                  maxHeight: widget.maxht,
                ),
                child: ListView(
                  primary: true,
                  shrinkWrap: true,
                  children: List.generate(widget.iteam.length, (indx) {
                      return Padding(
                        padding:EdgeInsets.symmetric(horizontal: widget.wd/32,vertical:widget.ht/16),
                      child: Mybutton(
                        widget.iteam[indx],w:widget.ht*0.9,
                        fs:widget.wd/16+widget.ht/16,
                        bg:widget.iteamchk[indx]?widget.atcl:widget.bgcl,
                        fg:widget.intial[indx]?Colors.green:Colors.black,
                        kaam: (){
                          if(widget.ismulti)widget.iteamchk[indx]=widget.iteamchk[indx]?false:true;
                          else {
                            widget.faltu=widget.iteam[indx];
                            widget._isopen=false;
                          };
                          print(widget.intial[indx]);
                          setState(() {});
                        },
                      ),
                    );
                  },
                  ),
                ),
              ),
              if(widget.ismulti)Mybutton("Mark Attendence",w:widget.wd,fs:widget.wd*0.08,
                kaam: (){
                widget._isopen=false;
                setState(() {
                });
              },),
            ],
          )
        ],
      ),
    );
  }
}