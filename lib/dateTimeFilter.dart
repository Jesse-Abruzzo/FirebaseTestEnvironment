import 'package:iot_dashboard/globals.dart';
import 'package:intl/intl.dart';



bool dateTimeFilter(startTime,endTime,data){
  List temp = data!.where((element) {
    final date = DateFormat('yyyy-MM-dd HH:mm:ss').parse(element['date']);
    return date.isAfter(startTime) && date.isBefore(endTime);
  }).toList();
  if(temp.isNotEmpty){
    //chartInfo[key]['filtered'] = true;
    return true;
  }else{
    return false;
  }
  print('te');
}
