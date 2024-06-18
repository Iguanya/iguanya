// lib/edit_document.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'utils/constants.dart'; // Ensure this file exists
import 'document.dart'; // Ensure this file exists

class EditDocumentForm extends StatefulWidget {
  final Document document;

  const EditDocumentForm({super.key, required this.document});

  @override
  _EditDocumentFormState createState() => _EditDocumentFormState();
}

abstract class _EditDocumentFormState extends State<EditDocumentForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _primaryFieldController;
  late TextEditingController _statusController;
  late TextEditingController _dateController;
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.document.name);
    _primaryFieldController = TextEditingController(text: widget.document.primaryField);
    _statusController = TextEditingController(text: widget.document.status);
    _dateController = TextEditingController(text: widget.document.date);
    _amountController = TextEditingController(text: widget.document.amount.toString());
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.put(
        Uri.parse('$baseUrl/api/resource/${widget.document.name}'),
        headers: {
          'Authorization': 'token $apiKey:$apiSecret',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': _nameController.text,
          'supplier_name': _primaryFieldController.text,
          'customer_name': _primaryFieldController.text,
          'status': _statusController.text,
          'posting_date': _dateController.text,
          'grand_total': double.parse(_amountController.text),
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update document')),
        );
      }
    }
  }

