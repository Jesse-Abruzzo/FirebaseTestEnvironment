import 'package:flutter/material.dart';
import 'package:iot_dashboard/findSNInfo.dart';
import 'package:iot_dashboard/findSiteByKey.dart';
import 'package:iot_dashboard/getListOfType.dart';
import 'package:iot_dashboard/globals.dart';
import 'package:iot_dashboard/navService.dart';
import 'package:random_color/random_color.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import 'SerialNumberBottomBar.dart';


Widget preBuildAChartSeries(supplier,context,site,yield,type,yieldNamesOnly){
  ///build chart when user clicks on the topic. That way you have the path down to where you need to store it.
  ///create chartData have to update everytime data comes in
    if (chartInfo[site] == null) {
      chartInfo[site] = {};
    }
    if (chartInfo[site][type] == null) {
      chartInfo[site][type] = {};
    }
    if (chartInfo[site][type]['zoom'] == null) {
      chartInfo[site][type]['zoom'] = ZoomPanBehavior(
          enableSelectionZooming: true,
          enablePanning: true,
          selectionRectBorderColor: Colors.teal,
          selectionRectBorderWidth: 1,
          selectionRectColor: Colors.teal,
          zoomMode: ZoomMode.xy
      );
    }
    if (chartInfo[site][type]['filtered'] == null) {
      chartInfo[site][type]['filtered'] = false;
    }
    if (chartInfo[site][type]['label'] == null) {
      chartInfo[site][type]['label'] = false;
    }
    if (chartInfo[site][type]['timeFilter'] == null) {
      chartInfo[site][type]['timeFilter'] = '12am-Now';
    }
    if (chartInfo[site][type]['realtime'] == null) {
      chartInfo[site][type]['realtime'] = true;
    }

    List<FastLineSeries<dynamic,  DateTime>> tempCharts = buildMultiLayeredChart(supplier,site,type,yield,yieldNamesOnly); //program, process, station, etc.
    return simpleLineChartNoLimits(context, type + ' Yield', true, true, site, tempCharts, type);
  }

