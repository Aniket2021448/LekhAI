import 'package:flutter/material.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/models/slip.dart';
import 'slip_list_by_date_screen.dart';

class SlipGroupsScreen extends StatelessWidget {
  const SlipGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Slip>>(
      future: StorageService().getAllSlips(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        final slips = snapshot.data!;
        final groups = <String, List<Slip>>{};

        for (var slip in slips) {
          groups.putIfAbsent(slip.customerName, () => []).add(slip);
        }

        final customerNames = groups.keys.toList();

        return Scaffold(
          appBar: AppBar(title: const Text("Saved Slips")),
          body: ListView.builder(
            itemCount: customerNames.length,
            itemBuilder: (_, i) {
              final name = customerNames[i];
              return ListTile(
                title: Text(name),
                trailing: Text("${groups[name]!.length} slips"),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SlipListByDateScreen(slips: groups[name]!),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
