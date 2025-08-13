import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // reference the hive box
  final _myBox = Hive.box("mybox");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('History Page'), centerTitle: true),
      body: ValueListenableBuilder(
        valueListenable: _myBox.listenable(),
        builder: (context, value, child) {
          if (value.isEmpty) {
            return const Center(child: Text("Belum ada data absensi"));
          }
          return ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              var data = value.getAt(index) as Map;
              return ListTile(
                leading: Image.file(
                  File(data['photoPath']),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(data['dateTime']),
                subtitle: Text(
                  "Lat: ${data['latitude']}, Lng: ${data['longitude']}",
                  style: TextStyle(fontSize: 10),
                ),
                trailing: Text('Valid'),
              );
            },
          );
        },
      ),
    );
  }
}
