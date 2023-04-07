import 'package:flutter/material.dart';
import 'package:iot_dashboard/mainSitesPage.dart';

import 'globals.dart';

bool isSwitched = false;

class MyDrawer extends StatefulWidget {
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: Column(children: [
        Expanded(child:ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: currentTheme
                        ? AssetImage("assets/zebraWhite.png")
                        : AssetImage("assets/zebraBlack.png"),
                    fit: BoxFit.contain,
                  )))),
          ListTile(
            ///push if only not on the page
            leading:
            const Text("Main View"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MainSitePage()));
            },
          ),
          ListTile(
            leading:
            const Text("Site Dashboards"),
            onTap: () {
              final snackBar = SnackBar(content: Text('Coming Soon'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          )],
      ),
    ),
        Expanded(
            child:  Column(mainAxisAlignment:MainAxisAlignment.end,children:[
              ListTile(
                leading:
                isSwitched ? const Text('Dark Mode') : const Text("Light Mode"),
                title: Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value;
                      Globals().changeTheme(isSwitched);
                    });
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
                onTap: () {
                  setState(() {
                    isSwitched = !isSwitched;
                    Globals().changeTheme(isSwitched);
                  });
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  title: Text("Version 0.0.1",style: TextStyle(color: Colors.grey)),
                )
            ),])
        )]
      )
    );
  }
}
