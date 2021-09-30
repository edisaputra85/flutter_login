import 'package:flutter/material.dart';
import 'package:flutter_login/models/profile.dart';
import './helpers/dbhelper.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  DbHelper dbHelper = new DbHelper();

  final fullnameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  Map<String, dynamic> globalprofile;

  RegExp regexHandphone = RegExp(r'[0-9]{10,13}');
  //Form diperlukan untuk menggunakan fitur validation
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool validateInput() {
    FormState form = this.formKey.currentState;
    return form.validate();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> profile = ModalRoute.of(context).settings.arguments;
    Profile objProfile = Profile.fromMap(profile);
    globalprofile = profile;
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Edit Profile'),
        ),
        body: Container(
            constraints: BoxConstraints.expand(),
            // is used to create container full screen with filled content.
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/background.jpg'),
                  fit: BoxFit.cover),
            ),
            child: SingleChildScrollView(
                child: Form(
                    key: formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.fromLTRB(10, 2, 10, 2),
                              child: TextFormField(
                                  controller: fullnameController,
                                  keyboardType: TextInputType.text,
                                  validator: (String value) {
                                    if (value.isEmpty)
                                      return 'Nama tidak boleh kosong';
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'full name',
                                    labelText: 'Full Name',
                                    icon: Icon(Icons.person),
                                  ))),
                          Container(
                              margin: EdgeInsets.fromLTRB(10, 2, 10, 2),
                              child: TextFormField(
                                  controller: phoneController,
                                  validator: (String value) {
                                    if (value.isEmpty)
                                      return 'Phone Number tidak boleh kosong';
                                    else if (!regexHandphone.hasMatch(value))
                                      return 'Phone number tidak sesuai format';
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'phone number',
                                    labelText: 'Phone Number',
                                    icon: Icon(Icons.phone),
                                  ))),
                          Container(
                              margin: EdgeInsets.fromLTRB(10, 2, 10, 2),
                              child: TextFormField(
                                  controller: addressController,
                                  validator: (String value) {
                                    if (value.isEmpty)
                                      return 'Address tidak boleh kosong';
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'address',
                                    labelText: 'Address',
                                    icon: Icon(Icons.home),
                                  ))),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.red)),
                              onPressed: () {
                                if (validateInput()) {
                                  objProfile
                                      .setFullname(fullnameController.text);
                                  objProfile.setPhone(phoneController.text);
                                  objProfile.setAddress(addressController.text);
                                  dbHelper.updateProfile(objProfile);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        "Your profile is successfully updated"),
                                    backgroundColor: Colors.green,
                                  ));
                                  //Navigator.pop(context); //back to drawer
                                  //Navigator.pop(context); //back to dashboard
                                  Navigator.pushNamed(context, '/dashboard',
                                      arguments: objProfile.toMap());
                                }
                              },
                              child: Text('Simpan'),
                            ),
                          )
                        ])))));
  }
}
