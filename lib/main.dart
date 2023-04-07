import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iot_dashboard/alertsPage.dart';
import 'package:iot_dashboard/auth/loginScreen.dart';
import 'package:iot_dashboard/mainSitesPage.dart';
import 'package:iot_dashboard/releaseNotesPage.dart';
import 'package:platform_device_id/platform_device_id.dart';

import 'firebase_options.dart';
import 'globals.dart';
import 'navService.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
      //get device ID
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //getDeviceID();
    return StreamBuilder<bool>(
        initialData: true,
        stream: theme.stream,
        builder: (context, snapshot) {
          return MaterialApp (
              initialRoute: '/yieldDashboard',
              routes: {
                // When navigating to the "/" route, build the FirstScreen widget.
                '/': (context) => const LoginScreen(),
                // When navigating to the "/second" route, build the SecondScreen widget.
                '/releaseNotes': (context) => ReleaseNotesPage(),
                '/yieldDashboard': (context) => MainSitePage(),
                '/alertsPage': (context) => const AlertsPage()
              },
              navigatorKey: NavigationService.navigatorKey, // set property
              title: 'IOT Dashboard',
              theme: ThemeData(
                  scaffoldBackgroundColor: Colors.blueGrey,
                  brightness: Brightness.light,
                  fontFamily: 'Montserrat'
              ),
              darkTheme: ThemeData(
                scaffoldBackgroundColor: Colors.black54,
                fontFamily: 'Montserrat',
                brightness: Brightness.dark,
                /* dark theme settings */
              ),
              themeMode: currentTheme ? ThemeMode.dark : ThemeMode.light,
              /* ThemeMode.system to follow system theme,
         ThemeMode.light for light theme,
         ThemeMode.dark for dark theme
      */
              debugShowCheckedModeBanner: false,
              //home:  MainSitePage()
          );
        });
  }
}

getDeviceID() async {
  deviceID = (await PlatformDeviceId.getDeviceId)!;
}