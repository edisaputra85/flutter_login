class User {
  String _username;
  String _password;
  String _email;

  //konstruktor versi 1
  User(this._username, this._password, this._email);
  //konstruktor versi 2
  User.fromMap(Map<String, dynamic> map) {
    this._username = map['username'];
    this._password = map['password'];
    this._email = map['email'];
  }
  //konversi dari contact ke map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['username'] = this._username;
    map['password'] = this._password;
    map['email'] = this._email;
    return map;
  }
}
