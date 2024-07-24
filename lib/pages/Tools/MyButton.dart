import "dart:ui";

import "package:flutter/material.dart";
class Mybutton extends StatefulWidget {
  String value='';
  final String rout;
  double w=350;
  Function kaam;
  double fs=20;
  final Color bg;
  final Color fg;
  final Color brdcl;
  @override
  Mybutton(this.value,{this.rout='',this.kaam=_faltu,this.w=350,this.bg=Colors.deepPurple,this.brdcl=Colors.white,this.fg=Colors.white,this.fs=20});

  static void _faltu(){}

  @override
  State<Mybutton> createState() => _MybuttonState();
}

class _MybuttonState extends State<Mybutton> {

  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: (){
          if(widget.rout != '') Navigator.pushNamed(context, widget.rout);
          widget.kaam();
        },
        child: Container(
          width: widget.w,
          height: 50,
          alignment: Alignment.center,
          //color: Colors.deepPurple,        give in decoration
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.brdcl,
              width: 2.0,
            ),
            color:widget.bg,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            widget.value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: widget.fs,
              color: widget.fg,
            ),
          ),
        ),
      ),
    );
  }
}