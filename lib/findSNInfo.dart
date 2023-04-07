import 'package:iot_dashboard/globals.dart';

Map findSNInfo(sn){
  Map tempData = rawFirebaseData["SerialNumbers"].firstWhere((element) => element['SerialNumber'] == sn,orElse: () => {});
  return tempData;
}