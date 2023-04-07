import 'package:flutter/material.dart';
import 'package:iot_dashboard/findSNInfo.dart';
import 'package:iot_dashboard/globals.dart';
import 'package:iot_dashboard/navService.dart';
import 'package:iot_dashboard/snTable.dart';

Map finalData = {};
showSerialNumberData(data){
  finalData = data;
  if(!snBar) {
    snBar = true;
    //filter out the other SNs from the data
    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: NavigationService.navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateModal) {
              if(finalData.isNotEmpty) {
                return  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(mainAxisAlignment:MainAxisAlignment.start,children: [
                        Container(padding: EdgeInsets.all(10), child:
                        Text(finalData['SerialNumber'] + ' ', style: TextStyle(color: finalData['Test_Status'] == 'P' ? Colors.green:finalData['Test_Status'] == 'I' ?Colors.blueAccent:Colors.redAccent,fontSize: 20))),
                        Row(children: [Text('Status: '),Text(finalData['Test_Status'] == 'P' ? 'Pass':finalData['Test_Status'] == 'I' ? 'Terminated Early':finalData['Test_Status'] == 'A' ? 'Aborted':finalData['Test_Status'], style: TextStyle(color: finalData['Test_Status'] == 'P' ? Colors.green:finalData['Test_Status'] == 'I' ?Colors.blueAccent:Colors.redAccent))]),
                        Container(padding: EdgeInsets.only(top:10,bottom:5), child: Text('Date: ' + finalData['Date'])),
                        Container(padding: EdgeInsets.all(5), child: Text('SKU: ' + finalData['SKUnumber'])),
                        finalData['Test_Status'] != 'P' ? Container(padding: EdgeInsets.all(5), child: Text(finalData['Failure_Mode'])) : SizedBox(),
                        Container(padding: EdgeInsets.all(5), child: Text('Prime: ' + finalData['Prime'].toString())),
                        Container(padding: EdgeInsets.all(5), child: Text('Supplier: ' + finalData['Supplier'])),
                        Container(padding: EdgeInsets.all(5), child: Text('Site: ' + finalData['Site'])),
                        Container(padding: EdgeInsets.all(5), child: Text('BU: ' + finalData['BU'])),
                        Container(padding: EdgeInsets.all(5), child: Text('Program: ' + finalData['Program'])),
                        Container(padding: EdgeInsets.all(5), child: Text('Process: ' + finalData['Process'])),
                        Container(padding: EdgeInsets.only(top:5,bottom: 20), child: Text('Station: ' + finalData['StationID'])),
                      ]),
                     SingleChildScrollView(child:Container(width: MediaQuery.of(context).size.width / 1.5, child: snDataTable(finalData)))
                    ]);
              }else{
                return SizedBox();
              }
            },
          );
        }).whenComplete(() {
      snBar = false;
    });
  }
}