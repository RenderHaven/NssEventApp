import "package:flutter/material.dart";
class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("mera app"),
      ),
      body:Center(
        child: Container(
          child:Text("jai vikram"),
        ),
      ),
      drawer: Drawer(),
    );
  }
}
