import 'package:flutter/material.dart';
import 'package:soccer_app/models/models.dart';

class MyPredictionsScreen extends StatefulWidget {
  final Token token;
  final User user;

  MyPredictionsScreen({required this.token, required this.user});

  @override
  State<MyPredictionsScreen> createState() => _MyPredictionsScreenState();
}

class _MyPredictionsScreenState extends State<MyPredictionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00D99D),
      appBar: AppBar(
        title: Text('Predicciones'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 8, 69, 48),
      ),
      body: Center(
        child: Text('MyPrediciotnsScreen'),
      ),
    );
  }
}
