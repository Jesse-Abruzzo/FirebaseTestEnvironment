/*

import 'package:iot_dashboard/globals.dart';

Map getListOfType(site,key,type,Yields yieldObj){
  //find type of data it is
  if(type == "Supplier") {
      return getListOfAllSuppliers();
    }else if(type == 'Site') {
      return getListOfSites(site,type);
    } else if(type.toLowerCase() == 'bu') {
      return getListOfBu(site,type);
    }else if(type == 'Program') {
      return getListOfPrograms(site,yieldObj.bu);
    }else if(type == 'Process') {
      return getListOfProcesses(site,yieldObj.program);
    }else if(type == 'Station') {
      return getListOfStations(site,yieldObj.process);
    }
  return {};
}


*/
/*Map getListOfAllSites() {
  Set suppliersSite = {};
  Map tempMap = {};
  List<List<LineChartData>> tempData = [];
  for (var element in yields) {
    //print(element.supplier);
    if(element.site != 'NA') {
      tempData.add(element.yieldData);
      suppliersSite.add(element.site);
    }
  }
  tempMap['names'] = suppliersSite;
  tempMap['chartData'] = tempData;
  return tempMap;
}*//*


Map getListOfSites(site,type) {
  Set suppliersSite = {};
  Map tempMap = {};
  List<List<LineChartData>> tempData = [];
  var temp = yields.where((element) => element.site == site && element.type == 'Site');
  for (var element in temp) {
    //print(element.supplier);
    if(element.site != 'NA') {
      tempData.add(element.yieldData);
      suppliersSite.add(element.site);
    }
  }
  tempMap['names'] = suppliersSite;
  tempMap['chartData'] = tempData;
  return tempMap;
}

Map getListOfBu(site,type) {
  Set bu = {};
  Map tempMap = {};
  List<List<LineChartData>> tempData = [];
  var temp = yields.where((element) => element.site == site && element.type == 'bu');
  for (var element in temp) {
    bu.add(element.bu);
    tempData.add(element.yieldData);
  }
  tempMap['names'] = bu;
  tempMap['chartData'] = tempData;
  return tempMap;
}

double getLatestSiteYield(site){
  double siteYield = 0;
  //find supplier in yields list of object
  for(var i in yields){
    if(i.site == site && i.type == 'Site'){
      siteYield = i.yieldData.last.yield!;
      break;
    }
  }
  return siteYield;
}

Map getListOfAllBu(site) {
  Set bu = {};
  Map tempMap = {};
  List<List<LineChartData>> tempData = [];
  var temp = yields.where((element) => element.site == site && element.type == "bu");
  for (var element in temp) {
    bu.add(element.bu);
    tempData.add(element.yieldData);
  }
  tempMap['names'] = bu;
  tempMap['chartData'] = tempData;
  return tempMap;
}

double? getSupplierYield(supplier) {
  var temp = yields.where((element) => element.supplier == supplier && element.type == "Supplier");
  return temp.first.yieldData.last.yield;
}

Map getListOfAllSuppliers() {
  Set suppliers = {};
  Map tempMap = {};
  List<List<LineChartData>> tempData = [];
  for (var element in yields) {
    //print(element.supplier);
    tempData.add(element.yieldData);
    suppliers.add(element.supplier);
  }
  tempMap['names'] = suppliers;
  tempMap['chartData'] = tempData;
  return tempMap;
}

Map getListOfPrograms(site,[String bu = '']) {
  Set programs = {};
  Map tempMap = {};
  List<List<LineChartData>> tempData = [];
  var temp;
  if(bu == '' || bu == ""){
    bu = siteCardInfo[site]['userChoices']['bu'];
  }
  temp = yields.where((element) {
    return (element.site == site && element.type == "Program" && element.bu == bu);
  });
  for(var i in temp){
    tempData.add(i.yieldData);
    programs.add(i.program);
  }
  tempMap['names'] = programs;
  tempMap['chartData'] = tempData;
  return tempMap;
}

Map getListOfProcesses(site,[String program = '']) {
  Map tempMap = {};
  Set processes = {};
  List<List<LineChartData>> tempData = [];
  var temp;
  if(program == '' || program == ""){
    program = siteCardInfo[site]['userChoices']['Program'];
  }
  //siteCardInfo[site]['userChoices']['site']
  temp = yields.where((element) => element.site == site && program == element.program && element.type == "Process");
  for(var i in temp){
    tempData.add(i.yieldData);
    processes.add(i.process);
  }
  tempMap['names'] = processes;
  tempMap['chartData'] = tempData;
  return tempMap;
}

Map getListOfStations(site,[String process = '']) {
  Set stations = {};
  Map tempMap = {};
  List<List<LineChartData>> tempData = [];
  var temp;
  if(process == '' || process == ""){
    process = siteCardInfo[site]['userChoices']['Process'];
  }
  temp = yields.where((element) => element.site == site && process == element.process && element.type == "Station");
  for(var i in temp){
    tempData.add(i.yieldData);
    stations.add(i.station);
  }
  tempMap['names'] = stations;
  tempMap['chartData'] = tempData;
  return tempMap;
}
*/
