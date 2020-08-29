import 'dart:convert';

Ticket ticketFromJson(String str) {
  final jsonData = json.decode(str);
  return Ticket.fromJson(jsonData);
}

String ticketToJson(Ticket data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Ticket {
  int id;
  String paciente;
  String guiche;

  Ticket({this.id, this.paciente, this.guiche});

  factory Ticket.fromJson(Map<String, dynamic> parsedJson) => new Ticket(
      id: parsedJson["id"],
      paciente: parsedJson["paciente"],
      guiche: parsedJson["guiche"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "paciente": paciente,
        "guiche": guiche,
      };
}
