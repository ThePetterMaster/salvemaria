import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salvemaria/app/models/dd/dd_api.dart';
import 'package:salvemaria/app/models/dd/dd_assuntos.dart';
import 'package:salvemaria/app/models/dd/dd_cidades.dart';
import 'package:salvemaria/app/models/dd/dd_denuncia.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:salvemaria/app/models/pessoa/pessoa.dart';

import 'package:salvemaria/app/pages/protocolo.dart';

class DdDenunciaPage extends StatefulWidget {
  final Pessoa? pessoa;

  DdDenunciaPage(this.pessoa);

  @override
  _DdDenunciaPageState createState() => _DdDenunciaPageState();
}

class _DdDenunciaPageState extends State<DdDenunciaPage> {
  final _formKey = GlobalKey<FormState>();

  // final _foneMask = MaskTextInputFormatter(
  //   mask: "(##) #####-####",
  //   filter: {"#": RegExp(r'[0-9]')},
  // );

  bool anonima = false;
  final _foneController = new TextEditingController();
  final _nomeDenuncianteController = new TextEditingController();
  final _emailController = new TextEditingController();
  final _complementoController = new TextEditingController();
  final _ruaController = new TextEditingController();
  final _bairroController = new TextEditingController();
  final _cidadeController = new TextEditingController();
  final _descricaoController = new TextEditingController();
  final _referenciaController = new TextEditingController();
  final _relatoController = new TextEditingController();
  final _numeroController = new TextEditingController();

  static const RosaApp = Color.fromARGB(255, 240, 98, 146);

  DdCidades? _cidadeSelecionada;

  List<DdCidades>? _cidades;
  List<DdAssuntos>? _assuntos;

  bool _botaoPressionado = false;

  @override
  void dispose() {
    _nomeDenuncianteController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _complementoController.dispose();
    _descricaoController.dispose();
    _emailController.dispose();
    _foneController.dispose();
    _numeroController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _carregaCidades();
    _carregaAssuntos();
    super.initState();
  }

  _carregaCidades() async {
    _cidades = await DisqueDenunciaApi.listarCidades();
    setState(() {});
  }

  _carregaAssuntos() async {
    _assuntos = await DisqueDenunciaApi.listarAssuntos();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _cidades == null || _assuntos == null
        ? Scaffold(
            body: Container(
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
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.purple),
              )),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.pink[400]!,
              title: Text("DENÚNCIA",
                  style: TextStyle(
                    fontFamily: 'Reem Kufi',
                  )),
            ),
            bottomNavigationBar: Container(
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                color: Colors.purple,
                padding: EdgeInsets.all(20),
                onPressed: () {
                  _botaoCadastrarPessoa(context);
                },
                child: Text('REALIZAR DENÚNCIA',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontFamily: 'Reem Kufi')),
              ),
            ),
            body: _buildForm(context),
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
                      Icons.edit,
                      color: Colors.purple,
                    ),
                    Text(
                      "Sobre o Fato",
                      style: TextStyle(color: Colors.purple, fontSize: 20),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  minLines: 3,
                  maxLines: 5,
                  controller: _relatoController,
                  keyboardType: TextInputType.text,
                  cursorColor: RosaApp,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: RosaApp),
                      labelText: "Conte o que ocorreu, pessoas envolvidas...*",
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: RosaApp)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple)),
                      hintStyle: TextStyle(color: Colors.white.withAlpha(80))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe o que ocorreu, pessoas envolvidas...';
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
                      Icons.person,
                      color: Colors.purple,
                    ),
                    Text(
                      "Sobre você",
                      style: TextStyle(color: Colors.purple, fontSize: 20),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _nomeDenuncianteController,
                  keyboardType: TextInputType.text,
                  cursorColor: RosaApp,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: RosaApp),
                      labelText: "Nome",
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
                  controller: _foneController,
                  keyboardType: TextInputType.text,
                  cursorColor: RosaApp,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: RosaApp),
                      labelText: "Telefone",
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
                  controller: _emailController,
                  keyboardType: TextInputType.text,
                  cursorColor: RosaApp,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: RosaApp),
                      labelText: "Email",
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      color: Colors.purple,
                    ),
                    Text(
                      "Sobre o Local do Fato",
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
                child: DropdownButton<DdCidades>(
                  isDense: true,
                  elevation: 5,
                  isExpanded: true,
                  iconSize: 30,
                  style: TextStyle(fontSize: 15, color: RosaApp),
                  hint: Text("Cidade *",
                      style: TextStyle(fontSize: 15, color: RosaApp)),
                  items: _cidades?.map((DdCidades cidade) {
                    return new DropdownMenuItem<DdCidades>(
                      value: cidade,
                      child: Text(cidade.nome!),
                    );
                  }).toList(),
                  onChanged: (DdCidades? c) {
                    _setCidadeSelecionada(c!);
                  },
                  value: _cidadeSelecionada,
                ),
              ),
              _cidadeSelecionada == null && _botaoPressionado
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Informe a cidade",
                        style: TextStyle(fontSize: 12, color: Colors.red[800]),
                      ),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _bairroController,
                  keyboardType: TextInputType.text,
                  cursorColor: RosaApp,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: RosaApp),
                      labelText: "Bairro",
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
                  controller: _complementoController,
                  keyboardType: TextInputType.text,
                  cursorColor: RosaApp,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: RosaApp),
                      labelText: "Complemento",
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
                  controller: _numeroController,
                  keyboardType: TextInputType.text,
                  cursorColor: RosaApp,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: RosaApp),
                      labelText: "Número",
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
                  controller: _referenciaController,
                  keyboardType: TextInputType.text,
                  cursorColor: RosaApp,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: RosaApp),
                      labelText: "Ponto de Referência",
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
                  controller: _ruaController,
                  cursorColor: RosaApp,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: RosaApp),
                      labelText: "Rua",
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: RosaApp)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple)),
                      hintStyle: TextStyle(color: Colors.white.withAlpha(80))),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _botaoCadastrarPessoa(BuildContext context) {
    setState(() {
      _botaoPressionado = true;
    });

    if (_formKey.currentState!.validate() && _cidadeSelecionada != null) {
      DdDenuncia d = new DdDenuncia();

      EasyLoading.show(status: 'Enviando denúncia...');

      if (_nomeDenuncianteController.text.isEmpty) {
        d.nomeDenunciante = "Anônima";
      } else {
        d.nomeDenunciante = _nomeDenuncianteController.text;
      }

      d.rua = _ruaController.text;
      d.relato = _relatoController.text;
      d.posicao = "";
      d.referencia = _referenciaController.text;
      d.macAdress = "";
      d.complemento = _complementoController.text;
      d.localizacaoCelula = "";
      d.descricao = _descricaoController.text;
      d.complemento = _complementoController.text;
      d.bairro = _bairroController.text;
      d.assunto = "VIOLÊNCIA CONTRA MULHER";
      d.cidade = _cidadeSelecionada?.nome ?? "";
      d.emailDenunciante = _emailController.text;
      d.fone = _foneController.text;
      d.modeloCelular = "";
      d.ip = "";
      d.numero = _numeroController.text;
      d.imei = "";

      DisqueDenunciaApi.enviarDisqueDenuncia(d).then((protocolo) {
        EasyLoading.dismiss();

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Protocolo(protocolo!, widget.pessoa!)));
      });
    }
  }

  void _setCidadeSelecionada(DdCidades c) {
    setState(() {
      this._cidadeSelecionada = c;
    });
  }
}
