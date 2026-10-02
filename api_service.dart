import 'dart:convert';

import 'package:http/http.dart' as http;

class Exercise {
  final int id;
  final String prompt;
  final List<String> options;

  Exercise.fromJson(Map<String, dynamic> j)
      : id = j['id'],
        prompt = j['prompt'],
        options = List<String>.from(j['options']);
}

class ApiService {
  static const _base = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://10.0.2.2:8000/api',
  );
  static const _json = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  Future<List<Exercise>> exercises({
    required int grade,
    required String subject,
    required String locale,
  }) async {
    final uri = Uri.parse('$_base/exercises').replace(
        queryParameters: {'grade': '$grade', 'subject': subject, 'locale': locale});
    final res = await http.get(uri, headers: _json);
    final list = jsonDecode(res.body) as List;
    return list.map((e) => Exercise.fromJson(e)).toList();
  }

  Future<bool> check(int id, String answer) async {
    final res = await http.post(
      Uri.parse('$_base/exercises/$id/check'),
      headers: _json,
      body: jsonEncode({'answer': answer}),
    );
    return jsonDecode(res.body)['correct'] as bool;
  }
}
