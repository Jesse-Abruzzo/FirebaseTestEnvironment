import 'globals.dart';

String getKeyBasedOnType(String type,Yields object){
  switch(type){
    case 'Supplier':
      return object.supplier;
    case 'Site':
      return object.site;
    case 'bu':
      return object.bu;
    case 'Program':
      return object.program;
    case 'Process':
      return object.process;
    case 'Station':
      return object.station;
    default:
      return 'NA';
  }
}