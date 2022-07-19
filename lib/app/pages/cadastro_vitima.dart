import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:salvemaria/app/api/cadastro_api.dart';
import 'package:salvemaria/app/controllers/cadastro/cadastro_controller.dart';
import 'package:salvemaria/app/models/bairro/bairro.dart';
import 'package:salvemaria/app/api/bairro/bairro_api.dart';
import 'package:salvemaria/app/models/cidade/cidade.dart';
import 'package:salvemaria/app/api/cidade/cidade_api.dart';
import 'package:salvemaria/app/models/pessoa/pessoa.dart';
import 'package:salvemaria/app/pages/botao_panico.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:salvemaria/app/pages/camera.dart';

class CadastroVitima extends StatefulWidget {
  @override
  _CadastroVitimaState createState() => _CadastroVitimaState();
}

class _CadastroVitimaState extends State<CadastroVitima> {
  final _formKey = GlobalKey<FormState>();
  final dataMask = MaskTextInputFormatter(
    mask: "##/##/####",
    filter: {"#": RegExp(r'[0-9]')},
  );

  final cpfMask = MaskTextInputFormatter(
    mask: "###.###.###-##",
    filter: {"#": RegExp(r'[0-9]')},
  );
  final cepMask = MaskTextInputFormatter(
    mask: "#####-###",
    filter: {"#": RegExp(r'[0-9]')},
  );
  final telefoneMask = MaskTextInputFormatter(
    mask: "(##) #####-####",
    filter: {"#": RegExp(r'[0-9]')},
  );
  final _dataController = TextEditingController();
  final _cpfController = TextEditingController();
  final _cepController = TextEditingController();
  final _telefoneController = TextEditingController();

  final _nomeController = TextEditingController();
  final _nomeMaeController = TextEditingController();
  final _nomePaiController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _rgController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _numeroController = TextEditingController();
  final _complementoController = TextEditingController();
  final _idadeController = TextEditingController();

  static const RosaApp = Color.fromARGB(255, 240, 98, 146);

  Cidade? _cidadeSelecionada;
  Bairro? _bairroSelecionado;
  List<Cidade>? _cidades;
  List<Bairro>? _bairros = [];
  Pessoa? pessoa;
  String? path;
  String? imageEncoded;
  bool _botaoPressionado = false;
  final ImagePicker _picker = ImagePicker();

