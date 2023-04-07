import 'dart:async';
import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iot_dashboard/buildUpdateChartYieldData.dart';
import 'package:iot_dashboard/charts.dart';
import 'package:iot_dashboard/fakeData.dart';
import 'package:iot_dashboard/getListOfType.dart';
import 'package:iot_dashboard/globals.dart';
import 'package:iot_dashboard/httpCall.dart';
import 'package:iot_dashboard/initializeUserSiteInfo.dart';
import 'package:iot_dashboard/navService.dart';
import 'package:iot_dashboard/nullCheckpreBuiltChartsMap.dart';
import 'package:iot_dashboard/selectDate.dart';
import 'package:iot_dashboard/sideDrawer.dart';
import 'package:iot_dashboard/supplierSiteLookup.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:time_range_picker/time_range_picker.dart';

import 'customLoadingIcon.dart';
import 'dateTimeFilter.dart';
import 'drawer.dart';
import 'pickChartToShow.dart';

class MainSitePage extends StatefulWidget {
  @override
  State<MainSitePage> createState() => MainSitePageState();
}

bool once = true;
String todaysDate = '';

class MainSitePageState extends State<MainSitePage> {


  void initState() {
     const time = Duration(seconds:5);
     Timer.periodic(time, (Timer t)
     {
       yieldUpdateTimer = t;
       //refreshData();
     });
    final now = DateTime.now();
    todaysDate = DateFormat('MM-dd-yyyy').format(now);
     //refreshData();
    //postData();
  }

