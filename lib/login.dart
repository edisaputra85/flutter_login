import 'package:flutter/material.dart';
import 'package:flutter_login/helpers/dbhelper.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String username = '';
  String password = '';
  // ignore: deprecated_member_use
  List<Map<String, dynamic>> mapList;
  DbHelper dbHelper = new DbHelper();

  //cara lain menggunakan controller
  void onChangedUsername(String username) {
    setState(() {
      this.username = username;
    });
  }

  void onChangedPassword(String password) {
    setState(() {
      this.password = password;
    });
  }

  void onLogin() {
    //select user from db
    dbHelper.select(this.username, this.password).then((mapList) {
      if (mapList.length > 0) {
        //get id_user
        mapList.forEach((element) {
          dbHelper.selectProfile(element['id']).then((mapListProfile) {
            mapListProfile.forEach((elementProfile) {
              Navigator.pushNamed(
                context,
                '/dashboard',
                arguments: elementProfile,
              );
            });
          });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Login gagal"),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            constraints: BoxConstraints.expand(),
            // is used to create container full screen with filled content.
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/background.jpg'),
                  fit: BoxFit.cover),
            ),
            child: Center(
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Text(
                      'Login',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  margin: EdgeInsets.fromLTRB(10, 2, 10, 2),
                                  child: TextFormField(
                                      onChanged: (String value) {
                                        onChangedUsername(value);
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Username',
                                        labelText: 'Username',
                                        icon: Icon(Icons.person),
                                      ))),
                              Container(
                                  margin: EdgeInsets.fromLTRB(10, 2, 10, 2),
                                  child: TextFormField(
                                    onChanged: (String value) {
                                      onChangedPassword(value);
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      labelText: 'Password',
                                      icon: Icon(Icons.lock),
                                    ),
                                    obscureText: true,
                                  )),
                            ],
                          )),
                      Expanded(
                          child: FloatingActionButton(
                        onPressed: () {
                          onLogin();
                        },
                        child: Icon(Icons.login),
                      ))
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    child: OutlinedButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.black),
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red)),
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text('Register'),
                    ),
                  )
                ])))));
  }
}
