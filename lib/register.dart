import 'package:flutter/material.dart';
import 'helpers/dbhelper.dart';
import 'models/user.dart';
import 'models/profile.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  DbHelper dbHelper = DbHelper();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  Future<int> addUser(User object) async {
    int id = 0;
    try {
      id = await dbHelper.insert(object);
      getIdUser(object).then((idUser) {
        Profile profile = new Profile(idUser, '', '', '');
        addProfiles(profile);
      });
    } catch (err) {}
    // ignore: unused_catch_stack

    return id;
  }

  Future<int> getIdUser(User object) async {
    int id = 0;
    Map<String, dynamic> mapUser = object.toMap();
    await dbHelper
        .select(mapUser['username'], mapUser['password'])
        .then((mapList) {
      if (mapList.length > 0) {
        //get id_user
        mapList.forEach((element) {
          id = element['id'];
        });
      }
    });
    return id;
  }

  Future<int> addProfiles(Profile object) async {
    int count = 0;
    try {
      count = await dbHelper.insertProfile(object);
    }
    // ignore: unused_catch_stack
    catch (err) {}
    return count;
  }

  void deleteUsers() async {
    await dbHelper.deleteAll();
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
                      'Register',
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
                                      controller: usernameController,
                                      decoration: InputDecoration(
                                        hintText: 'Username',
                                        labelText: 'Username',
                                        icon: Icon(Icons.person),
                                      ))),
                              Container(
                                  margin: EdgeInsets.fromLTRB(10, 2, 10, 2),
                                  child: TextFormField(
                                      controller: passwordController,
                                      decoration: InputDecoration(
                                        hintText: 'Password',
                                        labelText: 'Password',
                                        icon: Icon(Icons.lock),
                                      ))),
                              Container(
                                  margin: EdgeInsets.fromLTRB(10, 2, 10, 2),
                                  child: TextFormField(
                                      controller: emailController,
                                      decoration: InputDecoration(
                                        hintText: 'Email',
                                        labelText: 'Email',
                                        icon: Icon(Icons.email),
                                      ))),
                            ],
                          )),
                      Expanded(
                          child: FloatingActionButton(
                        child: Icon(Icons.send),
                        onPressed: () {
                          addUser(User(
                                  usernameController.text,
                                  passwordController.text,
                                  emailController.text))
                              .then((count) {
                            if (count > 0) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("user " +
                                    usernameController.text +
                                    " berhasil ditambahkan"),
                                backgroundColor: Colors.green,
                              ));
                              Navigator.pushNamed(context, '/login');
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("user " +
                                    usernameController.text +
                                    " gagal ditambahkan"),
                                backgroundColor: Colors.green,
                              ));
                            }
                          });
                        },
                      ))
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red)),
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text('back To Login'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red)),
                      onPressed: () {
                        deleteUsers();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Users are successfully deleted"),
                          backgroundColor: Colors.green,
                        ));
                      },
                      child: Text('Delete All Users'),
                    ),
                  ),
                ])))));
  }
}