  @override
  Widget build(BuildContext context) {
    //getAndFilterData();
    //getrawFirebaseData();
    //deleteAllData();

    List allSuppliers = yields.keys.toList();

    return Scaffold(
        body: Row(children:[sideDrawer(),FutureBuilder<bool>(
          future: getInitialData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot,) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(crossAxisAlignment:CrossAxisAlignment.center,children: [
                SizedBox(height:100),
                const Text('Grabbing Data Please Wait...'),
                Flexible(child: Row(mainAxisSize:MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Everyone and Everything:',
                      style: TextStyle(fontSize: MediaQuery.of(context).size.width/30),
                    ),
                    DefaultTextStyle(
                        style:  TextStyle(
                            fontSize: MediaQuery.of(context).size.width/30,
                            fontFamily: 'Montserrat'
                        ),
                        child:Container(height:100,width:MediaQuery.of(context).size.width/4,child: AnimatedTextKit(
                          repeatForever: true,
                          animatedTexts: [
                            RotateAnimatedText('VISIBLE'),
                            RotateAnimatedText('CONNECTED'),
                            RotateAnimatedText('OPTIMIZED'),
                          ],
                          onTap: () {
                            print("Tap Event");
                          },
                        ),
                        )),
                  ],
                ))]);
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text('Error');
              } else if (snapshot.hasData) {
                return Expanded(child:SingleChildScrollView(child:Column(children:[
                  Text('Last Updated: ' + lastRefreshTime),
                  //Container(width:100,height:100,child:InkWell(onTap:(){postData();},child:Image.asset('assets/zebraBlack.png'))),
                  Row(children: [for(var i = 0; i < allSuppliers.length;i++) supplierYieldsLayout(allSuppliers[i],yields[allSuppliers[i]]['YieldData'].last['yield'],yields[allSuppliers[i]]['RFTY']),supplierColumnChartShow(),]),
                  for(var i = 0; i < supplierFilteredNames.length;i++) for(var i in mainCardLayout(supplierFilteredNames.elementAt(i))) i
                ])));
              } else {
                return const Text('Empty data');
              }
            } else {
              return Text('State: ${snapshot.connectionState}');
            }
          },
        )]));
  }

 List mainCardLayout(supplier) {
    //sort supplier ChartData because all data is there by now
   supplierColumnData = Map.fromEntries(supplierColumnData.entries.toList()..sort((e1, e2) => supplierColumnData[e1.key]!.last.yieldLoss.compareTo(supplierColumnData[e2.key]!.last.yieldLoss)));
    //supplierColumnData[supplier]!.sort((a, b) => a.yieldLoss.compareTo(b.yieldLoss));
    List siteCards = [];
   yields[supplier].forEach((site, value) {
     if (site != 'YieldData' && site != 'RFTY') {
       if(siteLoadingChart[site] == null) {
         siteLoadingChart[site] = false;
       }
       siteCardInfo[site]['userChoices']['Supplier'] = supplier;
       siteCardInfo[site]['userChoices']['Site'] = site;

       if (siteCardInfo[site] == null) {
         siteCardInfo[site] = {};
       }
       if (siteCardInfo[site]['ShownChart'] == null) {
         siteCardInfo[site]['ShownChart'] = 'Site';
       }

       ///only search if needed and one time?
       Map buInfo = yields[supplier][site];
       List buInfoNames = Globals().getYieldData()[supplier][site].keys.toList();
       buInfoNames.remove('YieldData');
       buInfoNames.remove('RFTY');
       Map programInfo = {};
       List programInfoNames = [];
       Map processInfo = {};
       List processInfoNames = [];
       Map stationInfo = {};
       List stationInfoNames = [];

       if(siteCardInfo[site]['userChoices']['bu'] != '') {
         programInfo = yields[supplier][site][siteCardInfo[site]['userChoices']['bu']];
         programInfoNames = Globals().getYieldData()[supplier][site][siteCardInfo[site]['userChoices']['bu']].keys.toList();
         programInfoNames.remove('YieldData');
         processInfoNames.remove('RFTY');
       }
       if(siteCardInfo[site]['userChoices']['Program'] != '') {
         processInfo = yields[supplier][site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']];
         processInfoNames = Globals().getYieldData()[supplier][site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']].keys.toList();
         processInfoNames.remove('YieldData');
         processInfoNames.remove('RFTY');
       }
       if(siteCardInfo[site]['userChoices']['Process'] != '') {
         stationInfo = yields[supplier][site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']][siteCardInfo[site]['userChoices']['Process']];
         stationInfoNames = Globals().getYieldData()[supplier][site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']][siteCardInfo[site]['userChoices']['Process']].keys.toList();
         stationInfoNames.remove('YieldData');
         stationInfoNames.remove('RFTY');
       }

       //build and update chart data for every yield key in map
         buildUpdateChartYieldData(context, switchChartUpdate, site, supplier);


       ///try to replace this with a yield obj for each?
       String comboNameDisplay = supplierSiteLookup('Supplier', supplier) + ' - ' + supplierSiteLookup('Site', site);
       double latestSiteYield = yields[supplier][site]['YieldData'].last['yield'];
       double rfty = yields[supplier][site]['RFTY'];
       siteCards.add(Container(padding: const EdgeInsets.all(10),child:
       Card(child: Padding(padding: EdgeInsets.all(10), child:
       Row(crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.start,
           mainAxisSize: MainAxisSize.min,children: [
         Column(
             mainAxisAlignment: MainAxisAlignment.start,
             mainAxisSize: MainAxisSize.min,children: [InkWell(onTap: () async {
           // switchChartClicked();
           //siteClicked(site);
           siteLoadingChart[site] = true;
           setState(() {});
           bool result = await switchChartClicked(supplier,site, site, 'Site');
           if(!result){
             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Oops something went wrong... try again')),);
           }
           siteLoadingChart[site] = false;
         },
             child: Text(comboNameDisplay, style: TextStyle(fontSize: MediaQuery.of(context).size.width / 40))),
           Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[
             Container(height:100,width:100,child:SfRadialGauge(axes:<RadialAxis>[RadialAxis(annotations: <GaugeAnnotation>[
               GaugeAnnotation(
                   positionFactor: 0.6,
                   angle: 90,
                   axisValue: 5,
                   widget: Column(crossAxisAlignment:CrossAxisAlignment.center,children:[
                     Text('Yield'), AnimatedFlipCounter(
                         textStyle: TextStyle(color: Colors.teal),
                         value: latestSiteYield,
                         fractionDigits: 2,
                         suffix: '%',
                         duration: const Duration(milliseconds: 750)
                     ),
                   ]))
             ],showLabels: false,
                 showTicks: false,pointers: <GaugePointer>[RangePointer(color:latestSiteYield <= 70? Colors.red:latestSiteYield > 70 && latestSiteYield <= 85 ?Colors.yellowAccent:Colors.teal, enableAnimation: true, value: latestSiteYield)],minimum: 0, maximum: 100),]),
             ), Container(height:100,width:100,child:SfRadialGauge(axes:<RadialAxis>[RadialAxis(annotations: <GaugeAnnotation>[
               GaugeAnnotation(
                   positionFactor: 0.6,
                   angle: 90,
                   axisValue: 5,
                   widget:  Column(crossAxisAlignment:CrossAxisAlignment.center,children:[
                     Text('RFTY'),AnimatedFlipCounter(
                         textStyle: TextStyle(color: Colors.teal),
                         value: rfty,
                         fractionDigits: 2,
                         suffix: '%',
                         duration: const Duration(milliseconds: 750)
                     ),
                   ]))
             ],showLabels: false,
                 showTicks: false,pointers: <GaugePointer>[RangePointer(color:rfty <= 70? Colors.red:rfty> 70 && rfty <= 85 ?Colors.yellowAccent:Colors.teal, enableAnimation: true, value: rfty)],minimum: 0, maximum: 100),]),
             ),
           ]),
           Text('Business Units ' + buInfoNames.length.toString()),
           Wrap(spacing: 10,
               children: [
                 for(var i = 0; i < buInfoNames.length; i++) InkWell(
                     hoverColor: Colors.teal.withOpacity(.5), onTap: () async {
                   siteLoadingChart[site] = true;
                   setState(() {});
                   bool result = await switchChartClicked(supplier,site,buInfoNames[i].toString(), 'bu');
                   if(!result){
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Oops something went wrong... try again')),);
                   }
                   siteLoadingChart[site] = false;                 }, child: Text(buInfoNames[i].toString() + ' ' + buInfo[buInfoNames[i]]['YieldData'].last['yield'].toString() + '%',
                   style: const TextStyle(color: Colors.teal),))
               ]),
           siteCardInfo[site]['userChoices']['bu'] != ''
               ? Text(
               'Total Programs: ' + programInfoNames.length.toString())
               : SizedBox(),
           siteCardInfo[site]['userChoices']['bu'] != '' ? Wrap(spacing: 10,
               children: [
                 for(var i = 0; i < programInfoNames.length; i++) InkWell(
                     hoverColor: Colors.teal.withOpacity(.5), onTap: () async {
                   siteLoadingChart[site] = true;
                   bool result = await switchChartClicked(supplier,site,programInfoNames[i].toString(), 'Program');
                   if(!result){
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Oops something went wrong... try again')),);
                   }
                   siteLoadingChart[site] = false;                 }, child: Text(programInfoNames[i].toString() +
                     ' ' + programInfo[programInfoNames[i]]['YieldData'].last['yield'].toString() +
                     '%', style: const TextStyle(color: Colors.teal),))
               ]) : SizedBox(),
           siteCardInfo[site]['userChoices']['Program'] != ''
               ? Text(
               'Total Processes: ' + processInfoNames.length.toString())
               : SizedBox(),
           siteCardInfo[site]['userChoices']['Program'] != '' ? Wrap(
               spacing: 10,
               children: [
                 for(var i = 0; i < processInfoNames.length; i++) InkWell(
                     hoverColor: Colors.teal.withOpacity(.5), onTap: () async {
                   siteLoadingChart[site] = true;
                   setState(() {});
                   bool result = await switchChartClicked(supplier,site,processInfoNames[i].toString(), 'Process');
                   if(!result){
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Oops something went wrong... try again')),);
                   }
                   siteLoadingChart[site] = false;                 }, child: Text(processInfoNames[i].toString() + ' ' + processInfo[processInfoNames[i]]['YieldData'].last['yield'].toString() + '%', style: const TextStyle(color: Colors.teal),))
               ]) : SizedBox(),
           siteCardInfo[site]['userChoices']['Process'] != '' ? Text('Total Stations: ' + stationInfoNames.length.toString()) : SizedBox(),
           siteCardInfo[site]['userChoices']['Process'] != '' ? Column(
               children: [
                 for(var i = 0; i <  stationInfoNames.length; i++) AnimatedSwitcher(duration: Duration(milliseconds: 500),child: siteCardInfo[site]['userChoices']['Station'] == stationInfoNames[i] ? Row(children:[InkWell(hoverColor: Colors.teal.withOpacity(.5), onTap: () async {
                   siteLoadingChart[site] = true;
                   setState(() {});
                   bool result = await switchChartClicked(supplier,site,stationInfoNames[i].toString(), 'Station');
                   if(!result){
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Oops something went wrong... try again')),);
                   }
                   siteLoadingChart[site] = false;
                 }, child: Text(stationInfoNames[i].toString() + ' ' + stationInfo[stationInfoNames[i]]['YieldData'].last['yield'].toString() + '%', style: const TextStyle(color: Colors.teal))),InkWell(hoverColor:Colors.blueGrey.withOpacity(.5),onTap:(){},child:Text(' -> Deep Dive'))]):InkWell(hoverColor: Colors.teal.withOpacity(.5), onTap: () async {
                   //await switchChartClicked(supplier,site,  stationInfoNames[i].toString(), 'Station');
                 }, child: Text(stationInfoNames[i].toString() + ' ' + stationInfo[stationInfoNames[i]]['YieldData'].last['yield'].toString() + '%', style: const TextStyle(color: Colors.teal)))),
               ]) : SizedBox(),
         ]),
         Expanded(child: Card(
             elevation: 10, child: Column(mainAxisSize: MainAxisSize.min,
             children: [
               Row(children: [
                 Expanded(child: Align(alignment: Alignment.centerLeft, child: toggleFreezeSwitch(site, siteCardInfo[site]['ShownChart']))),
                 Expanded(child: Center(child: timeRangeFilterText(site,siteCardInfo[site]['ShownChart']))),
                 Align(alignment: Alignment.centerRight, child: labelButton(supplier,site,siteCardInfo[site]['ShownChart'])),
                 Align(alignment: Alignment.centerRight, child: zoomResetButton(site,siteCardInfo[site]['ShownChart'])),
                  Align(alignment: Alignment.centerRight,child:timeFilterButton(supplier,site,siteCardInfo[site]['ShownChart'])),
                 Align(alignment: Alignment.centerRight, child: fullScreenButton(site,siteCardInfo[site]['ShownChart'],supplier)),
               ]),
               //figure out how to show not only the site chart but the others instead, make a global with the a site key and the key of the chart that is shown
                AnimatedSwitcher( switchOutCurve: Curves.easeOutExpo,
                 switchInCurve: Curves.easeInExpo,
                 transitionBuilder: (widget, animation) => ScaleTransition(
                   scale: animation,
                   child: widget,
                 ),duration: const Duration(milliseconds: 500),child:siteCardInfo[site]['ShownChart'] == 'Site' ? Stack(key: ValueKey<int>(0),children:[Card(child:preBuiltCharts[site]['chart']),siteLoadingChart[site] ? Padding(padding:EdgeInsets.only(top:100),child:Center(child:LoadingAnimationWidget.fourRotatingDots(color: Colors.blueGrey, size: 50))):SizedBox()]):siteCardInfo[site]['ShownChart'] == 'bu' ? Stack(key: ValueKey<int>(1),children:[Card(child:preBuiltCharts[site][siteCardInfo[site]['userChoices']['bu']]['chart']),siteLoadingChart[site] ? Padding(padding:EdgeInsets.only(top:100),child:Center(child:LoadingAnimationWidget.fourRotatingDots(color: Colors.blueGrey, size: 50))):SizedBox()]):siteCardInfo[site]['ShownChart'] == 'Program' ? Stack(key: ValueKey<int>(2),children:[Card(child:preBuiltCharts[site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']]['chart']),siteLoadingChart[site] ? Padding(padding:EdgeInsets.only(top:100),child:Center(child:LoadingAnimationWidget.fourRotatingDots(color: Colors.blueGrey, size: 50))):SizedBox()]):siteCardInfo[site]['ShownChart'] == 'Process' ? Stack(key: ValueKey<int>(3),children:[Card(child:preBuiltCharts[site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']][siteCardInfo[site]['userChoices']['Process']]['chart']),siteLoadingChart[site] ? Padding(padding:EdgeInsets.only(top:100),child:Center(child:LoadingAnimationWidget.fourRotatingDots(color: Colors.blueGrey, size: 50))):SizedBox()]):siteCardInfo[site]['ShownChart'] == 'Station' ? Stack(key: ValueKey<int>(4),children:[Card(child:preBuiltCharts[site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']][siteCardInfo[site]['userChoices']['Process']][siteCardInfo[site]['userChoices']['Station']]['chart']),siteLoadingChart[site] ? Padding(padding:EdgeInsets.only(top:100),child:Center(child:LoadingAnimationWidget.fourRotatingDots(color: Colors.blueGrey, size: 50))):SizedBox()]):SizedBox())
               // Card(child:pickChartToShow(site,siteCardInfo[site]['ShownChart']))
       ]
   )))
       ])))));
     }
   });
   return siteCards;
 }

  Widget supplierYieldsLayout(supplier,double yield,double rfty) {
    double yieldLoss = double.parse((100-yield).toStringAsFixed(2));
    addSupplierChartData(supplier,yieldLoss);
    return Expanded(child:Container(padding:const EdgeInsets.all(10),child:
    Card(elevation:10,child:Padding(padding:EdgeInsets.all(10),child:
    Column(children: [
      InkWell(onTap:(){
        if(supplierFiltered == supplier){
          supplierFiltered = 'ALL';
        }else {
          supplierFiltered = supplier;
        }
        setState(() {});
      },child:Text(supplierSiteLookup('Supplier', supplier),style: TextStyle(color:supplierFiltered == supplier ? Colors.teal:null,fontSize: MediaQuery.of(context).size.width/50))),
      Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[
        Flexible(child:Container(height:MediaQuery.of(context).size.height/7.5,width:MediaQuery.of(context).size.width/10,child:
        SfRadialGauge(axes:<RadialAxis>[RadialAxis(annotations: <GaugeAnnotation>[
        GaugeAnnotation(
            angle: 90,
          axisValue: 5,
          widget: Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.center,children:[
              Text('Yield'), AnimatedFlipCounter(
              textStyle: TextStyle(color: Colors.teal),
              value: yield,
              fractionDigits: 2,
              suffix: '%',
              duration: const Duration(milliseconds: 750)
          ),
        ]))
      ],showLabels: false,
          showTicks: false,pointers: <GaugePointer>[RangePointer(color:yield <= 70? Colors.red:yield > 70 && yield <= 85 ?Colors.yellowAccent:Colors.teal, enableAnimation: true, value: yield)],minimum: 0, maximum: 100),]),
      )), Flexible(child:Container(height:MediaQuery.of(context).size.height/7.5,width:MediaQuery.of(context).size.width/10,child:SfRadialGauge(axes:<RadialAxis>[RadialAxis(annotations: <GaugeAnnotation>[
        GaugeAnnotation(
          angle: 90,
          axisValue: 5,
          widget:  Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.center,children:[
            Text('RFTY'),AnimatedFlipCounter(
              textStyle: TextStyle(color: Colors.teal),
              value: rfty,
              fractionDigits: 2,
              suffix: '%',
              duration: const Duration(milliseconds: 750)
          ),
        ]))
      ],showLabels: false,
          showTicks: false,pointers: <GaugePointer>[RangePointer(color:rfty <= 70? Colors.red:rfty> 70 && rfty <= 85 ?Colors.yellowAccent:Colors.teal, enableAnimation: true, value: rfty)],minimum: 0, maximum: 100),]),
      )),
    ]),
    ])))));
  }

  Widget fullScreenButton(site,key,supplier){
    return Tooltip(message: 'Full Screen',child:IconButton(
        onPressed: () {
          Navigator.of(context).push(
              PageRouteBuilder(
                  transitionDuration: Duration(seconds: 1),
                  opaque: false,
                  pageBuilder: (BuildContext context, _, __) {
                    return BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                            padding: EdgeInsets.all(15),
                            child: Card(
                                elevation: 15,
                                child: Column(children: [
                                  Container(
                                      height: 50,
                                      child: Row(
                                          children: [
                                              Expanded(child:Align(alignment: Alignment.centerLeft,child:toggleFreezeSwitch(site,siteCardInfo[site]['ShownChart']))),
                                              Expanded(child: Center(child:timeRangeFilterText(site,siteCardInfo[site]['ShownChart']))),
                                              Align(alignment: Alignment.centerRight, child: labelButton(supplier,site,siteCardInfo[site]['ShownChart'])),
                                              Align(alignment: Alignment.centerRight,child:zoomResetButton(site,siteCardInfo[site]['ShownChart'])),
                                              Align(alignment: Alignment.centerRight,child:timeFilterButton(supplier,site,siteCardInfo[site]['ShownChart'])),
                                  Align(alignment: Alignment.centerRight,child: IconButton(onPressed: () {Navigator.of(context).pop();}, icon: const Icon(Icons.close_fullscreen_outlined))),                                            ]),
                                          ),
                                  Hero(tag:site + siteCardInfo[site]['ShownChart'],child:Container(
                                      width: MediaQuery.of(context).size.width-50,
                                      height: MediaQuery.of(context).size.height-150,
                                      child: pickChartToShow(site,siteCardInfo[site]['ShownChart'])))]))));
                  }
              )
          );
        },
        icon: const Icon(Icons.open_in_full_outlined)));
  }

  Widget timeRangeFilterText(site,type){
    if(chartInfo[site][type]['timeFilter'] == null){
      chartInfo[site][type]['timeFilter'] = '12am-Now';
    }
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
              Column(children:[
                Text(todaysDate),
                Text('From ' + chartInfo[site][type]['timeFilter'].split('-')[0] + ' To ' + chartInfo[site][type]['timeFilter'].split('-')[1])
    ])
    ]);
  }
  Widget timeFilterButton(supplier,site,type){
    List data = getRawYieldData(supplier,site,siteCardInfo[site]['ShownChart']);
    //DateTime startShow = DateFormat("hh:mm:ss").parse(DateTime.now().toString());
    //DateTime endShow = DateFormat("hh:mm:ss").parse(data.last['date'].toString().split(' ')[1]);
    return Padding(padding:EdgeInsets.only(right:5),child:Tooltip(message: "Filter by a Date range",child:IconButton(
      padding: EdgeInsets.zero,
      // This bool value toggles the switch.
      icon: const Icon(Icons.filter_alt_outlined),
      onPressed: () async {
        List result = await selectDate(context, true);
      },
    )));
  }
  /*Widget timeFilterButton(supplier,site,type){
    List data = getRawYieldData(supplier,site,siteCardInfo[site]['ShownChart']);
    DateTime startShow = DateFormat("hh:mm:ss").parse(data.first['date'].toString().split(' ')[1]);
    DateTime endShow = DateFormat("hh:mm:ss").parse(data.last['date'].toString().split(' ')[1]);
    TimeOfDay disabledStartTime = TimeOfDay.fromDateTime(startShow.add(Duration(minutes: -1)));
    TimeOfDay disabledEndTime = TimeOfDay.fromDateTime(endShow.add(Duration(minutes: 1)));
    return Padding(padding:EdgeInsets.only(right:5),child:Tooltip(message: "Filter by a time range",child:IconButton(
      padding: EdgeInsets.zero,
      // This bool value toggles the switch.
      icon: const Icon(Icons.filter_alt_outlined),
      onPressed: () async {
        TimeRange? result = await showTimeRangePicker(
            backgroundWidget:Text('There is data for ' + type + ' between\n' + DateFormat('h:mma').format(startShow) + ' and ' + DateFormat('h:mma').format(endShow)),
          start: disabledStartTime,
          interval: Duration(minutes: 1),
          end: disabledEndTime,
          minDuration: Duration(minutes: 1),
          disabledTime: TimeRange(
              startTime: disabledEndTime,
              endTime: disabledStartTime),
          disabledColor: Colors.red.withOpacity(0.5),
          labels: ["12 am", "3 am", "6 am", "9 am", "12 pm", "3 pm", "6 pm", "9 pm"].asMap().entries.map((e) {return ClockLabel.fromIndex(idx: e.key, length: 8, text: e.value);}).toList(),
          use24HourFormat: false,
          context: context,
        );
        if(result != null) {
          double start = result.startTime.hour + result.startTime.minute/60.0;
          double end = result.endTime.hour + result.endTime.minute/60.0;

          if(start < end) {
            chartInfo[site][type]['timeFilter'] = result.startTime.format(context) + '-' + result.endTime.format(context);
            chartInfo[site][type]['realtime'] = false;
            final now = DateTime.now();
            var outputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
            DateTime startDateTime = outputFormat.parse(outputFormat.format(
                DateTime(now.year, now.month, now.day, result.startTime.hour,
                    result.startTime.minute, 01)));
            DateTime endDateTime = outputFormat.parse(outputFormat.format(
                DateTime(now.year, now.month, now.day, result.endTime.hour,
                    result.endTime.minute, 00)));
            if(dateTimeFilter(startDateTime, endDateTime,data)) {
             *//* if(preBuiltCharts[key] == null) {
                preBuildTheCharts(context, key, key + ' Yield');
              }*//*
              //changed from setstate to update it when its in fullscreen
              Globals().changeTheme(currentTheme);

            }else{
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No Data for that Time Range')),);
            }
          }else{
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('oops something yet wrong, try again')),);
          }
        }else{
          print('canceled');
        }
      },
    )));
  }*/

  Widget labelButton(supplier,site,type){
    if(chartInfo[site][type]['label'] == null){
      chartInfo[site][type]['label'] = false;
    }
    return Padding(padding:EdgeInsets.only(right:5),child:Tooltip(message: "Turn on or off labels",child:
    IconButton(
      padding: EdgeInsets.zero,
      // This bool value toggles the switch.
      icon: chartInfo[site][type]['label'] ?  const Icon(Icons.label):const Icon(Icons.label_off_outlined),
      onPressed: () {
        chartInfo[site][type]['label'] = !chartInfo[site][type]['label'];
        chartSwitchReset(supplier,site,type);
        Globals().changeTheme(currentTheme);
      },
    )));
  }

  Widget zoomResetButton(site,type){
    return Padding(padding:EdgeInsets.only(right:5),child:Tooltip(message: "Reset View \n Long click and drag an area to Zoom. You can Pan by dragging",child:
      IconButton(
      padding: EdgeInsets.zero,
      // This bool value toggles the switch.
      icon: const Icon(Icons.area_chart_outlined),
      onPressed: () {
        chartInfo[site][type]['zoom'].reset();
        chartInfo[site][type]['realtime'] = false;
        Globals().changeTheme(currentTheme);
      },
    )));
  }

  Widget toggleFreezeSwitch(site,shownChart){
    //print(shownChart);
    return Padding(padding:EdgeInsets.only(left:13,top: 5,bottom: 5),child:Row(children: [
      Tooltip(message: 'Toggle real-time data',child:Text(chartInfo[site][shownChart]['realtime'] == true ? "Real-time:": 'Real-time\nDisabled')),
        Switch(inactiveThumbImage: AssetImage('assets/freezeButton.png'),
        // This bool value toggles the switch.
        value: chartInfo[site][shownChart]['realtime'],
        activeThumbImage: AssetImage('assets/realtimeactive.gif'),
        activeColor: Colors.teal,
        onChanged: (bool value) {
          chartInfo[site][shownChart]['realtime'] = value;
          chartInfo[site][shownChart]['filtered'] = false;
          //reset time filter
          chartInfo[site][shownChart]['timeFilter'] = '12am-Now';
          //preBuildTheCharts(context, shownChart, shownChart + ' Yield');

          //changed from setstate to update it when its in fullscreen
          Globals().changeTheme(currentTheme);

          //setState(() {});
          //might need to setstate
        },
      )]));
  }


  Future<bool> switchChartClicked(supplier,site,keyClicked,type) async {
    String bu = 'NA';
    String program = 'NA';
    String process = 'NA';
    String station = 'NA';
    bool result = await httpCallFake();
      if(type == 'bu'){
      //reset others
      siteCardInfo[site]['userChoices']['Process'] = '';
      siteCardInfo[site]['userChoices']['Program'] = '';
      siteCardInfo[site]['userChoices']['Station'] = '';
    }else if(type == 'Program'){
      siteCardInfo[site]['userChoices']['Process'] = '';
      siteCardInfo[site]['userChoices']['Station'] = '';
    }
    if(siteCardInfo[site] == null){
      siteCardInfo[site] = {};
    }
    siteCardInfo[site]['ShownChart'] = type;
    siteCardInfo[site]['userChoices'][type] = keyClicked;
    //make call to get data
    if(type.toLowerCase() == "supplier") {
    }else if(type.toLowerCase() == 'site') {
    } else if(type.toLowerCase() == 'bu') {
      bu = siteCardInfo[site]['userChoices']['bu'];
    }else if(type.toLowerCase() == 'program') {
      bu = siteCardInfo[site]['userChoices']['bu'];
      program = siteCardInfo[site]['userChoices']['Program'];
    }else if(type.toLowerCase() == 'process') {
      bu = siteCardInfo[site]['userChoices']['bu'];
      program = siteCardInfo[site]['userChoices']['Program'];
      process = siteCardInfo[site]['userChoices']['Process'];
    }else if(type.toLowerCase() == 'station') {
      bu = siteCardInfo[site]['userChoices']['bu'];
      program = siteCardInfo[site]['userChoices']['Program'];
      process = siteCardInfo[site]['userChoices']['Process'];
      station = siteCardInfo[site]['userChoices']['Station'];
    }
      //bool result = await httpYieldSpecificCall(type, supplier, site, bu, program, process, station, '1');
    if(result) {
      chartSwitchReset(supplier, site, type);
      return true;
    }else{
      return false;
    }
   // setState(() {});
  }

  Future<bool> httpCallFake() async {
    await Future.delayed(const Duration(seconds: 5));
    return true;
  }



