import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ApiService {
  final String baseUrl = "http://192.168.183.52:5000"; // Adjust the URL as necessary

  Future<dynamic> getData({String id = "all", String src = 'users'}) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$src/$id'));
      print("Api Response status: ${response.statusCode}");
      print("Api Response body: ${response.body}");
      if (response.statusCode == 200) {
        dynamic userdata = jsonDecode(response.body);
        return userdata;
      } else {
        print("Api Failed to load users: ${response.reasonPhrase}");
        throw Exception('Api Failed to load users');
      }
    } catch (e) {
      print("Api Error occurred: $e");
      return {}; // Return an empty map on error
    }
  }

  Future<dynamic> getDataList({String src = 'users', String id = 'all'}) async {
    try {
      String path = (src == 'users') ? '$baseUrl/userslist/$id' : '$baseUrl/eventslist';
      final response = await http.get(Uri.parse(path));
      print("Api Response status: ${response.statusCode}");
      print("Api Response body: ${response.body}");
      if (response.statusCode == 200) {
        dynamic eventdata = jsonDecode(response.body);
        print("APi Decoded user data: $eventdata");
        return eventdata;
      } else {
        print("Api Failed to load users: ${response.reasonPhrase}");
        throw Exception('Api Failed to load users');
      }
    } catch (e) {
      print("Api Error occurred: $e");
      return {}; // Return an empty map on error
    }
  }

  Future<dynamic> getMyEventList({required String id}) async {
    try {
      String path = '$baseUrl/myeventslist/$id';
      final response = await http.get(Uri.parse(path));
      print("Api Response status: ${response.statusCode}");
      print("Api Response body: ${response.body}");
      if (response.statusCode == 200) {
        dynamic eventdata = jsonDecode(response.body);
        print("APi Decoded events data: $eventdata");
        return eventdata;
      } else {
        print("Api Failed to load events: ${response.reasonPhrase}");
        throw Exception('Api Failed to load events');
      }
    } catch (e) {
      print("Api Error occurred: $e");
      return []; // Return an empty list on error
    }
  }

  Future<dynamic> addEvent({dynamic data}) async {
    var url = Uri.parse('$baseUrl/events/add');
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode(data);

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print('Api Event added successfully');
        print(response.body);
        return jsonDecode(response.body);
      } else {
        print('Api Failed to add event. Error: ${response.reasonPhrase}');
        return {};
      }
    } catch (e) {
      print("Api Error occurred: $e");
      return {};
    }
  }

  Future<void> updateUser({required dynamic data, required String id}) async {
    var url = Uri.parse('$baseUrl/users/update/$id');
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode(data);

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print("Api User Updated");
      } else {
        print("Api Failed to update user: ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      print("Api Error updating user: $e");
    }
  }

  Future<void> uploadImage({required dynamic data}) async {
    var url = Uri.parse('$baseUrl/events/addimg');
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode(data);

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print("Api Image Uploaded");
      } else {
        print("Api Failed to Upload: ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      print("Api Error uploading: $e");
    }
  }

  Future<dynamic> getEventImage({required String user_id, required String event_id}) async {
    try {
      var url = Uri.parse('$baseUrl/events/getimg');
      var headers = {'Content-Type': 'application/json'};
      var data = {
        'EventId': event_id,
        'UserId': user_id,
      };

      var body = jsonEncode(data);
      var response = await http.post(url, headers: headers, body: body);
      print("Api Response status: ${response.statusCode}");
      print("Api Response body: ${response.body}");
      if (response.statusCode == 200) {
        dynamic userdata = jsonDecode(response.body);
        return userdata;
      } else {
        print("Api Failed to load users: ${response.reasonPhrase}");
        throw Exception('Api Failed to load users');
      }
    } catch (e) {
      print("Api Error occurred: $e");
      return 'fail'; // Return 'fail' on error
    }
  }

  Future<dynamic> getMyEventUsersList({required String id}) async {
    try {
      String path = '$baseUrl/eventuserslist/$id';
      print(path);
      final response = await http.get(Uri.parse(path));
      print("Api Response status: ${response.statusCode}");
      print("Api Response body: ${response.body}");
      if (response.statusCode == 200) {
        dynamic eventdata = jsonDecode(response.body);
        print("APi Decoded events data: $eventdata");
        return eventdata;
      } else {
        print("Api Failed to load events: ${response.reasonPhrase}");
        throw Exception('Api Failed to load events');
      }
    } catch (e) {
      print("Api Error occurred: $e");
      return []; // Return an empty list on error
    }
  }

  Future<dynamic> deleteMyEventList({required String UserId, required String EventId}) async {
    try {
      String path = '$baseUrl/deletemyevent/$UserId/$EventId';
      print(path);
      final response = await http.get(Uri.parse(path));
      print("Api Response status: ${response.statusCode}");
      print("Api Response body: ${response.body}");
      if (response.statusCode == 200) {
        dynamic eventdata = jsonDecode(response.body);
        print("APi Decoded events data: $eventdata");
        return true;
      } else {
        print("Api Failed to load events: ${response.reasonPhrase}");
        throw Exception('Api Failed to load events');
      }
    } catch (e) {
      print("Api Error occurred: $e");
      return []; // Return an empty list on error
    }
  }

  Future<void> addNote({dynamic data}) async {
    var requiredFields = ['Receiver', 'EventId', 'Note', 'Hours', 'Type'];
    for (var field in requiredFields) {
      if (!data.containsKey(field)) {
        data[field] = '';  // Assign an empty string if the field is missing
      }
    }
    var url = Uri.parse('$baseUrl/notes/add');
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode(data);

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print('Api Event added successfully');
        print(response.body);
      } else {
        print('Api Failed to add event. Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print("Api Error occurred: $e");
    }
  }

  Future<dynamic> getNote({required String userid}) async {
    try {
      var response = await http.get(Uri.parse('$baseUrl/notes/get/$userid'));
      if (response.statusCode == 200) {
        print('Api Note successfully');
        print(response.body);
        return jsonDecode(response.body);
      } else {
        print('Api Failed to get note. Error: ${response.reasonPhrase}');
        return [];
      }
    } catch (e) {
      print("Api Error occurred: $e");
      return [];
    }
  }
}