  openCamera() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );
  }

  @override
  void dispose() {
    _dataController.dispose();
    _cpfController.dispose();
    _cepController.dispose();
    _nomeController.dispose();
    _nomeMaeController.dispose();
    _nomePaiController.dispose();
    _enderecoController.dispose();
    _rgController..dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _numeroController.dispose();
    _complementoController.dispose();
    _idadeController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    pessoa = Pessoa();
    _carregaCidades();
    super.initState();
  }

  _carregaCidades() async {
    _cidades = await CidadeApi.getCidades();
    setState(() {});
  }

  _carregaBairros(int c) async {
    _bairros = await BairroApi.getBairros(c);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.pink[400]!,
        title: Text("FAÇA SEU CADASTRO",
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'Reem Kufi',
            )),
      ),
      body: _cidades == null
          ? Container(
              decoration: BoxDecoration(
                // Box decoration takes a gradient
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.pink[400]!,
                    Colors.pink[300]!,
                    Colors.pink[200]!,
                  ],
                ),
              ),
              child: Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
              )),
            )
          : _buildForm(context),
    );
  }

  _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.person,
                      color: Colors.purple,
                    ),
                    Text(
                      "Dados Pessoais",
                      style: TextStyle(color: Colors.purple, fontSize: 20),
                    ),
                  ],
                ),
              ),
              path == null
                  ? Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Positioned(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 20.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.pink[600],
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.deepPurpleAccent)),
                                child: Icon(
                                  Icons.person_outline,
                                  color: Colors.white,
                                  size: 100,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 80,
                            left: 90,
                            child: Container(
                              padding: EdgeInsets.zero,
                              margin: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(0, 0),
                                        spreadRadius: 0,
                                        blurRadius: 1,
                                        color: Colors.black)
                                  ],
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white),
                                  color: Colors.white),
                              child: IconButton(
                                  constraints: BoxConstraints(),
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Camera()));
                                    if (result != null) {
                                      setState(() {
                                        path = result[1];
                                      });
                                      imageEncoded = base64Encode(result[0]);
                                    }
                                  },
                                  icon: Icon(Icons.camera_alt)),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Positioned(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 20.0),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: FileImage(
                                  File(path!),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 80,
                            left: 90,
                            child: Container(
                              padding: EdgeInsets.zero,
                              margin: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(0, 0),
                                        spreadRadius: 0,
                                        blurRadius: 1,
                                        color: Colors.black)
                                  ],
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white),
                                  color: Colors.white),
                              child: IconButton(
                                  constraints: BoxConstraints(),
                                  onPressed: () => setState(() {
                                        path = null;
                                        imageEncoded = null;
                                      }),
                                  icon: Icon(Icons.delete, color: Colors.red)),
                            ),
                          ),
                        ],
                      ),
                    ),
              // IconButton(onPressed: () => openCamera(), icon: Icon(Icons.camera)),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _nomeController,
                  keyboardType: TextInputType.text,
                  cursorColor: RosaApp,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: RosaApp),
                      labelText: "Nome *",
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: RosaApp)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple)),
                      hintStyle: TextStyle(color: Colors.white.withAlpha(80))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe seu nome completo';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  inputFormatters: [telefoneMask],
                  controller: _telefoneController,
                  keyboardType: TextInputType.phone,
                  cursorColor: RosaApp,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: RosaApp),
                      labelText: "Telefone *",
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: RosaApp)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple)),
                      hintStyle: TextStyle(color: Colors.white.withAlpha(80))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe seu número de telefone';
                    }

                    if (value.length != 15) {
                      return 'Número de telefone incompleto';
                    }

                    return null;
                  },
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(10.0),
              //   child: TextFormField(
              //     controller: _idadeController,
              //     keyboardType: TextInputType.numberWithOptions(signed: false),
              //     cursorColor: RosaApp,
              //     decoration: InputDecoration(
              //         labelStyle: TextStyle(color: RosaApp),
              //         labelText: "Idade *",
              //         fillColor: Colors.white,
              //         filled: true,
              //         focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: RosaApp)),
              //         border: OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
              //         hintStyle: TextStyle(color: Colors.white.withAlpha(80))),
              //     validator: (value) {
              //       if (value!.isEmpty) {
              //         return 'Informe sua idade';
              //       }
              //       return null;
              //     },
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _nomeMaeController,
                  keyboardType: TextInputType.text,
                  cursorColor: RosaApp,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: RosaApp),
                      labelText: "Nome da mãe *",
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: RosaApp)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple)),
                      hintStyle: TextStyle(color: Colors.white.withAlpha(80))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe o nome de sua mãe';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _nomePaiController,
                  keyboardType: TextInputType.text,
                  cursorColor: RosaApp,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: RosaApp),
                      labelText: "Nome do pai",
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: RosaApp)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple)),
                      hintStyle: TextStyle(color: Colors.white.withAlpha(80))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  inputFormatters: [dataMask],
                  controller: _dataController,
                  cursorColor: RosaApp,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: RosaApp),
                      labelText: "Data de Nascimento *",
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: RosaApp)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple)),
                      hintStyle: TextStyle(color: Colors.white.withAlpha(80))),
                  validator: (value) {
                    if (value!.isEmpty || value.length != 10) {
                      return 'Informe sua data de nascimento';
                    }

                    if (value.length != 10 || !_verData(value)) {
                      return 'Data de nascimento inválida!';
                    }

                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.perm_contact_calendar,
                      color: Colors.purple,
                    ),
                    Text(
                      " Documentos",
                      style: TextStyle(color: Colors.purple, fontSize: 20),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _rgController,
                  keyboardType: TextInputType.numberWithOptions(signed: false),
                  cursorColor: RosaApp,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: RosaApp),
                      labelText: "RG *",
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: RosaApp)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple)),
                      hintStyle: TextStyle(color: Colors.white.withAlpha(80))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe o número do seu RG';
                    }

                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  inputFormatters: [cpfMask],
                  controller: _cpfController,
                  keyboardType: TextInputType.numberWithOptions(signed: false),
                  cursorColor: RosaApp,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: RosaApp),
                      labelText: "CPF *",
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: RosaApp)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple)),
                      hintStyle: TextStyle(color: Colors.white.withAlpha(80))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe seu CPF';
                    }
                    if (!CPFValidator.isValid(value)) {
                      return 'CPF inválido';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.home,
                      color: Colors.purple,
                    ),
                    Text(
                      "Endereço",
                      style: TextStyle(color: Colors.purple, fontSize: 20),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: Colors.grey),
                    color: Colors.white),
                padding: const EdgeInsets.all(10.0),
                child: DropdownButton<Cidade>(
                  isDense: true,
                  elevation: 5,
                  isExpanded: true,
                  iconSize: 30,
                  style: TextStyle(fontSize: 15, color: RosaApp),
                  hint: Text("Cidade *",
                      style: TextStyle(fontSize: 15, color: RosaApp)),
                  items: _cidades?.map((Cidade cidade) {
                    return DropdownMenuItem<Cidade>(
                      value: cidade,
                      child: Text(cidade.nome!),
                    );
                  }).toList(),
                  onChanged: (Cidade? c) {
                    _setCidadeSelecionada(c!);
                  },
                  value: _cidadeSelecionada,
                ),
              ),
              _cidadeSelecionada == null && _botaoPressionado
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Informe sua cidade",
                        style: TextStyle(fontSize: 12, color: Colors.red[800]),
                      ),
                    )
                  : Container(),
              Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: Colors.grey),
                    color: Colors.white),
                padding: const EdgeInsets.all(10.0),
                child: DropdownButton<Bairro>(
                  isDense: true,
                  elevation: 5,
                  isExpanded: true,
                  iconSize: 30,
                  style: TextStyle(fontSize: 15, color: RosaApp),
                  hint: Text("Bairro *",
                      style: TextStyle(fontSize: 15, color: RosaApp)),
                  items: _bairros?.map((Bairro bairro) {
                    return DropdownMenuItem<Bairro>(
                      value: bairro,
                      child: Text(bairro.nome!.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (Bairro? b) {
                    _setBairroSelecionado(b!);
                  },
                  value: _bairroSelecionado,
                ),
              ),
              _bairroSelecionado == null && _botaoPressionado
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Informe o bairro onde mora",
                        style: TextStyle(fontSize: 12, color: Colors.red[800]),
                      ),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _enderecoController,
                  keyboardType: TextInputType.text,
                  cursorColor: RosaApp,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: RosaApp),
                      labelText: "Logradouro *",
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: RosaApp)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple)),
                      hintStyle: TextStyle(color: Colors.white.withAlpha(80))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe o logradouro';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _numeroController,
                  keyboardType: TextInputType.number,
                  cursorColor: RosaApp,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: RosaApp),
                      labelText: "Número *",
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: RosaApp)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple)),
                      hintStyle: TextStyle(color: Colors.white.withAlpha(80))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe o número de sua casa';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _complementoController,
                  keyboardType: TextInputType.text,
                  cursorColor: RosaApp,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: RosaApp),
                      labelText: "Complemento *",
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: RosaApp)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple)),
                      hintStyle: TextStyle(color: Colors.white.withAlpha(80))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe o complemento do endereço';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  inputFormatters: [cepMask],
                  controller: _cepController,
                  keyboardType: TextInputType.numberWithOptions(signed: false),
                  cursorColor: RosaApp,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: RosaApp),
                      labelText: "CEP",
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: RosaApp)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple)),
                      hintStyle: TextStyle(color: Colors.white.withAlpha(80))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.purple),
                      padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0))),
                    ),
                    onPressed: () async => await _botaoCadastrarPessoa(context),
                    child: Text('CADASTRAR',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontFamily: 'Reem Kufi')),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _botaoCadastrarPessoa(BuildContext context) async {
    setState(() {
      _botaoPressionado = true;
    });

    if (imageEncoded == null) {
      final snackBar = SnackBar(
        backgroundColor: Colors.pink,
        content: Text('A foto é obrigatória!'),
      );
      setState(() {
        _botaoPressionado = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      if (_formKey.currentState!.validate() &&
          _bairroSelecionado != null &&
          _cidadeSelecionada != null) {
        EasyLoading.show(status: 'Cadastrando...');
        Pessoa p = Pessoa();
        p.nome = _nomeController.text;
        p.nomeMae = _nomeMaeController.text;
        p.nomePai = _nomePaiController.text;
        p.idade = _idadeController.text;
        p.cpf = _cpfController.text;
        p.dataNascimento = _dataController.text;
        p.rg = _rgController.text;
        p.cidade = _cidadeSelecionada?.nome;
        p.bairro = _bairroSelecionado?.nome;
        p.cep = _cepController.text;
        p.endereco = _enderecoController.text;
        p.complemento = _complementoController.text;
        p.numero = _numeroController.text;
        p.telefone = _telefoneController.text;
        p.imagem = imageEncoded ?? '';

        await CadastroApi.cadastroPessoa(p);
        await EasyLoading.dismiss();

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => BotaoPanico(p, this._cidades)));
      }
    }
  }

  void _setCidadeSelecionada(Cidade c) {
    setState(() {
      this._cidadeSelecionada = c;

      _carregaBairros(c.id!);
    });
  }

  void _setBairroSelecionado(Bairro b) {
    setState(() {
      this._bairroSelecionado = b;
    });
  }

  bool _verData(String value) {
    int dia = int.parse(value.substring(0, 2));
    int mes = int.parse(value.substring(3, 5));
    int ano = int.parse(value.substring(6, 10));

    if (ano < 1900 || ano > DateTime.now().year || mes < 1 || mes > 12) {
      return false;
    }

    if (mes == 2) {
      if (dia < 1 || dia > 30) return false;
    }

    if (dia < 1 || dia > 30) {
      return false;
    }
    return true;
  }
}