List<FastLineSeries<dynamic,  DateTime>> buildMultiLayeredChart(supplier,site,type,yield,yieldNamesOnly){
    //Map temp = getListOfType(site,key,type,yieldObj);
    List<FastLineSeries<dynamic,  DateTime>> chartWidgets = [];
    //want to build all of that type
    List names = yieldNamesOnly.keys.toList();
    for (var i = 0; i < names.length;i++) {
      if(chartInfo[site][names[i]] == null){
        chartInfo[site][names[i]] = {};
      }
      if (chartInfo[site][names[i]]['color'] == null) {
        Color color = randomColor.randomColor(colorHue: ColorHue.blue);
        chartInfo[site][names[i]]['color'] = color;
      }
      //get yield data List for that type
      yieldChartData = Map.from(yields);
      if(type == 'Process') {
        print(yieldChartData[supplier][site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']][names[i]]['YieldData']);
      }
      chartWidgets.add(FastLineSeries<dynamic, DateTime>(
        onRendererCreated: (ChartSeriesController controller) {
          if (chartInfo[site] == null) {
            chartInfo[site] = {};
          }
          if (chartInfo[site][type] == null) {
            chartInfo[site][type] = {};
          }
            chartInfo[site][type]['controller'] = controller;

        },
        animationDuration: /*chartData.length < 50? 1000:*/0,
        trendlines: <Trendline>[
          /* Trendline(
                        type: TrendlineType.movingAverage,
                        color: Colors.blue)*/
        ],
        onPointTap: (ChartPointDetails details) {
          print(details.pointIndex);
          print(details.seriesIndex);
          //showSerialNumberData(context,details.pointIndex,topic);
          //_selectionBehavior.selectDataPoints(details.pointIndex!, details.seriesIndex!);
        },
        dataLabelSettings: DataLabelSettings(color: Globals().getCurrentTheme() ? Colors.white:chartInfo[site][names[i]]['color'],isVisible:  chartInfo[site][type]['label']),
        markerSettings: const MarkerSettings(isVisible: true, color: Colors.black),
        emptyPointSettings: EmptyPointSettings(
          // Mode of empty point
            mode: EmptyPointMode.drop),
        color: chartInfo[site][names[i]]['color'],
        name:names[i],
        dataSource:  type == 'Site' ? yieldChartData[supplier][names[i]]['YieldData']:type == 'bu' ? yieldChartData[supplier][site][names[i]]['YieldData']:type == 'Program' ? yieldChartData[supplier][site][siteCardInfo[site]['userChoices']['bu']][names[i]]['YieldData']:type == 'Process' ? yieldChartData[supplier][site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']][names[i]]['YieldData']: yieldChartData[supplier][site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']][siteCardInfo[site]['userChoices']['Process']][names[i]]['YieldData'],
        xValueMapper: (data, x) => DateTime.parse(data['Date']),
        yValueMapper: (data, y) => double.parse(data['Cumulative Yield'].toStringAsFixed(2)),
        //selectionBehavior: _selectionBehavior
      ));
    }
    return chartWidgets;
  }

Widget simpleLineChartNoLimits(context,title, zoom, pan, site, List<FastLineSeries<dynamic,  DateTime>> series,type) {
  TooltipBehavior tooltipBehavior = TooltipBehavior(
    duration: 20000,
      enable: true,
      // Templating the tooltip
      builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
        return Container(color:Colors.grey,child:Column(mainAxisSize: MainAxisSize.min,children:[
          Text(series.name.toString(),style: const TextStyle(fontSize: 10,color: Colors.black)),
        /*Material(
        type: MaterialType.transparency,
        child: InkWell(hoverColor:Colors.teal.withOpacity(.3),onTap:(){
            Map tempData = findSNInfo(data["SerialNumber"]);
            if(tempData.isNotEmpty) {
              showSerialNumberData(tempData);
            }else{
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Oops something went wrong...')),);
            }
          },child:Text(data["SerialNumber"].toString(),style: const TextStyle(fontSize: 10,color: Colors.teal)))),*/
          SizedBox(width:100,child:Divider(height:5,endIndent:5,indent:5,color: Colors.black,)),
          Text(DateFormat("yyyy-MM-dd hh:mm:ss a").format(DateTime.parse(data['Date'])),style: const TextStyle(fontSize: 10,color: Colors.black)),
          Text(data['Cumulative Yield'].toStringAsFixed(2) + "%",style: const TextStyle(fontSize: 10,color: Colors.black))]));
      }
  );
  return Card(elevation: 10,
          child: SfCartesianChart(
              onActualRangeChanged: (args) {
                if(args.orientation == AxisOrientation.horizontal){
                  chartInfo[site][type]['timeFilter'] = DateFormat.jm().format(DateTime.fromMicrosecondsSinceEpoch(args.visibleMin * 1000)) + '-' + DateFormat.jm().format(DateTime.fromMicrosecondsSinceEpoch(args.visibleMax * 1000)) ;
                }
              },
          //trackballBehavior: TrackballBehavior(shouldAlwaysShow:true,enable: true, tooltipDisplayMode: TrackballDisplayMode.floatAllPoints),
              legend: Legend(isVisible: true),
              onZoomEnd: (ZoomPanArgs args){
                print(args.currentZoomFactor);
                print(args.currentZoomPosition);
                chartInfo[site][type]['realtime'] = false;
                Globals().changeTheme(currentTheme);
              },
              //selectionType: SelectionType.point,
              zoomPanBehavior: chartInfo[site][type]['zoom'],
              title: ChartTitle(text: title, alignment: ChartAlignment.center),
              tooltipBehavior: tooltipBehavior,
              primaryXAxis: DateTimeAxis(
                dateFormat: DateFormat.jm(),
                isVisible: true,
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                title: AxisTitle(
                  text: 'Date/Time',
                ),
              ),
              primaryYAxis: NumericAxis(
                minimum: title.toLowerCase().contains("yield") ? 0 : null,
                maximum: title.toLowerCase().contains("yield") ? 100 : null,
                labelFormat:title.toLowerCase().contains("yield") ? '{value}%' : '{value}',
                title: AxisTitle(
                  text: 'Yield',
                ),
              ),
              series: <FastLineSeries<dynamic, dynamic>>[
                for(var i = 0; i < series.length;i++) series[i]
               /* FastLineSeries<LineChartData, String>(
                  onRendererCreated: (ChartSeriesController controller) {
                    if(chartInfo[key] == null){
                      chartInfo[key] = {};
                    }
                    chartInfo[key]['controller'] = controller;
                  },
                  animationDuration: *//*chartData.length < 50? 1000:*//*0,
                  trendlines:<Trendline>[
                   *//* Trendline(
                        type: TrendlineType.movingAverage,
                        color: Colors.blue)*//*
                  ],
                  onPointTap: (ChartPointDetails details) {
                    print(details.pointIndex);
                    print(details.seriesIndex);
                    //showSerialNumberData(context,details.pointIndex,topic);
                    //_selectionBehavior.selectDataPoints(details.pointIndex!, details.seriesIndex!);
                  },
                  //dataLabelSettings: DataLabelSettings(isVisible: labelToggle[topic]!),
                  //fix this
                  markerSettings: const MarkerSettings(
                      isVisible: true, color: Colors.black),
                  emptyPointSettings: EmptyPointSettings(
                    // Mode of empty point
                      mode: EmptyPointMode.drop),
                  color: Colors.black,
                  // Bind data source
                  dataSource: !chartInfo[key]['filtered'] ? chartData[key]!:chartDataFiltered[key]!,
                  xValueMapper: (LineChartData data, _) => data.x,
                  yValueMapper: (LineChartData data, _) => data.y,
                  //selectionBehavior: _selectionBehavior
                ),*/
              ]));
}

