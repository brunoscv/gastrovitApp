class SchedulingCheckin {
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

  SchedulingCheckin(
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
      this.hasSolicitation});

  SchedulingCheckin.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}