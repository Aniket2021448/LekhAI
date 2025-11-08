import 'package:flutter/material.dart';
import '../../../data/models/slip.dart';
import 'slip_list_screen.dart';

class SlipListByDateScreen extends StatelessWidget {
  final List<Slip> slips;
  const SlipListByDateScreen({super.key, required this.slips});

  @override
  Widget build(BuildContext context) {
    final byDate = <String, List<Slip>>{};

    for (var slip in slips) {
      final key = slip.date.toString().substring(0, 10);
      byDate.putIfAbsent(key, () => []).add(slip);
    }

    final dates = byDate.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(title: const Text("Select Date")),
      body: ListView.builder(
        itemCount: dates.length,
        itemBuilder: (_, i) {
          final date = dates[i];
          return ListTile(
            title: Text(date),
            trailing: Text("${byDate[date]!.length} slips"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SlipListScreen(slips: byDate[date]!),
              ),
            ),
          );
        },
      ),
    );
  }
}
