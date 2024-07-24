import 'package:flutter/material.dart';
import '../../DataManagment/ApiService.dart';
class EventDetails extends StatefulWidget {
  Map<String, dynamic> event={};
  final String EvtId;
  EventDetails({
    Key?key,
    required this.EvtId
  }): super(key: key);

  @override
  State<EventDetails> createState() => _EventViewState();
}

class _EventViewState extends State<EventDetails> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    print("in details section");
    fetchEventData();
  }

  Future<void> fetchEventData() async {
    try {
      final data = await ApiService().getData(id: widget.EvtId, src: 'events');
      setState(() {
        widget.event = data ?? {};
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }


  Widget _buildEventDetails(double scrwd) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.event["name"] ?? 'papa',
          style: TextStyle(fontSize: scrwd / 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: scrwd / 64),
        Container(
          alignment: Alignment.center,
          width: scrwd / 3.5,
          height: scrwd / 16,
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            widget.event["date"] ?? 'papa',
            style: TextStyle(fontSize: scrwd / 32, color: Colors.white),
          ),
        ),
        SizedBox(height: scrwd / 64),
        Text(
          widget.event["wing"] ?? 'papa',
          style: TextStyle(fontSize: scrwd / 24, fontWeight: FontWeight.bold),
        ),
        Container(
          width: scrwd / 1.2,
          child: Text(
            widget.event["description"] ?? 'papa',
            style: TextStyle(fontSize: scrwd / 24),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    double scrwd = MediaQuery.of(context).size.width;
    double scrht = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isLoading?CircularProgressIndicator():_buildEventDetails(scrwd),
        ],
      ),
    );
  }
}
