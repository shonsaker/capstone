import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'calls.dart'; 


class ChildFoodScreen extends StatelessWidget 
{
  // Pass the class a title 
  final String title;
  final String jsonString; 

  ChildFoodScreen({Key key, this.title, this.jsonString}) : super(key: key);

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ModChildFoodInfo(jsonString: this.jsonString,)

    );
  }
}

class ModChildFoodInfo extends StatelessWidget 
{
  // Must pass this the list that we want 
  final String jsonString;

  ModChildFoodInfo({Key key, this.jsonString}) : super(key: key);

  void updateEmail(String what, String jsonString)
  {
    Map modJsonString = json.decode(jsonString);
    modJsonString["what"] = what; 
    String updatedJsonString = json.encode(modJsonString);
    // String jsonString = '''{"user_id":"${userId}", "what":"${emailAddr}" }'''; 
    print(updatedJsonString);
    postChildMealsResults(updatedJsonString);
  }

  @override
  Widget build(BuildContext context) 
  {
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
    final emailController = TextEditingController();
    final emailField = TextField(
      obscureText: false,
      style: style,
      controller: emailController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Enter Meal",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final emailButton = Material(
      color: Colors.lightBlue[900],
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),

      child: MaterialButton(
        color: Colors.lightBlue[900],
        clipBehavior: Clip.antiAlias,
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed:() {
          updateEmail(emailController.text, jsonString);
        },
        child: Text("Submit Meal",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      );

        return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 200.0,
                  child: Image.asset('assets/images/Kids_Day_Care.jpg',
                    //fit: BoxFit.contain,
                    //fit: BoxFit.contain
                  ),
                ),
                SizedBox(height: 45.0),
                emailField,
                SizedBox(
                  height: 35.0,
                ),
                emailButton,
              ],
            );
  }
}