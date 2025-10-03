import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_tracker/cubit/theme_cubit/theme_cubit.dart';
import 'package:my_tracker/db_controller/db_controller.dart';
import 'package:my_tracker/themes.dart';
import 'package:open_file_manager/open_file_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../cubit/expenses_cubit/expenses_cubit.dart';
import '../utils/dialogs.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.tab});
  final int tab;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<bool> requestStoragePermission() async {
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      status = await Permission.manageExternalStorage.request();
    }
    return status.isGranted;
  }

  Future<File?> getLocalFile(String fileName) async {
    var result = await requestStoragePermission();

    if (result == true) {
      // 1. Get the path to the Documents directory.
      final directory = await getExternalStorageDirectory();
      // getApplicationDocumentsDirectory();
      if (directory == null) {
        // Handle case where Downloads directory is not available (e.g., on iOS/Web)
        return null;
      }
      // 2. Combine the path with your desired file name.
      final path = "/storage/emulated/0/Download";
      // directory.path;
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

  importJson() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: [],
      type: FileType.custom,
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      Uint8List jsonBytes = file.readAsBytesSync();
      
      // jsonDecode(await file.readAsString());
      await DbController.importExpenses(jsonBytes).whenComplete(() {
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            content: Text("Imported: ${result.files.single.path}", style: lighttitlestyle(context).copyWith(color: Colors.blueAccent),
          )));
          reloadDb();
        }
      });
    } else {
      // User canceled the picker
    }
  }

  reloadDb() async {
    if (widget.tab == 0) {
      context.read<ExpensesCubit>().fetchExpenses();
    } else if (widget.tab == 1) {
      context.read<ExpensesCubit>().fetchExpensesToday();
    } else {
      context.read<ExpensesCubit>().fetchExpensesThisMonth();
    }
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text("Settings", style: titlestyle(context).copyWith(color: Colors.blueAccent)),
      ),
      body: BlocBuilder<ThemeCubit, bool>(
        builder: (context, state) {
          return Column(
            children: [
              ListTile(
                leading: Icon(Icons.dark_mode_rounded),
                title: Text("Dark theme", style: lighttitlestyle(context)),
                trailing: Switch.adaptive(
                  value: state,
                  onChanged: (value) {
                    // bool val = !value;
                    context.read<ThemeCubit>().toggleTheme();
                  },
                ),
              ),
              ListTile(
                leading: Icon(Icons.upload_rounded),
                title: Text("Import Data", style: lighttitlestyle(context)),
                onTap: () {
                  importJson();
                },
              ),
              ListTile(
                leading: Icon(Icons.download_rounded),
                title: Text("Export Data", style: lighttitlestyle(context)),
                onTap: () async {
                  List<Map<String, dynamic>> data = await DbController()
                      .exportExpenses();
                  await saveJsonData(data).whenComplete(() {
                    if(context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        action: SnackBarAction(label: "Open", onPressed: () {
                          openFileManager(
                            androidConfig: AndroidConfig(
                              folderPath: "/storage/emulated/0/Download",
                              folderType: AndroidFolderType.download
                            ),
                          );
                        }),
                        content: Text("Exported: /storage/emulated/0/Download/isar_backup_expenses.json", style: lighttitlestyle(context).copyWith(color: Colors.blueAccent),
                      )));
                    }
                  },);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_forever_rounded),
                title: Text("Delete All", style: lighttitlestyle(context)),
                onTap: () async {
                  CustomDialogs.deleteDialog(
                    context, 
                    title: "Delete All?", 
                    content: "Are you sure you want to delete all your expenses data?",
                    onPressed: () async {
                      await DbController.deleteAllExpenses().whenComplete(() => reloadDb());
                      if(context.mounted) Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
