import 'package:flutter/material.dart';
import '../../../data/models/slip.dart';
import 'dart:io';

class SlipDetailScreen extends StatelessWidget {
  final Slip slip;
  const SlipDetailScreen({super.key, required this.slip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(slip.customerName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.file(File(slip.imagePath), height: 250, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(slip.structuredData.toString()),
          ],
        ),
      ),
    );
  }
}
