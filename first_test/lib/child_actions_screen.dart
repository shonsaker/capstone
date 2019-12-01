import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'child_checkin_screen.dart';
import 'child_checkout_screen.dart';

Future<List<ActionsInfo>> fetchLoginInfo(http.Client client) async 
{
  // Make the api call 
  // final response =
  // await client.get('https://jsonplaceholder.typicode.com/photos');
  String t = '''[{"description": "Decide what your child will eat", "token": "a token", "title": "Check In"}, 
                    {"description": "Has your child been injured?", "token": "a token", "title": "Check Out"},
                    {"description": "Has your child been injured?", "token": "a token", "title": "Nap Time"},
                    {"description": "Has your child been injured?", "token": "a token", "title": "Diaper Change"},
                    {"description": "Has your child been injured?", "token": "a token", "title": "Mood"}
                    ]''';

  // Use the compute function to run parseLoginInfo in a separate isolate
  // Not sure why it runs in a compute function, but this calls the a function that creates a list from this result
  // return compute(parseLoginInfo, response.body);
  return compute(parseLoginInfo, t);
}

// This function converts a json into a list
List<ActionsInfo> parseLoginInfo(String responseBody) 
{
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  print(parsed);

  return parsed.map<ActionsInfo>((json) => ActionsInfo.fromJson(json)).toList();
}

class ActionsInfo 
{
  final String success;
  final String token;
  final String title; 
  final String description;

  ActionsInfo({this.success, this.token, this.title, this.description});

  factory ActionsInfo.fromJson(Map<String, dynamic> json) 
  {
    return ActionsInfo(
      token: json['token'] as String,
      success: json['success'] as String,
      title: json["title"] as String,
      description: json["description"] as String
    );
  }
}

class ChildActionScreen extends StatelessWidget 
{
  // Pass the class a title 
  final String title;

  ChildActionScreen({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        child: FutureBuilder<List<ActionsInfo>>(
          future: fetchLoginInfo(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? ChildActionInfoList(infoMetric: snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        ),
        padding: EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 10.0),
      ),
    );
  }
}

class ChildActionInfoList extends StatelessWidget 
{
  // Must pass this the list that we want 
  final List<ActionsInfo> infoMetric;

  ChildActionInfoList({Key key, this.infoMetric}) : super(key: key);

  switchScreens(btnName, context)
  {
   // Switch the screen after the user has been authenticated properly
    bool loginStatus = true; 
    if (loginStatus == true)
    {
      print(btnName);
      if(btnName == 'Check In')
      {
          String title = "Student Check In";
          // SecondScreen home = new SecondScreen(title: title); 
          CheckInScreen checkin = new CheckInScreen(title: title);
          Navigator.push(context, new MaterialPageRoute(builder: (context) => checkin));
      }
      else if(btnName == 'Check Out')
      {
          String title = "Student Check Out";
          // SecondScreen home = new SecondScreen(title: title); 
          CheckOutScreen checkout = new CheckOutScreen(title: title);
          Navigator.push(context, new MaterialPageRoute(builder: (context) => checkout));
      }

    }
  }

  @override
  Widget build(BuildContext context) 
  {
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

    return ListView.builder(

      // This needs to be the object we pass from the api 
      itemCount: infoMetric.length,
      itemBuilder: (context, index) 
      {
        String btnName = infoMetric[index].title;

        final loginButton = Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Color(0xff01A0C7),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed:() {
              switchScreens(btnName, context);
            },
            child: Text(infoMetric[index].title,
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
      );

        return Column(
          children: <Widget>[
            Container(
                constraints: BoxConstraints.expand(
                  height: Theme.of(context).textTheme.display1.fontSize * 1.1 +
                      50.0,
                ),
                color: Colors.white10,
                alignment: Alignment.center,
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      loginButton,
                    ],
                  ),
                )),
          ],
        );
      },
    );
  }
}