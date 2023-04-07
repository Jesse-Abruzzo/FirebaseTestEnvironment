import 'package:flutter/material.dart';
import 'package:iot_dashboard/globals.dart';
import 'package:iot_dashboard/navService.dart';
import 'package:iot_dashboard/releaseNotesPage.dart';
import 'package:sidebarx/sidebarx.dart';

Widget sideDrawer(){
  return SidebarX(
    animationDuration: Duration(milliseconds: 100),
    controller: controller,
    theme: SidebarXTheme(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: currentTheme ? Colors.black54:Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      hoverColor: Colors.red,
      selectedTextStyle: TextStyle(color: Colors.white),
      itemTextPadding: const EdgeInsets.only(left: 30),
      selectedItemTextPadding: const EdgeInsets.only(left: 30),
      selectedItemDecoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      iconTheme: IconThemeData(
        color: Colors.black.withOpacity(0.9),
        size: 20,
      ),
      selectedIconTheme: const IconThemeData(
        color: Colors.white,
        size: 20,
      ),
    ),
    extendedTheme: SidebarXTheme(
      hoverColor: Colors.red,
      width: 200,
      decoration: BoxDecoration(
        color: currentTheme ? Colors.black54:Colors.white,
      ),
    ),
    headerBuilder: (context, extended) {
      return Hero(tag:'LoginLogo',child:SizedBox(
        height: 100,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: controller.extended && currentTheme ? Image.asset('assets/zebraWhite.png'):controller.extended && !currentTheme ? Image.asset('assets/zebraBlack.png'):!controller.extended && !currentTheme ?Image.asset('assets/zebraBlackHead.png'):Image.asset('assets/zebraWhiteHead.png'),
        ),
      ));
    },
    items: [
      SidebarXItem(
        icon: Icons.home,
        label: 'Home',
        onTap: () {
          NavigationService.navigatorKey.currentState?.popUntil((route) {
            if(route.settings.name != '/yieldDashboard'){
              Navigator.pushNamed(NavigationService.navigatorKey.currentContext!, '/yieldDashboard');
            }
            return true;
          });
        },
      ),
      const SidebarXItem(
        icon: Icons.dashboard,
        label: 'DashBoards',
      ),
      SidebarXItem(
        icon: Icons.add_alert,
        label: 'Alerts',
        onTap: (){
          NavigationService.navigatorKey.currentState?.popUntil((route) {
            if(route.settings.name != '/alertsPage'){
              if(yieldUpdateTimer != null && yieldUpdateTimer.isActive) {
                yieldUpdateTimer.cancel();
              }
              Navigator.pushNamed(NavigationService.navigatorKey.currentContext!, '/alertsPage');
            }
            return true;
          });
        }
      ),
      SidebarXItem(
        iconWidget: currentTheme ? Icon(Icons.dark_mode_outlined,color: Colors.black):Icon(Icons.light_mode_outlined, color:Colors.black),
        label:  currentTheme ? 'Dark Mode':'Light Mode',
        onTap: (){
          Globals().changeTheme(!currentTheme);
        }
      ),
      SidebarXItem(
        icon: Icons.info_outline,
        label: 'About',
        onTap: () {
          NavigationService.navigatorKey.currentState?.popUntil((route) {
            if(route.settings.name != '/releaseNotes'){
              if(yieldUpdateTimer != null && yieldUpdateTimer.isActive) {
                yieldUpdateTimer.cancel();
              }
              Navigator.pushNamed(NavigationService.navigatorKey.currentContext!, '/releaseNotes');
            }
            return true;
          });
          //Navigator.push(NavigationService.navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => ReleaseNotesPage()));
        },
      ),
      SidebarXItem(
        icon: Icons.logout,
        label: 'Log Out',
        onTap: () {}
      ),
    ],
  );
}