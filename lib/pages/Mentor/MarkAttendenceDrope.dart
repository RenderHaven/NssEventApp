import "dart:math";

import "package:flutter/material.dart";
import "package:untitled/DataManagment/ApiService.dart";
import "package:untitled/pages/Mentor/EventAccept.dart";
import "package:untitled/pages/Tools/MyButton.dart";

import "../Tools/EventImageView.dart";

class MarkAttendenceDrope extends StatefulWidget {
  bool _isopen = false;
  final bool isnew;
  List<dynamic> MyStu; // Changed type to map for clarity
  String faltu;
  String EvtId;
  double ht;
  double wd;
  double maxht;
  Color hcl;
  Color bgcl;
  Color atcl;

  MarkAttendenceDrope({
    required this.EvtId,
    required this.MyStu,
    required this.faltu ,
    this.ht = 50,
    this.wd = 200,
    this.maxht = 200,
    this.hcl = Colors.white,
    this.bgcl = Colors.white,
    this.atcl = Colors.black12,
    this.isnew=false
  });

  @override
  State<MarkAttendenceDrope> createState() => _DropeState();
}

class _DropeState extends State<MarkAttendenceDrope> {
  bool isLoading=true;
  dynamic MyData;
  @override
  // void initState() {
  //   super.initState();
  //   fetchUserData(); // Fetch data on initialization if needed
  // }
  void show(String _userid,String _eventid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImageView(
          user: _userid,
          event: _eventid,
        );
      },
    );
  }
  Future<void> fetchEventUsersData() async {
    try {
      print("Fetching eventuser data...${widget.EvtId}");
      final _data=await ApiService().getMyEventUsersList(id: widget.EvtId);
      // Fetch data from API or other sources
      // Update widget.MyStu or other fields accordingly
      print(_data);
      createData(_data);
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
  void createData(dynamic _data){
    List<dynamic> _final=[];
    for (var id in widget.MyStu){
      print(id);
      if(_data.containsKey(id))_final.add(_data[id]);
    }
    print(_final);
    setState(() {
      MyData=_final;
      isLoading=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.bgcl,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          if (widget._isopen)isLoading?CircularProgressIndicator(): _buildItemList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: widget.ht,
      width: widget.wd,
      decoration: BoxDecoration(
        color: widget.hcl,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.wd / 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.faltu,
              style: TextStyle(
                color: Colors.black,
                fontSize: min(widget.wd / 16 + widget.ht / 16, 20),
              ),
            ),
            IconButton(
              onPressed: () {
                  widget._isopen = !widget._isopen;
                  if(widget._isopen){
                    fetchEventUsersData();
                  }
                  else {
                    isLoading=false;
                    setState(() {
                    });
                  }
              },
              icon: Icon(
                widget._isopen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemList() {
    return Column(
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
            children: [
              for (dynamic value in MyData)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.wd / 32,
                    vertical: widget.ht / 16,
                  ),
                  child: Row(
                    children: [
                      Mybutton(
                        value['Name'] ?? '',
                        w: widget.wd*0.6,
                        fs: widget.wd / 16 + widget.ht / 16,
                        bg: value['IsOk'] ? widget.atcl : widget.bgcl,
                        fg:Colors.black,
                        kaam: () {
                          setState(() {
                            value['IsOk'] = !value['IsOk'];
                          });
                        },
                      ),
                      IconButton(onPressed:()=>show(value['UserId'],value['EvtId']), icon: Icon(Icons.camera_alt))
                    ],
                  ),
                ),
              if(MyData.isEmpty)const Center(child: Text("No Submission")),
            ],
          ),
        ),
        if (widget.isnew && !MyData.isEmpty) _buildMarkAttendanceButton(),
      ],
    );
  }

  Widget _buildMarkAttendanceButton() {
    return Mybutton(
      "Mark Attendance",
      w: widget.wd,
      fs: widget.wd * 0.08,
      kaam: () async{
        for (dynamic value in MyData){
          await Accept().accept(UserId: value['UserId'], EvtId: value['EvtId'], IsOk: value['IsOk']);
          isLoading=false;
          setState(() {
            widget._isopen=false;
          });
        }
      },
    );
  }
}
