
import 'package:assignment_dashboard/model/division_model.dart';
import 'package:intl/intl.dart';

class AccountModel {
  String name = '';
  String userId = '';
  String email = '';
  String handPhone = '';
  String nip = '';
  String divisionId = '';
  String divisionDesc = '';
  String designationId = '';
  String designationDesc = '';
  List<DivisionModel> divisions = [];

  AccountModel.json(Map<String, dynamic> m) {
    fromJSONEncodable(m);
  }

  String getName() {
    return name;
  }

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();
    m['name'] = name;
    m['user_id'] = userId;
    m['email'] = email;
    m['handphone'] = handPhone;
    m['nip'] = nip;
    m['division_id'] = divisionId;
    m['division_desc'] = divisionDesc;
    m['designation_id'] = designationId;
    m['designation_desc'] = designationDesc;
    var listDivision = [];
    for (var i=0; i < divisions.length; i++) {
      listDivision.add(divisions[i].toJSONEncodable());
    }
    m['divisions'] = listDivision;
    return m;
  }

  fromJSONEncodable(Map<String, dynamic> m) {
    name = m['name'];
    userId = m['user_id'];
    email = m['email'];
    handPhone = m['handphone'];
    nip = m['nip'];
    divisionId = m['division_id'];
    divisionDesc = m['division_desc'];
    designationId = m['designation_id'];
    designationDesc = m['designation_desc'];
    for (var i=0; i < m['divisions'].length; i++) {
      divisions.add(DivisionModel.json(m['divisions'][i]));
    }

  }
}