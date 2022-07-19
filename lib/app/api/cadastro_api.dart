import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:salvemaria/app/models/pessoa/pessoa.dart';
import 'package:salvemaria/utils/constants.dart';

class CadastroApi {
  static Future<String> cadastroPessoa(Pessoa? pessoa) async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

    var dia = pessoa?.dataNascimento?.substring(0, 2);
    var mes = pessoa?.dataNascimento?.substring(3, 5);
    var ano = pessoa?.dataNascimento?.substring(6, 10);

    String dataNascimentoFormatada = ano! + "-" + mes! + "-" + dia!;

    try {
      final authority = isProd ? PRODUCAO : LOCALHOST;
      final path = isProd ? "/usuarioapp/novo" : "/usuarioapp/novo";

      // var url = 'http://172.20.2.88:8081/usuarioapp/novo';
      // var url = 'http://salvemaria.ssp.ma.gov.br:8383/rest/usuarioapp/salvar';

      Map<String, String?> body = {
        "nome": pessoa?.nome,
        "nomeMae": pessoa?.nomeMae,
        "cidade": pessoa?.cidade,
        "cpf": pessoa?.cpf,
        "bairro": pessoa?.bairro,
        "complemento": pessoa?.complemento,
        "dataNascimento": dataNascimentoFormatada,
        "cep": pessoa?.cep,
        "endereco": pessoa?.endereco,
        "rg": pessoa?.rg,
        // "idade": pessoa?.idade,
        "nomePai": pessoa?.nomePai,
        "telefone": pessoa?.telefone,
        "imagem": pessoa?.imagem,
      };

      Map<String, String> headers = {
        "Content-Type": "application/json",
      };

      log(body.toString());

      final _uri =
          isProd ? Uri.https(authority, path) : Uri.http(authority, path);
      final response = await http.post(
        _uri,
        body: json.encode(body),
        headers: {
          "Content-Type": "application/json",
        },
      );

      // var response = await http.post(_uri, body: body);

      // var body1 = json.encode(body);
      // var response = await http.post(_uri, headers: headers, body: body1);

      if (response.statusCode == 200) {
        await pessoa?.save();
      }

      await pessoa?.save();

      return response.body;
    } catch (e) {
      print(e);
      return e.toString();
    }
  }
}
