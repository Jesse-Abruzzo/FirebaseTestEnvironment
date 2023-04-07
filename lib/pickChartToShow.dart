import 'package:flutter/material.dart';
import 'package:iot_dashboard/globals.dart';

Widget pickChartToShow(site,shownChart){
  if(shownChart == 'Site'){
    return preBuiltCharts[site]['chart'];
  }else if(shownChart == 'bu'){
    return preBuiltCharts[site][siteCardInfo[site]['userChoices']['bu']]['chart'];
  }else if(shownChart == 'Program'){
   return preBuiltCharts[site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']]['chart'];
  } else if(shownChart == 'Process'){
    return preBuiltCharts[site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']][siteCardInfo[site]['userChoices']['Process']]['chart'];
  }else if(shownChart == 'Station'){
    return preBuiltCharts[site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']][siteCardInfo[site]['userChoices']['Process']][siteCardInfo[site]['userChoices']['Station']]['chart'];
  }else{
   return Text('Oops Something went Wrong');
  }
}

 List getRawYieldData(supplier,site,shownChart){
  List temp = [];
  if(shownChart == 'Site'){
      temp = yields[supplier][site]['YieldData'];
  }else if(shownChart == 'bu'){
    temp = yields[supplier][site][siteCardInfo[site]['userChoices']['bu']]['YieldData'];
  }else if(shownChart == 'Program'){
    temp = yields[supplier][site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']]['YieldData'];
  } else if(shownChart == 'Process'){
    temp = yields[supplier][site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']][siteCardInfo[site]['userChoices']['Process']]['YieldData'];
  }else if(shownChart == 'Station'){
    temp = yields[supplier][site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']][siteCardInfo[site]['userChoices']['Process']][siteCardInfo[site]['userChoices']['Station']]['YieldData'];
  }
    return temp;
}

List getYieldChartData(supplier,site,shownChart){
  List temp = [];
  if(shownChart == 'Site'){
    temp = yieldChartData[supplier][site]['YieldData'];
  }else if(shownChart == 'bu'){
    temp = yieldChartData[supplier][site][siteCardInfo[site]['userChoices']['bu']]['YieldData'];
  }else if(shownChart == 'Program'){
    temp = yieldChartData[supplier][site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']]['YieldData'];
  } else if(shownChart == 'Process'){
    temp = yieldChartData[supplier][site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']][siteCardInfo[site]['userChoices']['Process']]['YieldData'];
  }else if(shownChart == 'Station'){
    temp = yieldChartData[supplier][site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']][siteCardInfo[site]['userChoices']['Process']][siteCardInfo[site]['userChoices']['Station']]['YieldData'];
  }
  return temp;
}