/*
Widget getLoadMoreViewBuilder(BuildContext context, ChartSwipeDirection direction,key) {
  if (direction == ChartSwipeDirection.end) {
    return FutureBuilder<String>(
      future: updateDataTest(key),
      /// Adding data by updateDataSource method
      builder: (BuildContext futureContext, AsyncSnapshot<String> snapShot) {
        return snapShot.connectionState != ConnectionState.done
            ? const CircularProgressIndicator()
            : SizedBox.fromSize(size: Size.zero);
      },
    );
  } else {
    return SizedBox.fromSize(size: Size.zero);
  }
}
*/
void addSupplierChartData(supplier,yieldLoss){
  //add to chartcolumndata
  Color color = randomColor.randomColor(colorHue: ColorHue.purple);
  if(supplierColumnData[supplier] == null){
    supplierColumnData[supplier] = [];
  }
  if(supplierColumnColors[supplier] == null) {
    supplierColumnColors[supplier] = color;
  }
  if(supplierColumnData[supplier]!.isEmpty) {
    supplierColumnData[supplier]!.add(SupplierColumnChart(supplier, yieldLoss));
    addSupplierChartSeries(supplier);
  }else{
    //just update it
    supplierColumnData[supplier]![0] = SupplierColumnChart(supplier, yieldLoss);
  }

}

void addSupplierChartSeries(supplier){
  supplierColumnDataSeries.add(ColumnSeries<SupplierColumnChart, String>(
    dataLabelSettings: DataLabelSettings(color:supplierColumnColors[supplier],isVisible: true),
      onRendererCreated: (ChartSeriesController controller) {
        supplierColumnController = controller;
      },
      color: supplierColumnColors[supplier],
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      dataSource: supplierColumnData[supplier]!,
      xValueMapper: (SupplierColumnChart data, _) => data.supplier,
      yValueMapper: (SupplierColumnChart data, _) => data.yieldLoss
  ));
}

supplierColumnChartShow(){
  return Container(height:MediaQuery.of(NavigationService.navigatorKey.currentContext!).size.height/3,width:MediaQuery.of(NavigationService.navigatorKey.currentContext!).size.width/4,child:Card(elevation:13,child:SfCartesianChart(
      title: ChartTitle(text: 'Supplier Yield Loss'),
      primaryXAxis: CategoryAxis(
        isVisible: true,
        title: AxisTitle(
          text: 'Supplier',
        ),
      ),
      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: 100,
        labelFormat:'{value}%',
        title: AxisTitle(
          text: 'Yield Loss',
        ),
      ),
      series: <ChartSeries<SupplierColumnChart, String>>[
        // Renders column chart
        for(var series in supplierColumnDataSeries) series
      ]
  )));
}

/*updateDataTest(site){
  if(chartData[site] == null) {
    chartData[site] = [];
    for(var i = 0; i < firebaseYields[site]['yield'].length;i++){
      chartData[site]!.add(LineChartData(firebaseYields[site]['date'][i]!, firebaseYields[site]['yield'][i]!));
    }
  }else{
    //just add last one
    chartData[site]!.add(LineChartData(firebaseYields[site]['date'].last!, firebaseYields[site]['yield'].last!));
  }
}*/
