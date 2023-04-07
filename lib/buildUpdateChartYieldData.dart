import 'package:iot_dashboard/charts.dart';
import 'package:iot_dashboard/getKeyBasedOnObject.dart';
import 'package:iot_dashboard/globals.dart';
import 'package:iot_dashboard/pickChartToShow.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void buildUpdateChartYieldData(context,chartSwitch,site,supplier){
  if(!chartSwitch) {
    print(siteCardInfo[site]['ShownChart']);
  if(chartInfo[site][siteCardInfo[site]['ShownChart']]['realtime']) {
      if (chartInfo[site][siteCardInfo[site]['ShownChart']]['controller'] != null) {
        List data = getRawYieldData(supplier, site, siteCardInfo[site]['ShownChart']);
        List yieldChartData = getYieldChartData(supplier, site, siteCardInfo[site]['ShownChart']);

        if (data.isNotEmpty) {
          //compare data and only add if needed
          if(data.length > yieldChartData.length){
            for(var i = data.length-1; i > yieldChartData.length-1;i--){
              yieldChartData.add(data[i]);
            }
          }
         // chartInfo[site][siteCardInfo[site]['ShownChart']]['controller'].updateDataSource(removedDataIndexes: List<int>.generate(data.length, (index) => index).toList());
          chartInfo[site][siteCardInfo[site]['ShownChart']]['controller'].updateDataSource(addedDataIndexes: [yieldChartData.length-1]);
        }
      }
    }
    if(supplierColumnController != null && supplierColumnData.isNotEmpty) {
      supplierColumnController!.updateDataSource(updatedDataIndexes: <int>[0]);
    }
  }else{
    switchChartUpdate = false;
  }

}