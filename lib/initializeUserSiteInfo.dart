import 'package:flutter/material.dart';
import 'package:iot_dashboard/charts.dart';
import 'package:iot_dashboard/globals.dart';
import 'package:iot_dashboard/navService.dart';

import 'getListOfType.dart';

void initalizeUserSiteInfo(){
  BuildContext context = NavigationService.navigatorKey.currentContext!;

  yields.forEach((supplier, value) {
    List siteNames = List.from(value.keys.toList());
    siteNames.remove('YieldData');
    siteNames.remove('RFTY');
    for(var site in siteNames) {
      if (siteCardInfo[site] == null) {
        siteCardInfo[site] = {};
      }
      if (siteCardInfo[site]['userChoices'] == null) {
        siteCardInfo[site]['userChoices'] = {};
      }
      if (siteCardInfo[site]['userChoices']['Supplier'] == null) {
        siteCardInfo[site]['userChoices']['Supplier'] = '';
      }
      if (siteCardInfo[site]['userChoices']['Site'] == null) {
        siteCardInfo[site]['userChoices']['Site'] = '';
      }
      if (siteCardInfo[site]['userChoices']['bu'] == null) {
        siteCardInfo[site]['userChoices']['bu'] = '';
      }
      if (siteCardInfo[site]['userChoices']['Program'] == null) {
        siteCardInfo[site]['userChoices']['Program'] = '';
      }
      if (siteCardInfo[site]['userChoices']['Process'] == null) {
        siteCardInfo[site]['userChoices']['Process'] = '';
      }
      if (siteCardInfo[site]['userChoices']['Station'] == null) {
        siteCardInfo[site]['userChoices']['Station'] = '';
      }
      if (preBuiltCharts[site] == null) {
        preBuiltCharts[site] = {};
      }
      preBuiltCharts[site]['chart'] = preBuildAChartSeries(supplier, context, site, value, 'Site');
    }
  });
}