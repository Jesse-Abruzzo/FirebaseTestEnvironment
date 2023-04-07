import 'package:flutter/material.dart';
import 'package:iot_dashboard/globals.dart';
import 'package:iot_dashboard/selectDate.dart';

Future<List> selectTime(BuildContext context, bool start,DateTime startDate,DateTime endDate) async {
  TimeOfDay? picked =
  await showTimePicker(context: context,
      builder: (BuildContext context, Widget ?child) {
        return Theme(
            data: Globals().getCurrentTheme() == 1
                ? darkDatePickerTheme()
                : lightDatePickerTheme(),
            child: child ?? Text(""),);
      },initialTime: start ? TimeOfDay(hour: 24, minute: 00):TimeOfDay(hour: 23, minute: 59));
  if (picked != null) {
  if (start) {
  //update datetime with hour and min
  startDate = DateTime(startDate.year, startDate.month, startDate.day-1,picked.hour, picked.minute);
  } else {
  endDate = DateTime(endDate.year, endDate.month, endDate.day,picked.hour, picked.minute);
  }
  }
  return [startDate,endDate];
  //setState(() {});
}