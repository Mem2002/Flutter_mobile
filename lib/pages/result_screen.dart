import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/utils/constants.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const bgColor = Color(0xfffafafa);
class ResultScreen extends StatefulWidget {
  final String code;
  final Function() closeScreen;

  const ResultScreen({
    super.key,
    required this.code,
    required this.closeScreen,
  });

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
    _sendCodeToBackend(widget.code); 
  }

  Future<void> _sendCodeToBackend(String code) async {
    final url = Uri.parse('${Constants.baseUrl}/qr-scanner'); 
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'code': code,
        }),
      );
      if (response.statusCode == 200) {
        _showSnackBar('Successful attendance');
      } else {
        _showSnackBar('Error when checking in: ${response.body}');
      }
    } catch (e) {
      _showSnackBar('Error sending request: $e');
    }
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message), 
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "QR Scanner",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
