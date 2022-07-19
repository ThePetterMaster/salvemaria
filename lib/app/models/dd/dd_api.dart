import 'dart:convert';

import 'dart:io';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:salvemaria/app/models/dd/dd_assuntos.dart';
import 'package:salvemaria/app/models/dd/dd_cidades.dart';
import 'package:salvemaria/app/models/dd/dd_denuncia.dart';
import 'package:salvemaria/app/models/dd/dd_protocolo.dart';

class DisqueDenunciaApi {
  static Future<DdProtocolo?> enviarDisqueDenuncia(DdDenuncia d) async {
    try {
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

      var authority = "disquedenunciav01.ssp.ma.gov.br";
      var path = "/apk/salvarDenunciaDev.php";

      //  var url = 'https://disquedenunciav01.ssp.ma.gov.br/apk/salvarDenunciaDev.php';

      Map params = {
        "nomeDenunciante": d.nomeDenunciante,
        "emailDenunciante": d.emailDenunciante,
        "fone": d.fone,
        "imei": d.imei,
        "cidade": d.cidade,
        "modeloCelular": d.modeloCelular,
        "macAdress": d.macAdress,
        "localizacaoCelula": d.localizacaoCelula,
        "posicao": d.posicao,
        "bairro": d.bairro,
        "rua": d.rua,
        "complemento": d.complemento,
        "referencia": d.referencia,
        "descricao": d.descricao,
        "assunto": d.assunto,
        "relato": d.relato,
        "ip": "172.0.0.1"
      };

      Map<String, String> headers = {
        "Content-Type": "application/json",
      };

      final _uri = Uri.https(authority, path);

      var body = convert.json.encode(params);
      var response = await http
          .post(_uri, headers: headers, body: body)
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        return DdProtocolo.fromJson(convert.json.decode(response.body));
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<List<DdCidades>> listarCidades() async {
    try {
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

      final _authority = "disquedenunciav01.ssp.ma.gov.br";
      final _path = "/apk/lerCidades.php";
      final _uri = Uri.https(_authority, _path);

      HttpClientRequest request = await client.getUrl(_uri);
      request.headers.set('content-type', 'application/json');

      HttpClientResponse response = await request.close();

      if (response.statusCode == 204) {
        return [];
      }

      String reply = await response.transform(utf8.decoder).join();

      List list = convert.json.decode(reply);

      return list.map<DdCidades>((map) => DdCidades.fromJson(map)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<List<DdAssuntos>> listarAssuntos() async {
    try {
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

      final _authority = "disquedenunciav01.ssp.ma.gov.br";
      final _path = "/apk/lerAssuntos.php";
      final _uri = Uri.https(_authority, _path);

      HttpClientRequest request = await client.getUrl(_uri);
      request.headers.set('content-type', 'application/json');

      HttpClientResponse response = await request.close();

      if (response.statusCode == 204) {
        return [];
      }

      String reply = await response.transform(utf8.decoder).join();

      List list = convert.json.decode(reply);

      return list.map<DdAssuntos>((map) => DdAssuntos.fromJson(map)).toList();
    } catch (e) {
      return [];
    }
  }
}
