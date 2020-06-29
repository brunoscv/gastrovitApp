class Users {
  List<Data> data;

  Users({this.data});

  Users.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
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
  String cel;
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
      this.cel,
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
      cel: json['cel'],
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
    data['cel'] = this.cel;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['device_id'] = this.deviceId;
    data['token_id'] = this.tokenId;
    data['second_id'] = this.secondId;
    return data;
  }
}
