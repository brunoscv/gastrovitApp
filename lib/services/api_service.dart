import 'dart:convert';
import 'dart:io';

import '../models/consultas.dart';
import '../models/consultations.dart';
import '../models/users.dart';

import 'package:http/http.dart' as http;

class Urls {
  //static const DEMO_API_URL = "https://demo.denarius.digital/api/mobile";
  static const DEMO_API_URL = "https://gastrovita.inkless.digital/api/mobile";
  static const BASE_API_URL = "https://gastrovita.inkless.digital/api/inklessapp";
  static const CUSTOMER_API_URL = "https://gastrovita.inkless.digital/api";
}

class AuthorizationUsers {
  static Future<Users> getUsers(String stCpf, String dtBirth) async {
    try {
      final response =
          await http.get('${Urls.BASE_API_URL}/cpf/$stCpf/birth/$dtBirth');
      /*Conta a quantidade de caracteres do retorno do response.
        como retorna um body vazio, a contagem de caracteres é igual a 11.
        Se mudar a quantidade de caracteres, basta observar o retorno da api
        e refazer a contagem de caracteres para colocar no if
        ex: do retorno atual quando não se encontra um cpf e uma data de nascimento
        {
            data: [ ]
        }
      */
      if (response.body.length <= 11) {
        return null;
      } else {
        return Users.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      return null;
      //Sempre que apresentar erros de login, descomentar o retorno da Exception para ver o erro.
      //return throw Exception(e);
    }
  }
}

class SchedulingService {
  static Future<Consultations> getUserScheduling(int userId) async {
    try {
      final response = await http.get('${Urls.CUSTOMER_API_URL}/customer/$userId');
      if (response.statusCode == 200) {
        return Consultations.fromJson(json.decode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      return throw Exception(e);
    }
  }
}

class ShortSchedulingService {
  static Future<Consultas> getUserScheduling(int userId) async {
    try {
      final response = await http.get('${Urls.DEMO_API_URL}/checkinid/$userId');
      if (response.statusCode == 200) {
        return Consultas.fromJson(json.decode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      return throw Exception(e);
    }
  }
}

class AllSchedulingService {
  static Future<Consultas> getAllScheduling(int userId) async {
    try {
      final response = await http.get('${Urls.DEMO_API_URL}/checkinidall/$userId');
      if (response.statusCode == 200) {
        return Consultas.fromJson(json.decode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      return throw Exception(e);
    }
  }
}