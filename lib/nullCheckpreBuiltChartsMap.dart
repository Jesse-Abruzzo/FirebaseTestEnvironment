import 'package:flutter/material.dart';
import 'package:iot_dashboard/globals.dart';

nullCheckpreBuiltChartsMap(site,type){
  if(preBuiltCharts[site] == null){
    preBuiltCharts[site] = {};
  }
  if(preBuiltCharts[site][siteCardInfo[site]['userChoices']['bu']] == null){
    preBuiltCharts[site][siteCardInfo[site]['userChoices']['bu']] = {};
  }
  if(preBuiltCharts[site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']] == null){
    preBuiltCharts[site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']] = {};
  }
  if(preBuiltCharts[site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']][siteCardInfo[site]['userChoices']['Process']] == null){
    preBuiltCharts[site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']][siteCardInfo[site]['userChoices']['Process']] = {};
  }
  if(preBuiltCharts[site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']][siteCardInfo[site]['userChoices']['Process']][siteCardInfo[site]['userChoices']['Station']] == null){
    preBuiltCharts[site][siteCardInfo[site]['userChoices']['bu']][siteCardInfo[site]['userChoices']['Program']][siteCardInfo[site]['userChoices']['Process']][siteCardInfo[site]['userChoices']['Station']] = {};
  }
}