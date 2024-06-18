import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'utils/constants.dart'; // Ensure this file exists
import 'document.dart'; // Ensure this file exists

class Sales extends StatelessWidget {
  const Sales({Key? key}) : super(key: key);

  Future<List<Document>> fetchSalesDocuments() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/resource/Sales Invoice'),
      headers: {'Authorization': 'token $apiKey:$apiSecret'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      return data.map<Document>((json) => Document(
        name: json['name'] ?? 'Unknown',
        primaryField: json['customer_name'] ?? 'Unknown',
        status: json['status'] ?? 'Unknown',
        date: json['posting_date'] ?? 'Unknown',  // Ensure this field matches your data
        amount: json['grand_total'] ?? 0.0,  // Ensure this field matches your data
      )).toList();
    } else {
      throw Exception('Failed to load sales documents');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Document>>(
      future: fetchSalesDocuments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Sales')),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Sales')),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Sales')),
            body: const Center(child: Text('No sales available')),
          );
        } else {
          return DocumentList(
              documents: snapshot.data!,
              title: 'Sales'
          );
        }
      },
    );
  }
}
