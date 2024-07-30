// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:dynamic_table_example/app/locator.dart';
import 'package:dynamic_table_example/dialogueType.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';


class MyViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();

  Future<void> showAlertDialog() async {
    await _dialogService.showDialog(
      title: 'Alert',
      description: 'This is an alert dialog',
      buttonTitle: 'OK',
    );
  }

  Future<List<dynamic>?> showFullScreenDialog() async {
  final result = await _dialogService.showCustomDialog(
    variant: DialogType.fullScreen,
  );

  if (result != null && result.data != null) {
    if (result.data is List<dynamic>) {
      final dataList = result.data as List<dynamic>;

      // Convert DateTime to string if present
      return dataList.map((item) {
        if (item is DateTime) {
          String formattedDate = formatDateTime(item);
          return formattedDate; // Convert DateTime to ISO 8601 string
        }
        return item.toString(); // Convert other types to string
      }).toList();
    } else if (result.data == 'delete') {
      // Handle delete action if necessary
      return null;
    }
  }
  return null;
}
}


String formatDateTime(DateTime dateTime) {
  DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.SSS'); // Define the date format
  return formatter.format(dateTime); // Format the DateTime object
}

class FullScreenAlertDialog extends StatefulWidget {
  final Function(DialogResponse) onDialogComplete;

  FullScreenAlertDialog({required this.onDialogComplete});

  @override
  _FullScreenAlertDialogState createState() => _FullScreenAlertDialogState();
}

class _FullScreenAlertDialogState extends State<FullScreenAlertDialog> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController infoController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedGender;

  Future<void> _selectDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null && selectedDate != _selectedDate) {
      setState(() {
        _selectedDate = selectedDate;
        dateController.text = "${selectedDate.toLocal().toIso8601String().split('T')[0]}"; // Format the date as yyyy-MM-dd
      });
    }
  }

  void _submitData() {
    final data = [
      Random().nextInt(500).toString(),
      nameController.text,
      _selectedDate ?? DateTime.now(), // Use DateTime object directly
      _selectedGender ?? 'Male', // Use selected gender
      infoController.text,
    ];
    widget.onDialogComplete(DialogResponse(data: data));
    // Navigator.of(context).pop();
  }

  void _deleteData() {
    widget.onDialogComplete(DialogResponse(data: 'delete'));
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(0),
      child: Container(
        width: MediaQuery.of(context).size.width - 20,
        height: MediaQuery.of(context).size.height - 250,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Update',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              ),
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Date',
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Gender',
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              ),
              items: ['Male', 'Female'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGender = newValue;
                });
              },
            ),
            SizedBox(height: 8),
            TextField(
              controller: infoController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Info',
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              ),
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _submitData,
                  child: Text('Submit'),
                ),
                ElevatedButton(
                  onPressed: _deleteData,
                  child: Text('Cancel'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 240, 134, 127),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}