import 'package:flutter/material.dart';
import 'package:iot_dashboard/globals.dart';
import 'package:iot_dashboard/selectTime.dart';

Future<List> selectDate(BuildContext context, bool start) async {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
      DateTime now = DateTime.now();
  DateTimeRange? picked = await showDateRangePicker(
    confirmText: 'Submit',
      saveText: 'Submit',
      context: context,
      firstDate: DateTime(now.year, now.month - 1, now.day),
      lastDate: now,
      builder: (BuildContext context, Widget ? wChild) {
        return Theme(
            data: Globals().getCurrentTheme() ?
                 darkDatePickerTheme()
                : lightDatePickerTheme(),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height/1.2,
                    width: MediaQuery.of(context).size.width/3,
                    child: wChild,
                  ),
                ),
              ],
            ));
      }
  );
    if (picked != null) {
      startDate = picked.start;
    }
    else {
    if (picked != null) {
      endDate = picked.end;
    }
  }
  return [startDate,endDate];//await selectTime(context, start,startDate,endDate);
}

ThemeData lightDatePickerTheme() {
  return ThemeData(
    dialogTheme: const DialogTheme(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)))),
    colorScheme:const ColorScheme.light(primary: Colors.blueGrey),
    dialogBackgroundColor: Colors.white,
  );
}

ThemeData darkDatePickerTheme() {
  return ThemeData(
    dialogTheme: const DialogTheme(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)))),
    colorScheme: const ColorScheme.dark(primary: Colors.white),
    dialogBackgroundColor: Colors.blueGrey,
  );
}