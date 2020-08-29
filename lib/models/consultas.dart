class Consultas {
  int id;
  String name;
  String birth;
  String cpf;
  String image;
  bool dependent;
  List<Schedulings> schedulings;

  Consultas(
      {this.id,
      this.name,
      this.birth,
      this.cpf,
      this.image,
      this.dependent,
      this.schedulings});

  Consultas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    birth = json['birth'];
    cpf = json['cpf'];
    image = json['image'];
    dependent = json['dependent'];
    if (json['schedulings'] != null) {
      schedulings = new List<Schedulings>();
      json['schedulings'].forEach((v) {
        schedulings.add(new Schedulings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['birth'] = this.birth;
    data['cpf'] = this.cpf;
    data['image'] = this.image;
    data['dependent'] = this.dependent;
    if (this.schedulings != null) {
      data['schedulings'] = this.schedulings.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Schedulings {
  int id;
  int requisitionId;
  int procedureId;
  String dateScheduling;
  String timeStartingBooked;
  String timeEndBooked;
  String professionalName;
  int professionalId;
  String professionalImage;
  String checkIn;
  String dateCheckin;

  Schedulings(
      {this.id,
      this.requisitionId,
      this.procedureId,
      this.dateScheduling,
      this.timeStartingBooked,
      this.timeEndBooked,
      this.professionalName,
      this.professionalId,
      this.professionalImage,
      this.dateCheckin,
      this.checkIn});

  Schedulings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    requisitionId = json['requisition_id'];
    procedureId = json['procedure_id'];
    dateScheduling = json['date_scheduling'];
    timeStartingBooked = json['time_starting_booked'];
    timeEndBooked = json['time_end_booked'];
    professionalName = json['professional_name'];
    professionalId = json['professional_id'];
    professionalImage = json['professional_image'];
    dateCheckin = json['date_checkin'];
    checkIn = json['check_in'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['requisition_id'] = this.requisitionId;
    data['procedure_id'] = this.procedureId;
    data['date_scheduling'] = this.dateScheduling;
    data['time_starting_booked'] = this.timeStartingBooked;
    data['time_end_booked'] = this.timeEndBooked;
    data['professional_name'] = this.professionalName;
    data['professional_id'] = this.professionalId;
    data['professional_image'] = this.professionalImage;
    data['date_checkin'] = this.dateCheckin;
    data['check_in'] = this.checkIn;
    return data;
  }
}