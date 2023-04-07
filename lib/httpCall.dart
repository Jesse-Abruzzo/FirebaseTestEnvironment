import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:iot_dashboard/globals.dart';



Future<bool> httpYieldSpecificCall(type,supplier,site,bu,program,process,station,{String dateRange = ''}) async {
  //build url
  String urlAdd = '';
  http://10.63.22.17:8000/jsontree/
  switch (type){
    case 'Supplier':
      urlAdd = '/getYield?type=Supplier&supplier='+supplier;
      break;
    case 'Site':
      urlAdd = '/getYield?type=Supplier&supplier='+supplier+'&site='+site;
  }
  var url = Uri.http('10.63.22.17:8000',urlAdd);

  // Await the http get response, then decode the json-formatted response.
  var response = await http.get(url);
  if (response.statusCode == 200) {
    Map yieldData = convert.jsonDecode(response.body);
    //combine into yields Map
    yieldData.forEach((key, value) {
      if(type.toLowerCase() == "supplier") {
        yields[supplier][key] = value;
      }else if(type.toLowerCase() == 'site') {
        yields[supplier][site][key] = value;
      } else if(type.toLowerCase() == 'bu') {
        yields[supplier][site][bu][key] = value;
      }else if(type.toLowerCase() == 'program') {
        yields[supplier][site][bu][program][key] = value;
      }else if(type.toLowerCase() == 'process') {
        yields[supplier][site][bu][program][process][key] = value;
      }else if(type.toLowerCase() == 'station') {
        yields[supplier][site][bu][program][process][station][key] = value;
      }
    });
    return true;
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return false;
  }

}

Future<bool> httpGetTopicNames({String fromDate = '',String toDate = ''}) async {
  var url = Uri.http('10.63.22.17:8000','/jsontree/');

  if(fromDate != ''){

  }
  if(toDate != ''){

  }

  // Await the http get response, then decode the json-formatted response.
  var response = await http.get(url);
  if (response.statusCode == 200) {
    Map yieldNames = convert.jsonDecode(response.body);
    //combine into yields Map
    yields = yieldNames;
    return true;
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return false;
  }

}
