
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:random_color/random_color.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:syncfusion_flutter_charts/charts.dart';



String deviceID = 'NA';
Map siteLoadingChart = {};
List<Alerts> userAlerts = [];
Map yieldChartData = {};
String lastRefreshTime = DateFormat('MM-dd-yyyy hh:mm:ss a').format(DateTime.now()).toString();
var yieldUpdateTimer;
late User userInfo;
bool currentTheme = false;
final controller = SidebarXController(selectedIndex: 0, extended: true);
String supplierFiltered = 'ALL';
List supplierFilteredNames = [];
ChartSeriesController? supplierColumnController;
List<ColumnSeries<SupplierColumnChart, String>> supplierColumnDataSeries = [];
Map<String,List<SupplierColumnChart>> supplierColumnData = {};
Map supplierColumnColors = {};
ChartSeriesController? theController;
RandomColor randomColor = RandomColor();
Map rawFirebaseData = {};
Map<String,Map<String,Map<String,List<LineChartData>>>> chartData = {};
//Map<String,Map<String,List<LineChartData>>> chartData = {};
Map chartInfo = {};
Map firebaseYields = {};
List<SerialNumbers> serialNumbers = [];
Map yields = {};
Map preBuiltCharts = {};
Map<String,Map<String,Map<String,List<LineChartData>>>> chartDataFiltered = {};
Map siteCardInfo = {};
StreamController<bool> theme = StreamController();
bool switchChartUpdate = false;
Map supplierYields = {};
bool snBar = false;


class Globals {

  getFirebaseYields() => firebaseYields;

  void updateFirebaseYields(fb){
    firebaseYields = fb;
  }

  void changeTheme(bool t){
      currentTheme = t;
      theme.add(t);
  }

  getCurrentTheme() => currentTheme;

  getYieldData() => yields;

}

/*class Unit{
  String date;
  String line;
  String status;
  String Station;
  String failureMode;
  String serialNumber;
  String skuNumber;

  Unit({required this.date,required this.line,required this.status, required this.Station, required this.failureMode, required this.serialNumber,required this.skuNumber});

  factory Unit.fromJson(Map<String, dynamic> parsedJson){
    return Unit(
        date: parsedJson['Date'],
        line : parsedJson['Line'],
        status: parsedJson['Status'],
        Station: parsedJson['Station_ID'],
        failureMode: parsedJson['Failure_Mode'],
        serialNumber: parsedJson['SerialNumber'],
        skuNumber: parsedJson['SKUnumber']
    );
  }
  //consists of array of TestSteps
}*/

class TestStep {
  String status;
  double cycleTime;
  String name;
  double value;
  double lowerLimit;
  double upperLimit;
  String zone;
  bool rule1;
  bool rule2;
  bool rule3;
  bool rule4;
  bool rule5;
  bool rule6;
  bool rule7;
  bool rule8;
  bool noRule;

  TestStep(
      {required this.zone, required this.status, required this.name, required this.value, required this.cycleTime, required this.lowerLimit, required this.upperLimit, required this.rule1,
        required this.rule2, required this.rule3, required this.rule4, required this.rule5, required this.rule6, required this.rule7, required this.rule8, required this.noRule});

  factory TestStep.fromJson(Map<String, dynamic> parsedJson){
    return TestStep(
        zone: parsedJson['Zone'],
        status: parsedJson['Status'],
        name: parsedJson['Test_Description'],
        value: parsedJson['Value'],
        cycleTime: parsedJson['Cycle_Time'],
        lowerLimit: parsedJson['LL'],
        upperLimit: parsedJson['UL'],
        rule1: parsedJson['Rule 1'],
        rule2: parsedJson['Rule 2'],
        rule3: parsedJson['Rule 3'],
        rule4: parsedJson['Rule 4'],
        rule5: parsedJson['Rule 5'],
        rule6: parsedJson['Rule 6'],
        rule7: parsedJson['Rule 7'],
        rule8: parsedJson['Rule 8'],
        noRule: parsedJson['No Rule']
    );
  }
}

class SerialNumbers{
  String supplier;
  String site;
  String bu;
  String program;
  String process;
  String Station;
  String serialNumber;
  String failureMode;
  String date;
  String skuNumber;
  String status;
  bool prime;
  List<TestStep> testSteps;


  SerialNumbers({required this.prime,required this.supplier,required this.site,required this.bu,required this.program, required this.process, required this.Station, required this.serialNumber,required this.failureMode,required this.date,required this.skuNumber, required this.status, required this.testSteps});

  factory SerialNumbers.fromJson(Map<String, dynamic> parsedJson){
    return SerialNumbers(
        supplier: parsedJson['Supplier'],
        site : parsedJson['Site'],
        bu: parsedJson['BU'],
        program: parsedJson['Program'],
        process: parsedJson['Process'],
        Station: parsedJson['StationID'],
        serialNumber: parsedJson['SerialNumber'],
        failureMode: parsedJson['Failure_Mode'],
        date: parsedJson['Date'],
        skuNumber: parsedJson['SKUnumber'],
        status: parsedJson['Test_Status'],
        prime: parsedJson['Prime'],
        testSteps: parsedJson['TestSteps'].map<TestStep>((json) => TestStep.fromJson(json)).toList()
    );
  }
}

class Yields{
  String supplier;
  String site;
  String bu;
  String program;
  String process;
  String station;
  String type;
  List<LineChartData> yieldData;


  Yields({required this.type,required this.yieldData,required this.supplier,required this.site,required this.bu,required this.program, required this.process, required this.station});

  factory Yields.fromJson(Map<String, dynamic> parsedJson){
    return Yields(
        supplier: parsedJson['Supplier'],
        site : parsedJson['Site'],
        bu: parsedJson['BU'],
        program: parsedJson['Program'],
        process: parsedJson['Process'],
        station: parsedJson['StationID'],
        type: parsedJson['Type'],
        yieldData: parsedJson['YieldData'].map<LineChartData>((json) => LineChartData.fromJson(json)).toList()
    );
  }
}

class LineChartData {

  final String date;
  final double? yield;
  final String serialNumber;

  LineChartData({required this.date, required this.yield, required this.serialNumber});


  factory LineChartData.fromJson(Map<String, dynamic> parsedJson){
    return LineChartData(
       date: parsedJson['date'],
       yield: parsedJson['yield'],
       serialNumber: parsedJson['SerialNumber']
    );
  }
}

class SupplierColumnChart{
  SupplierColumnChart(this.supplier, this.yieldLoss);
  final String supplier;
  final double yieldLoss;
}

class User{
  String email;
  String password;
  String name;
  User(this.email,this.password,[this.name = 'NA']);
}

class Alerts{
  String topic;
  String trigger;
  String dateRange;
  bool enabled;
  Alerts(this.dateRange,this.topic,this.trigger,this.enabled);
}


