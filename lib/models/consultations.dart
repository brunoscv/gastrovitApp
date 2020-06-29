class Consultations {
  Data data;

  Consultations({this.data});

  Consultations.fromJson(Map<String, dynamic> json) {
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
   String cel;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String deviceId;
  String tokenId;
  int secondId;
  bool dependent;
  List<Requisitions> requisitions;
  List<Scheduling> scheduling;

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
      this.secondId,
      this.dependent,
      this.requisitions,
      this.scheduling});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    agreementId = json['agreement_id'];
    sendWhatsappReport = json['send_whatsapp_report'];
    state = json['state'];
    city = json['city'];
    birth = json['birth'];
    age = json['age'];
    cpf = json['cpf'];
    image = json['image'];
    cel = json['cel'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    deviceId = json['device_id'];
    tokenId = json['token_id'];
    secondId = json['second_id'];
    dependent = json['dependent'];
    if (json['requisitions'] != null) {
      requisitions = new List<Requisitions>();
      json['requisitions'].forEach((v) {
        requisitions.add(new Requisitions.fromJson(v));
      });
    }
    if (json['scheduling'] != null) {
      scheduling = new List<Scheduling>();
      json['scheduling'].forEach((v) {
        scheduling.add(new Scheduling.fromJson(v));
      });
    }
  }

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
    data['dependent'] = this.dependent;
    if (this.requisitions != null) {
      data['requisitions'] = this.requisitions.map((v) => v.toJson()).toList();
    }
    if (this.scheduling != null) {
      data['scheduling'] = this.scheduling.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Requisitions {
  int id;
  int agreementId;
  String dateReq;
  String type;
  String statusAgreement;
  int customerId;
  List<Scheduling> scheduling;

  Requisitions(
      {this.id,
      this.agreementId,
      this.dateReq,
      this.type,
      this.statusAgreement,
      this.customerId,
      this.scheduling});

  Requisitions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    agreementId = json['agreement_id'];
    dateReq = json['date_req'];
    type = json['type'];
    statusAgreement = json['status_agreement'];
    customerId = json['customer_id'];
    if (json['scheduling'] != null) {
      scheduling = new List<Scheduling>();
      json['scheduling'].forEach((v) {
        scheduling.add(new Scheduling.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['agreement_id'] = this.agreementId;
    data['date_req'] = this.dateReq;
    data['type'] = this.type;
    data['status_agreement'] = this.statusAgreement;
    data['customer_id'] = this.customerId;
    if (this.scheduling != null) {
      data['scheduling'] = this.scheduling.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Scheduling {
  int id;
  int requisitionId;
  int professionalId;
  int procedureId;
  String dateScheduling;
  String timeStartingBooked;
  String timeEndBooked;
  String timeStarting;
  String timeEnd;
  int status;
  int exception;
  String obs;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String dateCheckin;
  String receptionStatus;
  bool msnSend1;
  bool msnSend2;
  bool msnSend3;
  bool authorizedCheckin;
  bool pendency;
  String hasSolicitation;
  Professional professional;
  Requisition requisition;

  Scheduling(
      {this.id,
      this.requisitionId,
      this.professionalId,
      this.procedureId,
      this.dateScheduling,
      this.timeStartingBooked,
      this.timeEndBooked,
      this.timeStarting,
      this.timeEnd,
      this.status,
      this.exception,
      this.obs,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.dateCheckin,
      this.receptionStatus,
      this.msnSend1,
      this.msnSend2,
      this.msnSend3,
      this.authorizedCheckin,
      this.pendency,
      this.hasSolicitation,
      this.professional,
      this.requisition});

  Scheduling.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    requisitionId = json['requisition_id'];
    professionalId = json['professional_id'];
    procedureId = json['procedure_id'];
    dateScheduling = json['date_scheduling'];
    timeStartingBooked = json['time_starting_booked'];
    timeEndBooked = json['time_end_booked'];
    timeStarting = json['time_starting'];
    timeEnd = json['time_end'];
    status = json['status'];
    exception = json['exception'];
    obs = json['obs'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    dateCheckin = json['date_checkin'];
    receptionStatus = json['reception_status'];
    msnSend1 = json['msn_send1'];
    msnSend2 = json['msn_send2'];
    msnSend3 = json['msn_send3'];
    authorizedCheckin = json['authorized_checkin'];
    pendency = json['pendency'];
    hasSolicitation = json['has_solicitation'];
    professional = json['professional'] != null
        ? new Professional.fromJson(json['professional'])
        : null;
    requisition = json['requisition'] != null
        ? new Requisition.fromJson(json['requisition'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['requisition_id'] = this.requisitionId;
    data['professional_id'] = this.professionalId;
    data['procedure_id'] = this.procedureId;
    data['date_scheduling'] = this.dateScheduling;
    data['time_starting_booked'] = this.timeStartingBooked;
    data['time_end_booked'] = this.timeEndBooked;
    data['time_starting'] = this.timeStarting;
    data['time_end'] = this.timeEnd;
    data['status'] = this.status;
    data['exception'] = this.exception;
    data['obs'] = this.obs;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['date_checkin'] = this.dateCheckin;
    data['reception_status'] = this.receptionStatus;
    data['msn_send1'] = this.msnSend1;
    data['msn_send2'] = this.msnSend2;
    data['msn_send3'] = this.msnSend3;
    data['authorized_checkin'] = this.authorizedCheckin;
    data['pendency'] = this.pendency;
    data['has_solicitation'] = this.hasSolicitation;
    if (this.professional != null) {
      data['professional'] = this.professional.toJson();
    }
    if (this.requisition != null) {
      data['requisition'] = this.requisition.toJson();
    }
    return data;
  }
}

class Professional {
  int id;
  String name;
  int councilId;
  String image;
  bool active;

  Professional(
      {this.id,
      this.name,
      this.councilId,
      this.image,
      this.active});

  Professional.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    councilId = json['council_id'];
    image = json['image'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['council_id'] = this.councilId;
    data['image'] = this.image;
    data['active'] = this.active;
    return data;
  }
}

class Requisition {
  int id;
  int agreementId;
  String dateReq;
  String type;
  String statusAgreement;
  int customerId;
  Customer customer;

  Requisition(
      {this.id,
      this.agreementId,
      this.dateReq,
      this.type,
      this.statusAgreement,
      this.customerId,
      this.customer});

  Requisition.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    agreementId = json['agreement_id'];
    dateReq = json['date_req'];
    type = json['type'];
    statusAgreement = json['status_agreement'];
    customerId = json['customer_id'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['agreement_id'] = this.agreementId;
    data['date_req'] = this.dateReq;
    data['type'] = this.type;
    data['status_agreement'] = this.statusAgreement;
    data['customer_id'] = this.customerId;
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    return data;
  }
}

class Customer {
  int id;
  String name;

  Customer(
      {this.id,
      this.name,
  });

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
