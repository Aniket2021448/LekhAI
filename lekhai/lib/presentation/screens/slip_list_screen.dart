import 'package:flutter/material.dart';
import '../../../data/models/slip.dart';
import 'slip_detail_screen.dart';

class SlipListScreen extends StatelessWidget {
  final List<Slip> slips;
  const SlipListScreen({super.key, required this.slips});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Slips")),
      body: ListView.builder(
        itemCount: slips.length,
        itemBuilder: (_, i) {
          final slip = slips[i];
          return ListTile(
            title: Text(slip.structuredData['customer_name']),
            subtitle: Text(slip.date.toString().substring(0, 16)),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SlipDetailScreen(slip: slip)),
            ),
          );
        },
      ),
    );
  }
}
