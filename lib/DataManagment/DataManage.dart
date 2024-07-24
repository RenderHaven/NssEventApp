
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:untitled/DataManagment/ApiService.dart';

class Datamanage {
  String data='';
  String _filePath='';
  final String _fileName='mydata.txt';

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  Future<dynamic> getdata() async {
    try {
      final file = await _localFile;
      print(file);
      if (!await file.exists()) {
        print("Local New user");
        return "New";
      }
      else {
        final contents = await file.readAsString();
        print("Local file is $contents");
        return jsonDecode(contents);
      }
    }catch (e) {
      print('Local Error reading data: $e');
      return "Error";
    }
  }

  Future<dynamic> refresh(String id) async{
    dynamic data;
    try {
      data = await ApiService().getData(id: id,src: 'users');
      writeData(data);
      print("Local refreshed");
    }catch(e){
      print("Local failed to refrehed $e");
      data=getdata();
    }
    print(data);
    return data;
  }

  Future<void> writeData(Map<String, dynamic> data) async {
    final file = await _localFile;
    await file.writeAsString(json.encode(data));
  }
}