
class AccountModel {
  String firstName = '';
  String lastName = '';
  String nickName = '';
  String photo = '';
  DateTime dateOfBirth = DateTime.now();
  String phoneNumber = '';
  String email = '';

  AccountModel(this.email, this.firstName, this.lastName, this.photo);

  AccountModel.storage(Map<String, dynamic> m) {
    fromJSONEncodable(m);
  }

  String getName() {
    return firstName + " " + lastName;
  }

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();

    m['first_name'] = firstName;
    m['last_name'] = lastName;
    m['nick_name'] = nickName;
    m['photo'] = photo;
    m['date_of_birth'] = dateOfBirth.millisecond;
    m['phoneNumber'] = phoneNumber;
    m['email'] = email;
    return m;
  }

  fromJSONEncodable(Map<String, dynamic> m) {
    firstName = m['first_name'];
    lastName = m['last_name'];
    nickName = m['nick_name'];
    photo = m['photo'];
    dateOfBirth = new DateTime.fromMillisecondsSinceEpoch(m['date_of_birth']);
    phoneNumber = m['phoneNumber'];
    email = m['email'];
  }
}