import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/pages/Mentor/MarkAttendenceDrope.dart';
import 'package:untitled/pages/Tools/EventDetails.dart';
import '../../DataManagment/ApiService.dart';
import '../Tools/MyButton.dart';
import '../Tools/EventImageView.dart';
class EventView extends StatefulWidget {
  final bool isment;
  final bool isgen;
  final String userid;
  final String mentorid;
  final String EvtId;
  final bool isuploded;
  final bool isnew;
  final dynamic MyStu;

  EventView({
    required this.EvtId ,
    this.isuploded = false,
    this.isment = false,
    this.isgen = false,
    this.userid = 'none',
    this.mentorid='none',
    this.isnew=false,
    this.MyStu,
  });

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  File? _image;
  final picker = ImagePicker();

  @override

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> submit() async {
    if (_image == null) return;

    try {
      final imageBytes = await _image!.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      final _data = {
        'UserId': widget.userid,
        'EventId': widget.EvtId ?? 'Null',
        'Image': base64Image,
      };
      await ApiService().uploadImage(data: _data);
      await ApiService().addNote(data: {
        'Receiver': ['${widget.mentorid}%'],
        'Sender':widget.userid,
        'EventId': widget.EvtId,
        'Note': 'New Submission',
        'Hours': 3,
        'Type': 'NewSub'
      });
      Navigator.of(context).pop();
      //print(newEvent);
      //Navigator.pop(context);
      //setState(() {});
    } catch (e) {
      print('Error uploading image: $e');
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
  Widget _buildImageUploadSection(double scrwd) {
    return _image == null
        ? Column(
      children: [
        widget.isuploded
            ? Mybutton("SEE SUBMISSION", w: scrwd / 1.2, fs: scrwd / 24, kaam: show)
            : Mybutton("UPLOAD IMAGE", w: scrwd / 1.2, fs: scrwd / 24, kaam: pickImage),
      ],
    )
        : Column(
      children: [
        Image.file(_image!),
        Mybutton('SUBMIT', kaam: submit),
      ],
    );
  }

  Widget _buildActionButton(double scrwd) {
    if (widget.isgen) {
      return Mybutton("Generate Report", w: scrwd / 1.2, fs: scrwd / 24);
    } else if (widget.isment) {
      return Column(
        children: [
          MarkAttendenceDrope(EvtId: widget.EvtId, MyStu: widget.MyStu, faltu:'View Submission',wd:400,hcl: Colors.blue,isnew: widget.isnew,)
        ],
      );
    } else {
      return _buildImageUploadSection(scrwd);
    }
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
            EventDetails(EvtId: widget.EvtId),
            SizedBox(height: scrht / 4),
            _buildActionButton(scrwd),
          ],
        ),
      ),
    );
  }
}
