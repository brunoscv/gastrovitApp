class Userid {
  Data data;

  Userid({this.data});

  Userid.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int id;
  String name;
  int agreementId;
  bool sendWhatsappReport;
  String state;
  String city;
  String birth;
  String age;
  String cpf;
  String image;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String deviceId;
  String tokenId;
  int secondId;

  Data(
    {this.id,
    this.name,
    this.agreementId,
    this.sendWhatsappReport,
    this.state,
    this.city,
    this.birth,
    this.age,
    this.cpf,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.deviceId,
    this.tokenId,
    this.secondId});

 factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json['id'],
    name: json['name'],
    agreementId: json['agreement_id'],
    sendWhatsappReport: json['send_whatsapp_report'],
    state: json['state'],
    city: json['city'],
    birth: json['birth'],
    age: json['age'],
    cpf: json['cpf'],
    image: json['image'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
    deletedAt: json['deleted_at'],
    deviceId: json['device_id'],
    tokenId: json['token_id'],
    secondId: json['second_id']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['agreement_id'] = this.agreementId;
    data['send_whatsapp_report'] = this.sendWhatsappReport;
    data['state'] = this.state;
    data['city'] = this.city;
    data['birth'] = this.birth;
    data['age'] = this.age;
    data['cpf'] = this.cpf;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['device_id'] = this.deviceId;
    data['token_id'] = this.tokenId;
    data['second_id'] = this.secondId;
    return data;
  }
}
