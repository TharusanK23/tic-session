import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class ApiService {
  static const _baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Task>> fetchSampleTasks() async {
    final response = await http.get(Uri.parse('$_baseUrl/todos?_limit=5'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load tasks (${response.statusCode})');
    }
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((item) {
      final map = item as Map<String, dynamic>;
      return Task(
        id: 'api-${map['id']}',
        title: map['title'] as String,
        isDone: map['completed'] as bool,
        createdAt: DateTime.now(),
      );
    }).toList();
  }
}
