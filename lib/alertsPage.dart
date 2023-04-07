import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot_dashboard/getYieldsOnce.dart';
import 'package:iot_dashboard/mainSitesPage.dart';
import 'package:iot_dashboard/navService.dart';
import 'package:iot_dashboard/sideDrawer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'globals.dart';

final _formKey = GlobalKey<FormState>();
List loadingTiles = [];
bool loading = false;
Set allTopicNames = {};
List<String> allTopicNamesList = [];
List<String> topicMatches = [];
bool searchFocus = false;
TextEditingController topicController = TextEditingController();
List<String> triggerList = ['','Yield','RFTY'];
List<String> dateRangeList = ['','2 weeks','1 month'];
String selectedTrigger = '';
String selectedDateRange = '';
int maxAlerts = 3;


class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => AlertsPageState();
}

class AlertsPageState extends State<AlertsPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      floatingActionButton: Align(alignment: Alignment.bottomRight,child:Tooltip(message: userAlerts.length >= maxAlerts ? 'Max Alerts, delete one first':'',child:FloatingActionButton.extended(icon:Icon(Icons.add,color: Colors.blueGrey),backgroundColor:userAlerts.length < maxAlerts ? Colors.white:Colors.white38,label: const Text('Create Alert',style: TextStyle(color: Colors.blueGrey),),onPressed: userAlerts.length < maxAlerts ? (){addAlertMenu(context);}:null))),
        body: Row(children: [sideDrawer(),Expanded(child:Column(children: [
         Container(padding:EdgeInsets.all(15),alignment:Alignment.topLeft,child:Text('Alerts (' + userAlerts.length.toString() + '/' + maxAlerts.toString() + ')' ,style: TextStyle(fontSize: MediaQuery.of(context).size.width/30))),
          userAlerts.isEmpty ? Text('No Alerts Setup',style: TextStyle(fontSize: MediaQuery.of(context).size.width/35)):SizedBox(),
          Expanded(child:ListView.builder(
            shrinkWrap: true,
            itemCount: userAlerts.length,
            itemBuilder: (context, index) {
              return Dismissible(
                confirmDismiss: (DismissDirection direction) async {
                  return await deleteAlertDialog(index);
                },
                  background:slideLeftBackground(index),
              key: ValueKey<int>(index),
              onDismissed: (DismissDirection direction) async {

              },child:Padding(padding:EdgeInsets.all(10),child:ListTile(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                trailing: Row(mainAxisSize: MainAxisSize.min,children:[loadingTiles.length > index && loadingTiles[index] ? LoadingAnimationWidget.fourRotatingDots(color: Colors.white, size: 20):SizedBox(),
                  CupertinoSwitch(
                     onChanged:loadingTiles.length <= index || loadingTiles[index] == false ?(bool val) async {
                       if(loadingTiles.length > index) {
                         loadingTiles[index] = true;
                       }else{
                         loadingTiles.add(true);
                       }
                  setState(() {});
                  bool result = await updateAlert(userAlerts[index].dateRange, userAlerts[index].topic, userAlerts[index].trigger, val,index);
                  if(result) {
                    loadingTiles[index] = false;
                    setState(() {});
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Oops something when wrong, try again...')),);
                    setState(() {});
                  }
                }:null,value: userAlerts[index].enabled)]),
                leading: const Icon(Icons.email_outlined),
                title: Text(userAlerts[index].topic  + ' based on ' + userAlerts[index].trigger + ' for ' + userAlerts[index].dateRange),
              )));
            },
          )

          )]))]));
    }

    Future<void> addAlertMenu(context) async {
      //setup topic names into list
      allTopicNames.clear();
      //grab yields just incase its not loaded
      await getYieldsOnce();
      getAllTopics(yields);
      allTopicNamesList = List<String>.from(allTopicNames);
       // set up the buttons

       // show the dialog
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                actionsAlignment:  MainAxisAlignment.spaceBetween,
                title: Text("Create Alert"),
                content:   Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                    Form(
                    key: _formKey,
                    child:Row(
                      children: <Widget>[
                        const Text('Create an Alert for '),
                       Column(mainAxisAlignment:MainAxisAlignment.start,children:
                       [topicDropdown(setState,loading),
                        searchFocus ? Container(height:MediaQuery.of(context).size.height/4.8,width:MediaQuery.of(context).size.width/6,child:Card(elevation:15,child:ListView.builder(
                          shrinkWrap: true,
                          itemCount: topicMatches.isNotEmpty ? topicMatches.length:allTopicNamesList.length,
                    itemBuilder: (context, index) {
                      var result = topicMatches.isNotEmpty ? topicMatches[index]:allTopicNamesList[index];
                      return ListTile(
                        onTap: (){
                          topicController.text = result;
                          searchFocus = false;
                          setState((){});
                        },
                        title: Text(result),
                      );
                    },
                  ))):const SizedBox()]),
                        Text(' using a trigger of '),
                        triggersDropDown(setState,loading),
                        Text(' and a date range of '),
                        dateRangeDropDown(setState,loading)
                      ],
                    )
                )]),
                actions: [
              TextButton(
              child: Text("Cancel"),
              onPressed: !loading ? () {Navigator.pop(context);}:null,
              ),
                TextButton(
                  child: loading ? Row(mainAxisSize:MainAxisSize.min,children:[LoadingAnimationWidget.fourRotatingDots(color: Colors.blueGrey, size: 20),Text(" Adding")]):Text('Add'),
                     onPressed: !loading ? () async {
                    //check everything first
                       if(selectedTrigger != '' && selectedDateRange != '' && allTopicNamesList.contains(topicController.text)) {
                         loading = true;
                         setState(() {});
                         bool result = await pushNewAlert();
                         if (result) {
                           //show snack and pop
                           loadingTiles.add(false);
                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Alert Saved!')),);
                           Navigator.pushNamed(NavigationService.navigatorKey.currentContext!, '/alertsPage');
                           loading = false;
                           topicController.text = '';
                           selectedTrigger = '';
                           selectedDateRange = '';
                         } else {
                           topicController.text = '';
                           selectedTrigger = '';
                           selectedDateRange = '';
                           loading = false;
                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Oops something when wrong, try again')),);
                           //no good
                         }
                       }else{
                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please check your inputs')),);
                       }
                  }:null
                ),
                ],
              );
            },
          );
        },
      );
     }
