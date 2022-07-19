import 'package:flutter/material.dart';
import 'package:salvemaria/app/models/cidade/cidade.dart';
import 'package:salvemaria/app/api/cidade/cidade_api.dart';
import 'package:salvemaria/app/models/pessoa/pessoa.dart';
import 'package:salvemaria/app/pages/botao_panico.dart';
import 'dart:async';
import 'package:salvemaria/app/pages/termo_uso.dart';

class SplashPage extends StatefulWidget {
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  static const RosaApp = const Color(0xFFD95B96);

  DateTime? _anoAtual;
  Pessoa? _pessoa;
  List<Cidade>? _cidades;

  @override
  void initState() {
    _anoAtual = DateTime.now();
    super.initState();
    // _pessoa = null;

    _carregaInformacoes();
  }

  Future<Null> _carregaCidades() async {
    _cidades = await CidadeApi.getCidades();
    setState(() {});
  }

  _carregaInformacoes() {
    Future futureTimer = Future.delayed(const Duration(seconds: 3));

    Future.wait([_carregaCidades(), futureTimer, _temCadastro()]).then((_) {
      if (_pessoa == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => TermoUso()));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => BotaoPanico(_pessoa, _cidades)));
      }
    });
  }

  Future<Null> _temCadastro() async {
    _pessoa = await Pessoa.get();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                // Box decoration takes a gradient
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    // Colors.pink[600]!,
                    // Colors.pink[500]!,
                    // Colors.pink[400]!,
                    // Colors.pink[300]!,
                    Colors.pink[400]!,
                    Colors.pink[300]!,
                    Colors.pink[200]!,
                  ],
                ),
              ),
            ),
            Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10),
                      width: 150.0,
                      height: 150.0,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            image: AssetImage("images/iconSalveMaria.png"),
                          )),
                    ),
                    const Center(
                        child: Text('SALVE MARIA',
                            style: TextStyle(
                              fontSize: 40.0,
                              fontFamily: 'Reem Kufi',
                              color: Colors.white,
                            ))),
                    const Center(
                        child: Text('Maranhão',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'Reem Kufi',
                              color: Colors.white,
                            ))),
                    const SizedBox(
                      height: 25.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          "Secretariaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa da Segurança Pública do Estado do Maranhão",
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                        const Text(
                          "Supervisão de Informática",
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                        Text(
                          "2020 - ${_anoAtual?.year}",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 10),
                        )
                      ],
                    )
                  ]),
            )
          ],
        )));
  }
}
