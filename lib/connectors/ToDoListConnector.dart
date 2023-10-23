import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:to_do_list_app/models/ToDoListResponse.dart';
import 'package:to_do_list_app/models/DeleteResponse.dart';
import 'package:to_do_list_app/models/CreationResponse.dart';
import 'package:to_do_list_app/models/TaskRequest.dart';

Future<PaginatedResponse> fetchData() async {
    final response = await http.get(Uri.parse('http://localhost:9000/getItems'));

    try {
      return PaginatedResponse.fromJson(jsonDecode(response.body));
    } catch (e){
      throw Exception('Failed to load data $e');
    }

}

Future<DeleteResponse> deleteData(String id) async {
  final response = await http.delete(Uri.parse('http://localhost:9000/deleteItem?id=$id'));

  try {
    return DeleteResponse.fromJson(jsonDecode(response.body));
  } catch (e){
    throw Exception('Failed to load data $e');
  }
}

Future<CreationResponse> createTask(TaskRequest task) async {
  final String apiUrl = 'http://localhost:9000/createItem'; // Replace with your API endpoint

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(task.toJson()),
  );

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    return CreationResponse.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to create task'); // Handle the error as needed
  }
}

