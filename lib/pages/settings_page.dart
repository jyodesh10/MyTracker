import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_tracker/db_controller/db_controller.dart';
import 'package:my_tracker/themes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  Future<bool> requestStoragePermission() async {
    // var status = await Permission.storage.status;
    // if (!status.isGranted) {
      var status = await Permission.storage.request();
    // }
    return status.isGranted;
  }
  
  Future<File?> getLocalFile(String fileName) async {
    var result = await requestStoragePermission();

    if(result == true) {
      // 1. Get the path to the Documents directory.
      final directory = await getDownloadsDirectory(); 
      // getApplicationDocumentsDirectory();
      if (directory == null) {
        // Handle case where Downloads directory is not available (e.g., on iOS/Web)
        return null;
      }
      // 2. Combine the path with your desired file name.
      final path = directory.path;
      return File('$path/$fileName');
    } else {
      return null;
    }
  }

  // Example of using it to save your JSON data
  Future<void> saveJsonData(List<Map<String, dynamic>> jsonData) async {
      // Convert the List of Maps to a JSON string
      final jsonString = jsonEncode(jsonData);

      // Get the file reference
      final file = await getLocalFile('isar_backup_expenses.json');

      // Write the string to the file
      await file?.writeAsString(jsonString);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings", style: titlestyle,),
      ),
      body: Column(children: [
        ListTile(
          leading: Icon(Icons.download_rounded),
          title: Text("Export Data", style: lighttitlestyle,),
          onTap: () async {
             List<Map<String, dynamic>> data = await DbController().exportUsersToJson();
             saveJsonData(data);
          },
        ),
        ListTile(
          leading: Icon(Icons.dark_mode_rounded),
          title: Text("Select Theme", style: lighttitlestyle,),
        ),
      ],),
    );
  }
}