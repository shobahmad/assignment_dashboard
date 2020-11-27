
class AccountModel {
  String firstName = '';
  String lastName = '';
  String nickName = '';
  String placeOfBirth = '';
  DateTime dateOfBirth = DateTime.now();
  String gender = '';
  int generationId = 0;
  String phoneNumber = '';
  String email = '';
  String password = '';

  AccountModel(this.email, this.gender, this.generationId, this.firstName, this.lastName);

  AccountModel.storage(Map<String, dynamic> m) {
    fromJSONEncodable(m);
  }

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();

    m['first_name'] = firstName;
    m['last_name'] = lastName;
    m['nick_name'] = nickName;
    m['place_of_birth'] = placeOfBirth;
    m['date_of_birth'] = dateOfBirth.millisecond;
    m['gender'] = gender;
    m['generationId'] = generationId;
    m['phoneNumber'] = phoneNumber;
    m['email'] = email;
    m['password'] = password;
    return m;
  }

  fromJSONEncodable(Map<String, dynamic> m) {
    firstName = m['first_name'];
    lastName = m['last_name'];
    nickName = m['nick_name'];
    placeOfBirth = m['place_of_birth'];
    dateOfBirth = new DateTime.fromMillisecondsSinceEpoch(m['date_of_birth']);
    gender = m['gender'];
    generationId = m['generationId'];
    phoneNumber = m['phoneNumber'];
    email = m['email'];
    password = m['password'];
  }
}