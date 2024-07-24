import "package:flutter/material.dart";
import "package:untitled/pages/Baap/StudentDetails.dart";
import "package:untitled/pages/StudentView/StudentView.dart";

import "../../DataManagment/ApiService.dart";

class Studentlist extends StatefulWidget {
  String ByMentId;
  final bool isment;
  Studentlist({super.key,this.ByMentId='all',this.isment=false});
  @override
  State<Studentlist> createState() => _StudentlistState();
}

class _StudentlistState extends State<Studentlist> {
  dynamic stud;
  dynamic filteredStud;
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    fetchData();
    searchController.addListener(_filterUsers);
  }

  void fetchData() async {
    try {
      print("Fetching data...");
      stud = await ApiService().getDataList(src: 'users',id: widget.ByMentId);
      setState(() {
        filteredStud = stud;
        isLoading = false;
        print("Data fetched: $stud");
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _filterUsers() {
    setState(() {
    });
  }

  List<Widget> buildStuList() {
    String query = searchController.text.toLowerCase();
    double scrwd = MediaQuery.of(context).size.width;
    double scrht = MediaQuery.of(context).size.height;
    List<Widget> _result = [];
    try {
      for (dynamic value in filteredStud) {
        if((value['Name'].toString().toLowerCase()).startsWith(query)) {
          _result.add(
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Studentdetails(UserId: value['UserId'],isment:widget.isment,)),
                ).then((_){
                  fetchData();
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: scrwd / 12, vertical: scrwd / 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          value['Name'] ?? 'User1',
                          style: TextStyle(
                            fontSize: scrht / 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          value['UserId'] ?? 'User',
                          style: TextStyle(
                            fontSize: scrht / 64,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "View\nDetails",
                      style: TextStyle(
                        fontSize: scrht / 42,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }
    } catch (e) {
      print('Error is: $e');
    }
    return _result;
  }

  @override
  Widget build(BuildContext context) {
    double scrwd = MediaQuery.of(context).size.width;
    double scrht = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(scrwd * 0.05),
      ),
      constraints: BoxConstraints(
        maxHeight: scrht / 1.6,
      ),
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(scrwd / 20),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search by name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(scrwd / 40),
                  ),
                ),
              ),
            ),
            ...buildStuList(),
          ],
        ),
      ),
    );
  }
}
