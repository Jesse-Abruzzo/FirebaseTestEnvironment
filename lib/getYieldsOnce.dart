
import 'package:firebase_database/firebase_database.dart';
import 'package:iot_dashboard/globals.dart';

Future<void> getYieldsOnce() async {
  DatabaseReference ref3 = FirebaseDatabase.instance.ref().child('Yields');
  var snapshot = await ref3.get();
  yields = snapshot.value! as Map<String,dynamic>;
}