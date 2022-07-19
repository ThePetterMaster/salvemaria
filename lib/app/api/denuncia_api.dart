import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:salvemaria/app/models/denuncia/denuncia.dart';
import 'package:salvemaria/app/models/pessoa/pessoa.dart';
import 'package:salvemaria/utils/constants.dart';

class DenunciaApi {
  static Future<bool> enviarDenuncia(Denuncia? d) async {
    //  Map<String, String> headers = {};
    try {
      Pessoa? p = await Pessoa.get();

      HttpClient client = new HttpClient();
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

      var dia = p?.dataNascimento?.substring(0, 2);
      var mes = p?.dataNascimento?.substring(3, 5);
      var ano = p?.dataNascimento?.substring(6, 10);

      String dataNascimentoFormatada = ano! + "-" + mes! + "-" + dia!;

      var authority = isProd ? PRODUCAO : LOCALHOST;
      var path = isProd
          ? "/monitoramento/novaDenuncia"
          : "/monitoramento/novaDenuncia";

      //var url = 'http://salvemaria.ssp.ma.gov.br:8383/rest/denuncia/salvar';
      //172.20.2.88

      Map<String, String> body = {
        "tipo": d?.tipo ?? '',
        "latitude": d?.latitude ?? '',
        "longitude": d?.longitude ?? '',
        "imei": d?.imei ?? '',
        "numero": d?.numero ?? '',
        "cidade": d?.cidade ?? '',
        "bairro": d?.bairro ?? '',
        "vitima": p?.nome ?? '',
        "idade": p?.idade ?? '',
        "dataNascimento": dataNascimentoFormatada,
        "complemento": p?.complemento ?? '',
        "so": d?.so ?? '',
        "cep": d?.cep ?? '',
        "endereco": d?.endereco ?? '',
        "estado": d?.estado ?? '',
        "cpf": p?.cpf ?? '',
        "telefone": p?.telefone ?? '',
        "imagem": p?.imagem ?? '',
      };

      Map<String, String> headers = {"Content-Type": "application/json"};

      final _uri =
          isProd ? Uri.https(authority, path) : Uri.http(authority, path);

      // var body = convert.json.encode(params);
      // var response = await http.get(_uri, body: body);

      var response =
          await http.post(_uri, headers: headers, body: jsonEncode(body));
      // var response = await http.post(_uri, headers: headers);
      // updateCookie(response, headers);

      if (response.statusCode == 200) {
        return true;
      }

      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static void updateCookie(
      http.Response response, Map<String, String> headers) {
    String rawCookie = response.headers['set-cookie']!;
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }

  // static Future<bool> enviarDenunciaLocal(Denuncia d) async {
  //   try {
  //     Pessoa? p = await Pessoa.get();

  //     var authority = "172.20.2.88:8081";
  //     var path = "/denuncia/nova";

  //     // var url = 'http://172.20.2.88:8081/denuncia/nova';
  //     // var url = 'http://172.20.2.158:8080/salvemaria/rest/denuncia/salvar';

  //     Map<String, String?> body = {
  //       "tipo": d.tipo.toString(),
  //       "latitude": d.latitude.toString(),
  //       "longitude": d.longitude.toString(),
  //       "imei": d.imei.toString(),
  //       "numero": d.numero.toString(),
  //       "cidade": d.cidade.toString(),
  //       "bairro": d.bairro.toString(),
  //       "vitima": p?.nome.toString(),
  //       "idade": p?.idade.toString(),
  //       "complemento": p?.telefone.toString(),
  //       "so": d.so.toString(),
  //       "cep": d.cep.toString(),
  //       "endereco": d.endereco.toString(),
  //       "estado": d.estado.toString()
  //     };

  //     //Map<String, String> headers = {
  //     // "Content-Type": "application/json",
  //     //};
  //     final _uri = Uri.http(authority, path);

  //     // var body = convert.json.encode(params);
  //     var response = await http.post(_uri, body: body);

  //     if (response.statusCode == 200) {
  //       return true;
  //     }

  //     return false;
  //   } catch (e) {
  //     return false;
  //   }
  // }
}