void getAllTopics(Map map, [String key = '']) {
  if(map != null && map.isNotEmpty) {
    map.forEach((key, value) {
      //supplier
      if (value != null && key != 'YieldData' && key != 'RFTY') {
        allTopicNames.add(key);
        value.forEach((key, value) {
          //site
          if (value != null && key != 'YieldData' && key != 'RFTY') {
            allTopicNames.add(key);
            value.forEach((key, value) {
              //bu
              if (value != null && key != 'YieldData' && key != 'RFTY') {
                allTopicNames.add(key);
                value.forEach((key, value) {
                  //program
                  if (value != null && key != 'YieldData' && key != 'RFTY') {
                    allTopicNames.add(key);
                    value.forEach((key, value) {
                      //process
                      if (value != null && key != 'YieldData' && key != 'RFTY') {
                        allTopicNames.add(key);
                        value.forEach((key, value) {
                          //station
                          if (value != null && key != 'YieldData' && key != 'RFTY') {
                            allTopicNames.add(key);
                          }
                        });
                      }
                    });
                  }
                });
              }
            });
          }
        });
      }
    });
  }
  }

  void filterSearchResults(String query) {
    topicMatches.clear();
    for (var topic in allTopicNamesList) {
      if (topic.toLowerCase().contains(query.toLowerCase())) {
        topicMatches.add(topic);
      }
    }
  }

  topicDropdown(setS,loading){
   return ConstrainedBox(
       constraints: const BoxConstraints(minWidth: 48),
    child:IntrinsicWidth(
       child:FocusScope(
        child: Focus(
          onFocusChange: (focus){
            searchFocus = true;
            setS((){});
          },
          child:TextFormField(
            enabled: !loading,
              style: const TextStyle(color: Colors.cyan),
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                ),
              ),
              textAlign: TextAlign.center,
              controller: topicController,
              onChanged:  !loading? (value) {
                filterSearchResults(value);
                setS((){});
              }:null),
        ))));
  }

  DropdownButton triggersDropDown(setS,loading){
  return DropdownButton<String>(
    iconSize: 0,
      value: selectedTrigger,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
    onTap: (){ setS(() {searchFocus = false;});},
      onChanged: !loading ? (String? value) {
        // This is called when the user selects an item.
        setS(() {
          selectedTrigger = value!;
        });
      }:null,
      items: triggerList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  DropdownButton dateRangeDropDown(setS,loading){
    return DropdownButton<String>(
      iconSize: 0,
      value: selectedDateRange,
      elevation: 16,
      style: const TextStyle(color: Colors.blueGrey),
      underline: Container(
        height: 2,
        color: Colors.blueGrey,
      ),
      onTap: (){ setS(() {searchFocus = false;});},
      onChanged: !loading? (String? value) {
        // This is called when the user selects an item.
        setS(() {
          selectedDateRange = value!;
        });
      }:null,
      items: dateRangeList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Future<bool> pushNewAlert() async {
    await Future.delayed(const Duration(seconds: 5));
    //add to Users temp
    userAlerts.add(Alerts(selectedDateRange, topicController.text, selectedTrigger,true));
    return true;
    // await getYieldsOnce();
  }

  Future<bool> deleteAlert(index) async {
    await Future.delayed(const Duration(seconds: 5));
    //add to Users temp
    userAlerts.removeAt(index);
    return true;
    // await getYieldsOnce();
  }

  Future<bool> updateAlert(dateRange,topic,trigger,enabled,index) async {
    await Future.delayed(const Duration(seconds: 5));
    //add to Users temp
    userAlerts[index] = Alerts(dateRange,topic, trigger,enabled);
    return true;
    // await getYieldsOnce();
  }

  final MaterialStateProperty<Icon?> thumbIcon = MaterialStateProperty.resolveWith<Icon?>(
        (Set<MaterialState> states) {
      // Thumb icon when the switch is selected.
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  Widget slideLeftBackground(index) {
    return Container(
      color: Colors.red,
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const <Widget>[
            Icon(Icons.delete, color: Colors.white),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
             SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }

  deleteAlertDialog(index) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setS) {
              return AlertDialog(
                title: const Text("Confirm"),
                content: const Text(
                    "Are you sure you wish to delete this item?"),
                actions: <Widget>[
                  TextButton(
                      onPressed:!loadingTiles[index]? () async {
                        loadingTiles[index] = true;
                        setS((){});
                        bool result = await deleteAlert(index);
                        if (result) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Alert Deleted')),);
                          Navigator.pushNamed(NavigationService.navigatorKey.currentContext!, '/alertsPage');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Oops something when wrong, try again...')),);
                        }
                        loadingTiles[index] = false;
                        setS((){});
                      }:null,
                      child: loadingTiles[index] ? Row(mainAxisSize:MainAxisSize.min,children: [
                        LoadingAnimationWidget.fourRotatingDots(
                            color: Colors.blueGrey, size: 20),
                        Text("DELETE")
                      ]) : Text('Delete')
                  ),
                  TextButton(
                    onPressed:!loadingTiles[index]? () => Navigator.of(context).pop(false):null,
                    child: const Text("CANCEL"),
                  ),
                ],
              );
            },
          );
        });}
}