/*Future<void> getrawFirebaseData() async {
    DatabaseReference snapshot2 = FirebaseDatabase.instance.ref();

    DatabaseEvent snap = await snapshot2.once();


    print(snap.snapshot.value);
  }*/

/*void getAndFilterData() async {
    await httpCall();
    filterJsonData(testJson);
  }*/

  deleteAllData() {
    FirebaseDatabase.instance.ref().remove();
  }

  Future<void> refreshData() async {
    lastRefreshTime = DateFormat('MM-dd-yyyy hh:mm:ss a').format(DateTime.now()).toString();
    //await postData();
    //httpYieldCall();

    // Get the data once
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    DatabaseEvent event = await ref.once();

    rawFirebaseData = event.snapshot.value as Map;
    //serialNumbers = rawFirebaseData["SerialNumbers"].map<SerialNumbers>((json) => SerialNumbers.fromJson(json)).toList();
    // yields = rawFirebaseData["Yields"].map<Yields>((json) => Yields.fromJson(json)).toList();
    yields = rawFirebaseData["Yields"];

    if(once) {
      initalizeUserSiteInfo();
      once = false;
    }
    if(supplierFilteredNames.isEmpty || supplierFiltered == 'ALL'){
      supplierFilteredNames = yields.keys.toList();
    }
    if(supplierFiltered != 'ALL'){
      supplierFilteredNames.removeWhere((element) => element != supplierFiltered);
    }
    setState(() {});
  }

  void chartSwitchReset(supplier,site,type){
    nullCheckpreBuiltChartsMap(site,type);
    BuildContext context = NavigationService.navigatorKey.currentContext!;
    //run and do a check if anything is null and set to an empty map

    if(siteCardInfo[site]['ShownChart'] == 'Site'){
      preBuiltCharts[site]['chart'] = preBuildAChartSeries(supplier,context, site,Globals().getYieldData()[supplier],type);
    }
    if(siteCardInfo[site]['ShownChart'] == "bu") {
      //if(preBuiltCharts[site][siteCardInfo[site]['userChoices']['bu']]['chart'] == null) {
      preBuiltCharts[site][siteCardInfo[site]['userChoices']['bu']]['chart'] = preBuildAChartSeries(supplier,context, site,Globals().getYieldData()[supplier][site],type);
      //}
    }
    if(siteCardInfo[site]['ShownChart'] == "Program"){
      //if(preBuiltCharts[site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']]['chart'] == null) {
      preBuiltCharts[site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']]['chart'] = preBuildAChartSeries(supplier,context, site,Globals().getYieldData()[supplier][site][siteCardInfo[site]['userChoices']['bu']],type);
      //}
    }
    if(siteCardInfo[site]['ShownChart'] == "Process"){
      //if(preBuiltCharts[site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']][siteCardInfo[site]['userChoices']['Process']]['chart'] == null) {
      preBuiltCharts[site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']][siteCardInfo[site]['userChoices']['Process']]['chart'] = preBuildAChartSeries(supplier,context, site,Globals().getYieldData()[supplier][site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']],type);
      //}
    }
    if(siteCardInfo[site]['ShownChart'] == "Station"){
      //if(preBuiltCharts[site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']][siteCardInfo[site]['userChoices']['Process']][siteCardInfo[site]['userChoices']['Station']]['chart'] == null) {
      preBuiltCharts[site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']][siteCardInfo[site]['userChoices']['Process']][siteCardInfo[site]['userChoices']['Station']]['chart'] = preBuildAChartSeries(supplier,context, site,Globals().getYieldData()[supplier][site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']][siteCardInfo[site]['userChoices']['Process']],type);
      //}
    }

    //chartInfo[key]['zoom'].reset();
    switchChartUpdate = true;
    //Globals().changeTheme(currentTheme);
    setState(() {});
  }

  Future<bool> getInitialData() async {
    //await postData();
    //default no time to 1 day
    bool result = await httpGetTopicNames();
    if(result) {
      yields.forEach((supplierKey, supplierValue) {
        httpYieldSpecificCall(
            'Supplier',
            supplierKey,
            'NA',
            'NA',
            'NA',
            'NA',
            'NA');
        for (var siteValue in supplierValue) {}
      });
    }else{

    }
    print(yields);
    return true;
    //httpYieldCall();

    // Get the data once
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    DatabaseEvent event = await ref.once();

    rawFirebaseData = event.snapshot.value as Map;
    //serialNumbers = rawFirebaseData["SerialNumbers"].map<SerialNumbers>((json) => SerialNumbers.fromJson(json)).toList();
    // yields = rawFirebaseData["Yields"].map<Yields>((json) => Yields.fromJson(json)).toList();
    yields = rawFirebaseData["Yields"];

    if(once) {
      initalizeUserSiteInfo();
      once = false;
    }
    if(supplierFilteredNames.isEmpty || supplierFiltered == 'ALL'){
      supplierFilteredNames = yields.keys.toList();
    }
    if(supplierFiltered != 'ALL'){
      supplierFilteredNames.removeWhere((element) => element != supplierFiltered);
    }
    setState(() {});
  }

}




