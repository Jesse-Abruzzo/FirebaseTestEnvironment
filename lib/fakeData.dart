import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:iot_dashboard/charts.dart';
import 'package:iot_dashboard/getKeyBasedOnObject.dart';
import 'package:iot_dashboard/globals.dart';
import 'package:iot_dashboard/httpCall.dart';
import 'package:iot_dashboard/pickChartToShow.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'initializeUserSiteInfo.dart';


int counter = 0;
bool clear = true;

Future<void> postData() async {

  //read data points
  /*DatabaseReference ref3 = FirebaseDatabase.instance.ref().child('Yields').child('JBL').child('GHZ').child('YieldData');
  var snapshot = await ref3.get();
  List temp = snapshot.value! as List;
  counter = temp.length;*/

  if(clear){
    DatabaseReference ref3 = FirebaseDatabase.instance.ref().child('Yields').child('JBL').child('GHZ').child('YieldData');
    ref3.remove();
    DatabaseReference ref4 = FirebaseDatabase.instance.ref().child('Yields').child('JBL').child('YieldData');
    ref4.remove();
    DatabaseReference ref5 = FirebaseDatabase.instance.ref().child('Yields').child('USI').child('YieldData');
    ref5.remove();
    clear = false;
  }

  //generate date
  final now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  double ran = Random().nextDouble() * 100;
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('Yields').child('JBL').child('GHZ').child('YieldData').child(counter.toString());

  await ref.update({
    "SerialNumber":'123456',
    "date":formattedDate,
    "yield":ran
  });

  double ran2 = Random().nextDouble() * 100;
  DatabaseReference ref2 = FirebaseDatabase.instance.ref().child('Yields').child('JBL').child('YieldData').child(counter.toString());

  await ref2.update({
    "SerialNumber":'123456',
    "date":formattedDate,
    "yield":ran2
  });

  double ran3 = Random().nextDouble() * 100;
  DatabaseReference ref5 = FirebaseDatabase.instance.ref().child('Yields').child('USI').child('YieldData').child(counter.toString());

  await ref5.update({
    "SerialNumber":'123456',
    "date":formattedDate,
    "yield":ran3
  });

  counter++;
}

