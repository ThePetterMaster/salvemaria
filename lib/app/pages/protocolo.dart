import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salvemaria/app/models/dd/dd_protocolo.dart';
import 'package:salvemaria/app/models/pessoa/pessoa.dart';

class Protocolo extends StatefulWidget {
  final DdProtocolo? protocolo;

  final Pessoa pessoa;

  Protocolo(this.protocolo, this.pessoa);

  @override
  ProtocoloState createState() => ProtocoloState();
}

class ProtocoloState extends State<Protocolo> {
  static const RosaApp = const Color(0xFFD95B96);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink[700],
          centerTitle: true,
          elevation: 0,
          title: Text("DENÚNCIA"),
        ),
        backgroundColor: Colors.white,
        bottomNavigationBar: Container(
          color: widget.protocolo != null ? Colors.green : Colors.red,
          height: 40,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Text(
                widget.protocolo != null
                    ? 'DENÚNCIA ENVIADA COM SUCESSO'
                    : 'FALHA NO ENVIO DA DENÚNCIA',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontFamily: 'Reem Kufi')),
          ),
        ),
        body: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Stack(
              alignment: Alignment.topCenter,
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
                        Colors.pink[600]!,
                        Colors.pink[500]!,
                        Colors.pink[400]!,
                        Colors.pink[300]!,
                      ],
                    ),
                  ),
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(10),
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage("images/iconSalveMaria.png"),
                            )),
                      ),
                      Text('SALVE MARIA',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontFamily: 'Reem Kufi',
                            color: Colors.white,
                          )),
                      Text('Maranhão',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontFamily: 'Reem Kufi',
                            color: Colors.white,
                          )),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Divider(
                          height: 5,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: widget.protocolo == null
                              ? Column(
                                  children: <Widget>[
                                    Text(
                                        "   Ocorreu um problema inesperado ao enviar sua denúncia!\n   Por favor, verfique sua conexão de internet, e tente novamente! ",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontFamily: 'Reem Kufi',
                                          color: Colors.white,
                                        )),
                                  ],
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 200,
                                    width: 200,
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text("PROTOCOLO",
                                            style: TextStyle(
                                              fontSize: 29.0,
                                              fontFamily: 'Reem Kufi',
                                              color: Colors.pink,
                                            )),
                                        Text(
                                          widget.protocolo!.protocolo!,
                                          style: TextStyle(
                                              fontSize: 25, color: Colors.pink),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Divider(
                          height: 5,
                          color: Colors.white,
                        ),
                      ),
                      widget.protocolo != null
                          ? Column(
                              children: <Widget>[
                                Text(
                                    "Anote o número do protocolo para futuras consultas!",
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontFamily: 'Reem Kufi',
                                      color: Colors.white,
                                    )),
                              ],
                            )
                          : Container()
                    ])
              ],
            ),
          ],
        ));
  }
}
