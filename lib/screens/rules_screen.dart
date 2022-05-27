import 'package:flutter/material.dart';

class RulesScreen extends StatefulWidget {
  @override
  State<RulesScreen> createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00D99D),
      appBar: AppBar(
        title: Text('Reglamento'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 8, 69, 48),
      ),
      body: Center(
        child: Text('RulesScreen'),
      ),
    );
  }
}
