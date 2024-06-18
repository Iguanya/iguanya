// lib/services/api.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/account.dart';

class ApiService {
  final String baseUrl;
  final String apiKey;

  ApiService({required this.baseUrl, required this.apiKey});

  Future<List<Account>> fetchAccounts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/resource/Account'),
      headers: {'Authorization': 'token $apiKey'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Account.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load accounts');
    }
  }

  Future<void> syncAccount(Account account) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/resource/Account/${account.id}'),
      headers: {
        'Authorization': 'token $apiKey',
        'Content-Type': 'application/json'
      },
      body: json.encode(account.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to sync account');
    }
  }
}
