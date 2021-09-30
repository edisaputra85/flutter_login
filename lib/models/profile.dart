class Profile {
  int _idUser;
  String _fullname;
  String _phone;
  String _address;

  //konstruktor versi 1
  Profile(this._idUser, this._fullname, this._phone, this._address);
  //konstruktor versi 2
  Profile.fromMap(Map<String, dynamic> map) {
    this._idUser = map['id_user'];
    this._fullname = map['fullname'];
    this._phone = map['phone'];
    this._address = map['address'];
  }
  //konversi dari contact ke map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id_user'] = this._idUser;
    map['fullname'] = this._fullname;
    map['phone'] = this._phone;
    map['address'] = this._address;
    return map;
  }

  void setFullname(String fullname) {
    this._fullname = fullname;
  }

  void setPhone(String phone) {
    this._phone = phone;
  }

  void setAddress(String address) {
    this._address = address;
  }
}
