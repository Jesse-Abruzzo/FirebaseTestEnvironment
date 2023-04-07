import 'package:iot_dashboard/globals.dart';

String findSiteByKey(key){
    //find type of data it is
    for(var i in serialNumbers){
      if(i.supplier == key) {
        return i.site;
      }if(i.site == key) {
        return i.site;
      } else if(i.bu == key) {
        return i.site;
      }else if(i.program == key) {
        return i.site;
      }else if(i.process == key) {
        return i.site;
      }else if(i.Station == key) {
        return i.site;
      }else{

      }
    }
    return '';
  }