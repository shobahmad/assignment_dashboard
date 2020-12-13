class DivisionModel {
  String divisionId;
  String divisionDesc;

  DivisionModel(this.divisionId, this.divisionDesc);
  DivisionModel.json(Map<String, dynamic> m) {
    divisionId = m['division_id'];
    divisionDesc = m['description'];
  }

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();
    m['division_id'] = divisionId;
    m['description'] = divisionDesc;
    return m;
  }
}