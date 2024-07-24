import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:untitled/DataManagment/ApiService.dart';

class ImageView extends StatefulWidget {
  String user;
  String event;

  ImageView({this.user='Stu_2201cs76', this.event='Evt2'});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  bool isLoading = true;
  dynamic myevt;
  String? img;

  @override
  void initState() {
    super.initState();
    fetchImageData();
  }

  void fetchImageData() async {
    try {
      dynamic data = await ApiService().getEventImage(user_id: widget.user, event_id: widget.event);
      setState(() {
        myevt=data;
        img = data['Image'];
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching image data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Dialog(
        backgroundColor: Colors.white54,
        insetPadding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: isLoading
                  ? CircularProgressIndicator()
                  : img != null
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Event Name:-${myevt['EventName']??'Unkown'}'),
                      Text('User Name:-${myevt['UserName']??'Unkown'}'),
                      SizedBox(
                        height: 500, // Set the desired height
                        child: Image.memory(
                          base64Decode(img!),
                          fit: BoxFit.cover, // Adjust the fit as needed
                        ),
                      ),
                      Text(myevt['comment']??''),
                    ],
                  )
                  : Text("No_data"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
