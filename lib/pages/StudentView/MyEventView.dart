import 'package:flutter/material.dart';
import 'package:untitled/pages/Mentor/EventAccept.dart';
import 'package:untitled/pages/Tools/EventDetails.dart';
import '../../DataManagment/ApiService.dart';
import '../Tools/MyButton.dart';
import '../Tools/EventImageView.dart';

class MyEventView extends StatefulWidget {
  final bool isment;
  final bool isgen;
  final String userid;
  final String EvtId;

  MyEventView({
    required this.EvtId,
    this.isment = false,
    this.isgen = false,
    required this.userid,
  });

  @override
  State<MyEventView> createState() => _EventViewState();
}

class _EventViewState extends State<MyEventView> {
  int key_new=0;
  void accept(bool isok) async {
    try {
      final ans=await Accept().accept(UserId: widget.userid, EvtId: widget.EvtId, IsOk: isok);
      if(ans)Navigator.pop(context);
      setState(() {
        key_new+=1;
      });
    } catch (e) {
      print('Error accepting/decline  image: $e');
    }
  }

  void show() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImageView(
          user: widget.userid,
          event: widget.EvtId,
        );
      },
    );
  }

  Widget _buildActionButton(double scrwd) {
    return Column(
      children: [
        Mybutton(
          "SEE SUBMISSION",
          w: scrwd / 1.2,
          fs: scrwd / 24,
          kaam: show,
        ),
        if (widget.isment) ...[
          Mybutton(
            "Accept",
            w: scrwd / 1.2,
            fs: scrwd / 24,
            kaam: () => accept(true),
          ),
          Mybutton(
            "Decline",
            w: scrwd / 1.2,
            fs: scrwd / 24,
            kaam: () => accept(false),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double scrwd = MediaQuery.of(context).size.width;
    double scrht = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: scrht / 16, horizontal: scrwd / 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EventDetails(EvtId: widget.EvtId,key: ValueKey(key_new)),
            SizedBox(height: scrht / 4),
            _buildActionButton(scrwd),
          ],
        ),
      ),
    );
  }
}
