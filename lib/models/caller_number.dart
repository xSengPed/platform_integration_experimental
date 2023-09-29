class CallerNumber {
  int? id;
  String? number;
  String? title;

  CallerNumber({this.id, this.number, this.title});

  CallerNumber.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['number'] = this.number;
    data['title'] = this.title;
    return data;
  }
}
