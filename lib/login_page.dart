import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_register/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _isLoading = false;
  var errorMsg;
  final TextEditingController mobileController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child: _isLoading ? Center(child: CircularProgressIndicator()) : ListView(
          children: <Widget>[
            TextFormField(
              controller: mobileController,
              decoration: InputDecoration(
                hintText: "Phone No",
              ),
            ),
            SizedBox(height: 30.0),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Password",
              ),
            ),
            FlatButton(
              onPressed: () {
                print("Login pressed");
                setState(() {
                  _isLoading = true;
                });
                signIn(mobileController.text, passwordController.text);
              },
              child: Text("Sign In", style: TextStyle(color: Colors.black)),
            ),
            errorMsg == null? Container(): Text(
              "${errorMsg}",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20,),
            Text(
              'Not have an account? Create one,,,',
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 15,
              ),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => RegisterPage()), (Route<dynamic> route) => false);
              },
              elevation: 0.0,
              color: Colors.purple,
              child: Text("Register", style: TextStyle(color: Colors.white70)),
            ),
          ],
        ),
      ),
    );
  }

  signIn(String mobile, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'mobile': mobile,
      'password': pass
    };
    var jsonResponse = null;
    var response = await http.post("http://medimate.skoder.tech/api/user-login", body: data);
    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if(jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse['data']['token']);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MainPage()), (Route<dynamic> route) => false);
      }
    }
    else {
      setState(() {
        _isLoading = false;
      });
      errorMsg = response.body;
      print("The error message is: ${response.body}");
    }
  }

}


