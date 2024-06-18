import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'utils/constants.dart'; // Ensure this file exists
import 'document.dart'; // Ensure this file exists

class Purchase extends StatelessWidget {
  const Purchase({Key? key}) : super(key: key);

  Future<List<Document>> fetchPurchaseDocuments() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/resource/Purchase Invoice'),
      headers: {'Authorization': 'token $apiKey:$apiSecret'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      return data.map<Document>((json) => Document(
        name: json['name'] ?? 'Unknown',
        primaryField: json['supplier_name'] ?? 'Unknown',
        status: json['status'] ?? 'Unknown',
        date: json['posting_date'] ?? 'Unknown',
        amount: json['grand_total'] ?? 0.0,
      )).toList();
    } else {
      throw Exception('Failed to load purchase documents');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Document>>(
      future: fetchPurchaseDocuments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Purchase')),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Purchase')),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Purchase')),
            body: const Center(child: Text('No purchases available')),
          );
        } else {
          return DocumentList(
              documents: snapshot.data!,
              title: 'Purchase'
          );
        }
      },
    );
  }
}
