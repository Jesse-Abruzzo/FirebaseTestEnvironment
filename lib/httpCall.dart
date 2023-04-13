import 'dart:convert' as convert;
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iot_dashboard/globals.dart';



Future<Map> httpYieldSpecificCall(type,supplier,site,bu,program,process,station,{String dateRange = ''}) async {
  //build url
  String path = '/getYield';
  Map<String,String> parameters = {};
  http://10.63.22.17:8000/jsontree/
  switch (type){
    case 'Supplier':
      parameters['Type'] = 'Supplier';
      parameters['Supplier'] = supplier;
      break;
    case 'Site':
      parameters['Type'] = 'Site';
      parameters['Supplier'] = supplier;
      parameters['Site'] = site;
      break;
    case 'bu':
      parameters['Type'] = 'BU';
      parameters['Supplier'] = supplier;
      parameters['Site'] = site;
      parameters['BU'] = bu;
      break;
    case 'Program':
      parameters['Type'] = 'Product_Family';
      parameters['Supplier'] = supplier;
      parameters['BU'] = bu;
      parameters['Site'] = site;
      parameters['Product_Family'] = program;
      break;
    case 'Process':
      parameters['Type'] = 'Process';
      parameters['Supplier'] = supplier;
      parameters['Site'] = site;
      parameters['BU'] = bu;
      parameters['Product_Family'] = program;
      parameters['Process'] = process;
      break;
    case 'Station':
      parameters['Type'] = 'Station';
      parameters['Supplier'] = supplier;
      parameters['Site'] = site;
      parameters['BU'] = bu;
      parameters['Product_Family'] = program;
      parameters['Process'] = process;
      parameters['Station'] = station;
  }
  var url = Uri.http(httpIP,path,parameters);
 // print(path);
  print(url);

  // Await the http get response, then decode the json-formatted response.
  var response = await http.get(url);
  if (response.statusCode == 200 && response.body != null) {
    Map<String,dynamic> yieldData = convert.jsonDecode(response.body);
    //combine into yields Map
      if(type.toLowerCase() == "supplier") {
        yields[supplier].addAll(yieldData);
      }else if(type.toLowerCase() == 'site') {
        yields[supplier][site].addAll(yieldData);
      } else if(type.toLowerCase() == 'bu') {
        yields[supplier][site][bu].addAll(yieldData);
      }else if(type.toLowerCase() == 'program') {
        yields[supplier][site][bu][program].addAll(yieldData);
      }else if(type.toLowerCase() == 'process') {
        yields[supplier][site][bu][program][process].addAll(yieldData);
      }else if(type.toLowerCase() == 'station') {
        yields[supplier][site][bu][program][process][station].addAll(yieldData);
      }
    return {'status':true,'code':response.statusCode};
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return {'status':false,'code':response.statusCode};
  }

}

Future<Map> httpGetTopicNames({String fromDate = '',String toDate = ''}) async {
  var url = Uri.http(httpIP,'/jsontree/');

  if(fromDate != ''){

  }
  if(toDate != ''){

  }

  // Await the http get response, then decode the json-formatted response.
  var response = await http.get(url);
  if (response.statusCode == 200) {
    yieldNamesRaw = convert.jsonDecode(response.body);
    //combine into yields Map
    yields = Map.from(yieldNamesRaw['Data']);
    return {'status':true,'code':response.statusCode};
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return {'status':false,'code':response.statusCode};
  }

}
