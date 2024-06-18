// lib/document.dart

import 'package:flutter/material.dart';
import 'add_document.dart'; // Ensure this file exists for adding documents

class Document {
  final String name;
  final String primaryField;
  final String status;
  final String date;
  final double amount;

  Document({
    required this.name,
    required this.primaryField,
    required this.status,
    required this.date,
    required this.amount,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      name: json['name'] ?? 'Unknown',
      primaryField: json['supplier_name'] ?? json['customer_name'] ?? 'Unknown',
      status: json['status'] ?? 'Unknown',
      date: json['posting_date'] ?? 'Unknown',
      amount: json['grand_total'] ?? 0.0,
    );
  }
}

class DocumentList extends StatelessWidget {
  final List<Document> documents;
  final String title;

  const DocumentList({super.key, required this.documents, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) {
          Document document = documents[index];
          return Card(
            margin: EdgeInsets.all(10.0),
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.person, size: 16),
                      SizedBox(width: 5),
                      Text(document.primaryField),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16),
                      SizedBox(width: 5),
                      Text(document.date),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.monetization_on, size: 16),
                      SizedBox(width: 5),
                      Text('Amount: \$${document.amount.toStringAsFixed(2)}'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Status: ${document.status}',
                    style: TextStyle(
                      color: document.status == 'Paid' ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddDocumentForm(title: title)),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
