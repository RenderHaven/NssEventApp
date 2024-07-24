import 'package:flutter/material.dart';
import 'package:untitled/DataManagment/ApiService.dart';
import 'package:untitled/pages/Tools/MyButton.dart';
import 'package:untitled/pages/Tools/MyDropeDown.dart';
import 'package:intl/intl.dart';
class Addevent extends StatefulWidget {
  @override
  State<Addevent> createState() => _AddeventState();
}

class _AddeventState extends State<Addevent> {
  DateTime _selectedDate = DateTime.now();
  String _date="Date";
  // Controllers for capturing user input
  Map<String, dynamic> data = {
    "Name": TextEditingController(),
    "Date":TextEditingController(),
    "Time": TextEditingController(),
    "Venue": TextEditingController(),
    "Description": TextEditingController(),
  };

  @override
  void dispose() {
    // Dispose of controllers when not needed anymore
    data.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double scrwd = MediaQuery.of(context).size.width;
    double scrht = MediaQuery.of(context).size.height;

    return Material(
      child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: scrwd / 12, horizontal: scrwd / 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: scrwd / 16),
                Text(
                  "Add Event",
                  style: TextStyle(
                    fontSize: scrwd / 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: scrwd / 16),
                _buildFormFields(scrwd,context),
                SizedBox(height: scrwd / 16),
                _buildDropDown(scrwd),
                SizedBox(height: scrwd / 12),
                _buildSubmitButton(scrwd),
              ],
            ),
          ),
        ),
    );
  }

  Widget _buildFormFields(double scrwd,BuildContext cont) {
    List<Widget> formWidgets = [];

    data.forEach((key, value) {
      if (key != 'Date') {
        formWidgets.add(
          Column(
            children: [
              Container(
                width: scrwd / 1.1,
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: scrwd / 32),
                  child: TextFormField(
                    maxLines: key == 'Description' ? null : 1,
                    decoration: InputDecoration(
                      labelText: "$key",
                    ),
                    controller: value,
                  ),
                ),
              ),
              SizedBox(height: scrwd / 16),
            ],
          ),
        );
      } else {
        // Display date picker using InkWell
        formWidgets.add(
          Column(
            children: [
              Container(
                width: scrwd / 1.1,
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: scrwd / 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_date),
                      IconButton(onPressed:()=>_selectDate(context), icon: Icon(Icons.calendar_month))
                    ],
                  ),
                ),
              ),
              SizedBox(height: scrwd / 16),
            ],
          ),
        );
      }
    });

    return Column(
      children: formWidgets,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    print("hii");
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _date= DateFormat('dd-MM-yy').format(_selectedDate);
      });
    }
  }

  Widget _buildDropDown(double scrwd) {
    return MyDropeDown(
      iteam: const [
        "Adhyayan",
        "Technical Skills",
        "Rural Development",
        "Chetana",
        "Teaching",
        "Environmental",
        "Prayatna"
      ],
      ismulti: false,
      bgcl: Colors.white,
      wd: scrwd / 1.1,
      faltu: "Wing",
      hcl: Colors.cyan,
    );
  }

  Widget _buildSubmitButton(double scrwd) {
    return Mybutton(
      "Add Event",
      w: scrwd / 1.1,
      kaam: () async {
        try {
          var venue = data['Venue']?.text ?? '';
          if (venue.isNotEmpty) venue = 'VENUE IS :$venue\n';
          dynamic newEvent = {
            'name': data['Name']?.text ?? '',
            'date': _date ?? '',
            'time':data['time']?.text??'',
            'wing': 'papa',
            'description': venue + (data['Description']?.text ?? ''),
          };
          newEvent=await ApiService().addEvent(data: newEvent);
          await ApiService().addNote(data: {
            'Receiver': ['Stu%','Men%'],
            'EventId': newEvent['event_id'],
            'Note': 'New Event ${newEvent['name']}',
            'Hours': 3,
            'Type': 'NewEvt'
          });
          Navigator.of(context).pop();
          print(newEvent);
        } catch (e) {
          print(e);
          setState(() {});
        }
      },
    );
  }
}
