import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iot_dashboard/globals.dart';
import 'package:iot_dashboard/sideDrawer.dart';

List<Text> releaseDates = [
  Text("Release Date: 12/2/2022",textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold)),
  Text("Release Date: 1/4/2023", textAlign: TextAlign.right,style: const TextStyle(fontWeight: FontWeight.bold)),
  Text("Release Date: 2/7/2023", textAlign: TextAlign.right,style: const TextStyle(fontWeight: FontWeight.bold)),
  Text("Release Date: 4/4/2023", textAlign: TextAlign.right,style: const TextStyle(fontWeight: FontWeight.bold))
];


class ReleaseNotesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> releaseNotesBody = [
      RichText(
        text: TextSpan(
          // Note: Styles for TextSpans must be explicitly defined.
          // Child text spans will inherit styles from parent
          style: TextStyle(
            fontSize: 14.0,
            color: Theme.of(context).hintColor,
          ),
          children: <TextSpan>[
            TextSpan(text: 'Version 0.0.1:', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: '\n∙First alpha release'),
          ],
        ),
      ),
      RichText(
        text: TextSpan(
          // Note: Styles for TextSpans must be explicitly defined.
          // Child text spans will inherit styles from parent
          style: TextStyle(
            fontSize: 14.0,
            color: Theme.of(context).hintColor,
          ),
          children: <TextSpan>[
            TextSpan(text: 'Version 0.0.2:', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: "\n∙Added:", style: const TextStyle(fontStyle: FontStyle.italic)),
            TextSpan(text: "\n -Release Notes Page"),
            TextSpan(text: "\n -Alerts Page"),
            TextSpan(text: "\n -Animations for Chart Switching"),
            TextSpan(text: "\n∙Changed", style: const TextStyle(fontStyle: FontStyle.italic)),
            TextSpan(text: "\n -Firebase calls to API calls"),
          ],
        ),
      ),
      RichText(
        text: TextSpan(
          // Note: Styles for TextSpans must be explicitly defined.
          // Child text spans will inherit styles from parent
            style: TextStyle(
              fontSize: 14.0,
              color: Theme.of(context).hintColor,
            ),
            children: <TextSpan>[
              TextSpan(text: 'Version 0.0.3:', style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: "\n∙Added:", style: const TextStyle(fontStyle: FontStyle.italic)),
              TextSpan(text: "\n -Version Control"),
              TextSpan(text: "\n -Login Page"),
              TextSpan(text: "\n -Login Page animations"),
              TextSpan(text: "\n -Holiday login page backgrounds"),
              TextSpan(text: "\n -Dark and Light themes"),
              TextSpan(text: "\n -Logout Button"),
              TextSpan(text: "\n -New Side Drawer"),
              TextSpan(text: "\n -Side drawer animation"),
              TextSpan(text: "\n∙General", style: const TextStyle(fontStyle: FontStyle.italic)),
              TextSpan(text: "\n -Cleaned code for chart building"),
              TextSpan(text: "\n -Bug Fixes"),
            ]
        ),
      ),
      RichText(
        text: TextSpan(
          // Note: Styles for TextSpans must be explicitly defined.
          // Child text spans will inherit styles from parent
          style: TextStyle(
            fontSize: 14.0,
            color: Theme.of(context).hintColor,
          ),
          children: <TextSpan>[
            TextSpan(text: 'Version 0.0.4:', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: "\n∙General", style: const TextStyle(fontStyle: FontStyle.italic)),
            TextSpan(text: "\n -Getting Yield Data in chunks instead of all at once"),
            TextSpan(text: "\n∙Added:", style: const TextStyle(fontStyle: FontStyle.italic)),
            TextSpan(text: "\n -Max alert amount '3'"),
          ],
        ),
      ),
    ];
    return Scaffold(
        body:Row(children:[
            sideDrawer(),
          Expanded(child:SingleChildScrollView(child: Column(
            children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
            Container(
                padding: EdgeInsets.only(left:10),
              child:  Text("Release Notes",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none),
              )),
             Container(
                 padding: EdgeInsets.only(top:5),
                  child: Text(
                    "Current Version: 0.0.4",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).hintColor),
                  )),
              Container(
                  padding: EdgeInsets.only(right:10,top:5),
                  child: Text("Device ID: " + deviceID,
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).hintColor),
                  ))]),
        ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount:  releaseNotesBody.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  padding: EdgeInsets.all(5),
                  child:Card(elevation:5,
              child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                Container(
                padding: EdgeInsets.all(5),
                child: releaseNotesBody[index]//Text(releaseNotesBody[index],textAlign: TextAlign.left),
              ),
                Container(
                    padding: EdgeInsets.all(5),
                    child: releaseDates[index]//Text(releaseNotesBody[index],textAlign: TextAlign.left),
                ),
              ])));
            }
        ),
        ])))]));
  }
}
