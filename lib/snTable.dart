import 'package:flutter/material.dart';

Widget snDataTable(data) {
  Map newData = {};
  for(var n in data['TestSteps']) {
    newData[n['Test_Description']] = {};
    newData[n['Test_Description']]['Test Step'] = n['Test_Description'];
    newData[n['Test_Description']]['Value'] = n['Value'];
      newData[n['Test_Description']]['Cycle_Time'] = n['Cycle_Time'];
      newData[n['Test_Description']]['LowerLimit'] = n['LL'];
      newData[n['Test_Description']]['UpperLimit'] = n['UL'];
      newData[n['Test_Description']]['Status'] = n['Status'];
  }
  //check to see if all fields are there, if not delete it.
  List<DataRow> dataRow = [];
  List<DataCell> dataCells = [];
  List<DataColumn> dataColumns = [];
  bool once = true;
 /* dataColumns.add(const DataColumn(
    label: Expanded(
      child: Text(
        "Test Step",
        style: TextStyle(fontStyle: FontStyle.italic),
      ),
    ),
  ));*/
  for(var n in newData.keys.toList()) {
    //dataCells.add(DataCell(Text(n)));
    for (var i = 0; i < newData[n].values.toList().length;i++) {
      if(once) {
        dataColumns.add(DataColumn(
          label: Expanded(
            child: Text(
              newData[n].keys.toList()[i],
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ));
      }
      dataCells.add(DataCell(Text(newData[n].values.toList()[i].toString(),style: TextStyle(color: newData[n].keys.toList()[i].toString() == "Status" ? newData[n].values.toList()[i].toString().contains("P") ? Colors.green:Colors.red:null),)));
    }
    dataRow.add(DataRow(cells: List.from(dataCells)));
    dataCells.clear();
    once = false;
  }
  return DataTable(
      columns: dataColumns,
      rows: dataRow
  );
}