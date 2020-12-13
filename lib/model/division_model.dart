class DivisionModel {
  String divisionId;
  String divisionDesc;

  DivisionModel(this.divisionId, this.divisionDesc);
  DivisionModel.json(Map<String, dynamic> m) {
    divisionId = m['division_id'];
    divisionDesc = m['division_desc'];
  }

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();
    m['division_id'] = divisionId;
    m['division_desc'] = divisionDesc;
    return m;
  }
}