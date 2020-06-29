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
  String medicalRecord;
  int agreementId;
  String registrationAgreement;
  String birth;
  String age;
  String gender;
  String rg;
  String cpf;
  String responsible;
  String responsibleCpf;
  String image;
  String createdAt;
  String updatedAt;
  String deletedAt;
  int secondId;
  int findoutOption;
  bool dependent;
  List<Requisitions> requisitions;
  List<Schedulings> schedulings;

  Data(
      {this.id,
      this.name,
      this.medicalRecord,
      this.agreementId,
      this.registrationAgreement,
      this.birth,
      this.age,
      this.gender,
      this.rg,
      this.cpf,
      this.responsible,
      this.responsibleCpf,
      this.image,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.secondId,
      this.findoutOption,
      this.dependent,
      this.requisitions,
      this.schedulings});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    medicalRecord = json['medical_record'];
    agreementId = json['agreement_id'];
    registrationAgreement = json['registration_agreement'];
    birth = json['birth'];
    age = json['age'];
    gender = json['gender'];
    rg = json['rg'];
    cpf = json['cpf'];
    responsible = json['responsible'];
    responsibleCpf = json['responsible_cpf'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    secondId = json['second_id'];
    findoutOption = json['findout_option'];
    dependent = json['dependent'];
    if (json['requisitions'] != null) {
      requisitions = new List<Requisitions>();
      json['requisitions'].forEach((v) {
        requisitions.add(new Requisitions.fromJson(v));
      });
    }
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
    data['medical_record'] = this.medicalRecord;
    data['agreement_id'] = this.agreementId;
    data['registration_agreement'] = this.registrationAgreement;
    data['birth'] = this.birth;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['rg'] = this.rg;
    data['cpf'] = this.cpf;
    data['responsible'] = this.responsible;
    data['responsible_cpf'] = this.responsibleCpf;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['second_id'] = this.secondId;
    data['findout_option'] = this.findoutOption;
    data['dependent'] = this.dependent;
    if (this.requisitions != null) {
      data['requisitions'] = this.requisitions.map((v) => v.toJson()).toList();
    }
    if (this.schedulings != null) {
      data['schedulings'] = this.schedulings.map((v) => v.toJson()).toList();
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
  int applicantProfessionalId;
  String medicalRecord;
  int clinicId;
  String createdAt;
  String updatedAt;
  String deletedAt;

  Requisitions(
      {this.id,
      this.agreementId,
      this.dateReq,
      this.type,
      this.statusAgreement,
      this.customerId,
      this.applicantProfessionalId,
      this.medicalRecord,
      this.clinicId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Requisitions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    agreementId = json['agreement_id'];
    dateReq = json['date_req'];
    type = json['type'];
    statusAgreement = json['status_agreement'];
    customerId = json['customer_id'];
    applicantProfessionalId = json['applicant_professional_id'];
    medicalRecord = json['medical_record'];
    clinicId = json['clinic_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['agreement_id'] = this.agreementId;
    data['date_req'] = this.dateReq;
    data['type'] = this.type;
    data['status_agreement'] = this.statusAgreement;
    data['customer_id'] = this.customerId;
    data['applicant_professional_id'] = this.applicantProfessionalId;
    data['medical_record'] = this.medicalRecord;
    data['clinic_id'] = this.clinicId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
  }
}

class Schedulings {
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
  List<Requisitions> requisitions;
  List<Tickets> tickets;

  Schedulings(
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
      this.requisitions,
      this.tickets});

  Schedulings.fromJson(Map<String, dynamic> json) {
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
    if (json['tickets'] != null) {
      tickets = new List<Tickets>();
      json['tickets'].forEach((v) {
        tickets.add(new Tickets.fromJson(v));
      });
    }
    if (json['requisitions'] != null) {
      requisitions = new List<Requisitions>();
      json['requisitions'].forEach((v) {
        requisitions.add(new Requisitions.fromJson(v));
      });
    }
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
    if (this.tickets != null) {
      data['tickets'] = this.tickets.map((v) => v.toJson()).toList();
    }
    if (this.requisitions != null) {
      data['requisitions'] = this.requisitions.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Professional {
  int id;
  String name;
  String image;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String appointmentDuration;
  String returnDuration;
  String nickname;
  int totenMessageId;
  bool active;

  Professional(
      {this.id,
      this.name,
      this.image,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.appointmentDuration,
      this.returnDuration,
      this.nickname,
      this.totenMessageId,
      this.active});

  Professional.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    appointmentDuration = json['appointment_duration'];
    returnDuration = json['return_duration'];
    nickname = json['nickname'];
    totenMessageId = json['toten_message_id'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['appointment_duration'] = this.appointmentDuration;
    data['return_duration'] = this.returnDuration;
    data['nickname'] = this.nickname;
    data['toten_message_id'] = this.totenMessageId;
    data['active'] = this.active;
    return data;
  }
}

class Tickets {
  int id;
  int procedureId;
  int agreementId;
  int professionalId;
  int attendanceTypeId;
  String name;
  String photo;
  String status;
  String startedAt;
  String finishedAt;
  String source;
  int weight;
  String password;
  String createdAt;
  String updatedAt;
  String deletedAt;
  int customerId;
  int userId;
  String idleTime;
  String timeEndAttendance;
  String viewed;
  String satisfaction;
  String hashId;
  String ticketRef;
  Pivot pivot;

  Tickets(
      {this.id,
      this.procedureId,
      this.agreementId,
      this.professionalId,
      this.attendanceTypeId,
      this.name,
      this.photo,
      this.status,
      this.startedAt,
      this.finishedAt,
      this.source,
      this.weight,
      this.password,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.customerId,
      this.userId,
      this.idleTime,
      this.timeEndAttendance,
      this.viewed,
      this.satisfaction,
      this.hashId,
      this.ticketRef,
      this.pivot});

  Tickets.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    procedureId = json['procedure_id'];
    agreementId = json['agreement_id'];
    professionalId = json['professional_id'];
    attendanceTypeId = json['attendance_type_id'];
    name = json['name'];
    photo = json['photo'];
    status = json['status'];
    startedAt = json['started_at'];
    finishedAt = json['finished_at'];
    source = json['source'];
    weight = json['weight'];
    password = json['password'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    customerId = json['customer_id'];
    userId = json['user_id'];
    idleTime = json['idle_time'];
    timeEndAttendance = json['time_end_attendance'];
    viewed = json['viewed'];
    satisfaction = json['satisfaction'];
    hashId = json['hash_id'];
    ticketRef = json['ticket_ref'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['procedure_id'] = this.procedureId;
    data['agreement_id'] = this.agreementId;
    data['professional_id'] = this.professionalId;
    data['attendance_type_id'] = this.attendanceTypeId;
    data['name'] = this.name;
    data['photo'] = this.photo;
    data['status'] = this.status;
    data['started_at'] = this.startedAt;
    data['finished_at'] = this.finishedAt;
    data['source'] = this.source;
    data['weight'] = this.weight;
    data['password'] = this.password;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['customer_id'] = this.customerId;
    data['user_id'] = this.userId;
    data['idle_time'] = this.idleTime;
    data['time_end_attendance'] = this.timeEndAttendance;
    data['viewed'] = this.viewed;
    data['satisfaction'] = this.satisfaction;
    data['hash_id'] = this.hashId;
    data['ticket_ref'] = this.ticketRef;
    if (this.pivot != null) {
      data['pivot'] = this.pivot.toJson();
    }
    return data;
  }
}

class Pivot {
  int schedulingId;
  int ticketId;

  Pivot({this.schedulingId, this.ticketId});

  Pivot.fromJson(Map<String, dynamic> json) {
    schedulingId = json['scheduling_id'];
    ticketId = json['ticket_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scheduling_id'] = this.schedulingId;
    data['ticket_id'] = this.ticketId;
    return data;
  }
}
