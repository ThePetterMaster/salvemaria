import 'package:salvemaria/utils/prefs.dart';
import 'dart:convert' as convert;

class Pessoa {
  String? nome;
  String? nomeMae;
  String? idade;
  String? dataNascimento;
  String? cpf;
  String? nomePai;
  String? rg;
  String? cep;
  String? numero;
  String? endereco;
  String? cidade;
  String? complemento;
  String? bairro;
  String? telefone;
  String? imagem;

  Pessoa({
    this.nome,
    this.idade,
    this.telefone,
    this.cep,
    this.numero,
    this.rg,
    this.bairro,
    this.nomeMae,
    this.nomePai,
    this.cpf,
    this.cidade,
    this.complemento,
    this.endereco,
    this.dataNascimento,
    this.imagem,
  });

  Pessoa.fromJson(Map<String, dynamic> map)
      : this.nome = map["nome"],
        this.nomeMae = map["nomeMae"],
        this.cpf = map["cpf"],
        this.nomePai = map["nomePai"],
        this.idade = map["idade"],
        this.rg = map["rg"],
        this.cep = map["cep"],
        this.numero = map["numero"],
        this.bairro = map["bairro"],
        this.dataNascimento = map["dataNascimento"],
        this.endereco = map["endereco"],
        this.cidade = map["cidade"],
        this.telefone = map["telefone"],
        this.complemento = map["complemento"],
        this.imagem = map['imagem'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['nome'] = this.nome;
    data['nomeMae'] = this.nomeMae;
    data['cpf'] = this.cpf;
    data['nomePai'] = this.nomePai;
    data['dataNascimento'] = this.dataNascimento;
    data['endereco'] = this.endereco;
    data['idade'] = this.idade;
    data['rg'] = this.rg;
    data['telefone'] = this.telefone;
    data['cep'] = this.cep;
    data['numero'] = this.numero;
    data['bairro'] = this.bairro;
    data['cidade'] = this.cidade;
    data['complemento'] = this.complemento;
    data['imagem'] = this.imagem;

    return data;
  }

  @override
  String toString() =>
      "Pessoa(nome: $nome, nomeMae: $nomeMae, cpf: $cpf, nomePai: $nomePai, dtNasc: $dataNascimento, endereco: $endereco, idade: $idade, rg: $rg, telefone: $telefone, cep: $cep, numero: $numero, bairro: $bairro, cidade: $cidade, complemento: $complemento, imagem: $imagem";

  Future<void> save() async {
    Map map = toJson();
    String json = convert.json.encode(map);
    await Prefs.setString("pessoa.prefs", json);
  }

  static Future<Pessoa?> get() async {
    String json = await Prefs.getString("pessoa.prefs");

    if (json.isEmpty) {
      return null;
    }

    Map<String, dynamic> map = convert.json.decode(json);
    Pessoa p = Pessoa.fromJson(map);
    return p;
  }
}
