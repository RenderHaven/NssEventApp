import "package:flutter/material.dart";
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/DataManagment/ApiService.dart';
import '../../DataManagment/DataManage.dart';
import '../Notification.dart';

class StuSett extends StatefulWidget {
  dynamic MyInfo = {};
  final String MyId;
  dynamic data = {};
  String ProfileImg = '';

  StuSett({this.MyId = "Stu_2201cs76"}) {
    print(MyInfo['ProfileImage']);
  }

  @override
  State<StuSett> createState() => _StuSettState();
}

class _StuSettState extends State<StuSett> {
  bool isUserLoading = true;
  File? _image;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      print("Fetching user data...for ${widget.MyId}");
      dynamic userdata = await Datamanage().refresh(widget.MyId);
      print(userdata);
      setState(() {
        widget.MyInfo = userdata['MyInfo'] ?? {};
        isUserLoading = false;
      });
      print("Got user data");
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> _pickImage() async {
    var pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      List<int> imageBytes = await pickedImage.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      widget.data['ProfileImage'] = base64Image;
      await ApiService().updateUser(id: widget.MyId, data: widget.data);
      setState(() {
        _image = File(pickedImage.path);
        fetchUserData();
      });
    }
  }

  void _showChangeNameDialog() {
    TextEditingController _nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Name'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: "Enter new name"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                String newName = _nameController.text;
                if (newName.isNotEmpty) {
                  setState(() {
                    widget.MyInfo['Name'] = newName;
                  });
                  widget.data['Name'] = newName;
                  await ApiService().updateUser(id: widget.MyId, data: widget.data);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildProfileSection(double scrht, double scrwd) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: scrht / 6,
              height: scrht / 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: (widget.MyInfo.isEmpty || widget.MyInfo['ProfileImage'] == null)
                      ? AssetImage('assets/Icon/profile.png')
                      : MemoryImage(base64Decode(widget.MyInfo['ProfileImage'])),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: scrht / 32,
                decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                child: IconButton(
                  onPressed: _pickImage,
                  icon: Icon(Icons.edit),
                  iconSize: scrht / 64,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: scrht / 64),
        isUserLoading
            ? CircularProgressIndicator()
            : Text(
          '${widget.MyInfo['Name']}\n${widget.MyInfo['Roll']}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: scrht / 64 + scrwd / 252,
          ),
        )
      ],
    );
  }

  Widget buildSettingsOptions(double scrht, double scrwd) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: _showChangeNameDialog,
          child: const Text(
            "Change Name",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        Divider(),
        TextButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationView(UserId: widget.MyId)));
          },
          child: const Text(
            "Notifications",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double scrwd = MediaQuery.of(context).size.width;
    double scrht = MediaQuery.of(context).size.height;
    return Material(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: scrht / 24, horizontal: scrwd / 32),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Container(width: scrwd / 2.4),
                  Text(
                    "Settings",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: scrwd / 32,
                    ),
                  ),
                ],
              ),
              SizedBox(height: scrht / 64),
              Container(
                height: scrht / 4,
                alignment: Alignment.center,
                child: buildProfileSection(scrht, scrwd),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: buildSettingsOptions(scrht, scrwd),
              ),
            ],
          ),
        ),
      ),
    );
  }
}