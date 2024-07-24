import "package:flutter/material.dart";
import "package:untitled/pages/Mentor/MarkAttendenceDrope.dart";
import "../../DataManagment/ApiService.dart";

class MarkAttendence extends StatefulWidget {
  final dynamic MyStu;

  MarkAttendence({Key? key, required this.MyStu}) : super(key: key);

  @override
  State<MarkAttendence> createState() => _MarkAttendenceState();
}

class _MarkAttendenceState extends State<MarkAttendence> {
  late dynamic evts=[];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      evts = await ApiService().getDataList(id: 'all', src: 'events');
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
      // Handle error state or show a message to the user
    }
  }
  List<Widget> buildEventList() {
    double scrWd = MediaQuery.of(context).size.width;
    double scrHt = MediaQuery.of(context).size.height;

    List<Widget> result = [];
    // if(evts.isEmpty){
    //   result.add(Text("NOTHING"));
    //   return result;
    // }
    for (dynamic value in evts) {
      result.add(
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: scrWd / 12,
            vertical: scrWd / 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value["Name"]??'N/A',
                style: TextStyle(
                  fontSize: scrHt / 64,
                  fontWeight: FontWeight.bold,
                ),
              ),
              MarkAttendenceDrope(
                ht: scrWd / 8,
                wd: scrWd / 2.5,
                faltu: "Mark\nAttendance",
                EvtId: value["EvtId"],
                MyStu: widget.MyStu,
                isnew: value['IsNew']??true,
              ),
            ],
          ),
        ),
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    double scrWd = MediaQuery.of(context).size.width;
    double scrHt = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(scrWd * 0.05),
      ),
      constraints: BoxConstraints(
        maxHeight: scrHt / 1.2,
      ),

      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : (widget.MyStu==Null)
          ? Center(child: Text("No Students"))
          : SingleChildScrollView(
        child: Column(
          children: buildEventList(),
        ),
      ),
    );
  }
}
