/*
import 'package:cloud_firestore/cloud_firestore.dart';

emailSettingsFireStore() async {
  List<String> temp = [];
  CollectionReference _cat = FirebaseFirestore.instance.collection("EmailSettings");
  QuerySnapshot querySnapshot = await _cat.get();
  List _docData = querySnapshot.docs.map((doc) => doc.data()).toList();
  if(_docData.length >= 2) {
    temp = _docData[0].keys.toList();
    temp.sort((a, b) => a.toString().compareTo(b.toString()));
    subCatMaterials = temp;
    temp = _docData[1].keys.toList();
    temp.sort((a, b) => a.toString().compareTo(b.toString()));
    subCatTools = temp;
  }
}*/
