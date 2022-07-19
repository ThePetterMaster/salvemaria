import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:salvemaria/app/models/pessoa/pessoa.dart';
import 'package:salvemaria/utils/constants.dart';

class AcompanhamentoApi {
  static Future<bool> enviarLocalizacao(String lat, String long) async {
    try {
      Pessoa? p = await Pessoa.get();

      HttpClient client = new HttpClient();
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

      final authority = isProd ? PRODUCAO : LOCALHOST;
      final path = "/acompanhamento";

      Map<String, String> body = {"lat": lat, "long": long, "cpf": p!.cpf!};
      final _uri =
          isProd ? Uri.https(authority, path) : Uri.http(authority, path);

      Map<String, String> headers = {
        "Content-Type": "application/json",
      };

      // var body = convert.json.encode(params);
      // var response = await http.get(_uri, body: body);

      var response =
          await http.post(_uri, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        return true;
      }

      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
