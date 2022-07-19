import 'dart:async';
import 'package:device_information/device_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';
import 'package:salvemaria/app/api/acompanhamento_api.dart';
import 'package:salvemaria/app/api/denuncia_api.dart';
import 'package:salvemaria/app/models/cidade/cidade.dart';
import 'package:salvemaria/app/models/dd/dd_denuncia_page.dart';
import 'package:salvemaria/app/models/denuncia/denuncia.dart';
import 'package:geolocator/geolocator.dart';
import 'package:salvemaria/app/models/pessoa/pessoa.dart';
import 'package:salvemaria/app/pages/mais_informacoes.dart';
import 'package:salvemaria/app/pages/ocultar_app.dart';
import 'package:salvemaria/utils/grow_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart' as location_back;

class BotaoPanico extends StatefulWidget {
  final Pessoa? pessoa;

  final List<Cidade>? cidades;

  BotaoPanico(this.pessoa, this.cidades);

  @override
  _BotaoPanicoState createState() => _BotaoPanicoState();
}

class _BotaoPanicoState extends State<BotaoPanico>
    with SingleTickerProviderStateMixin {
  Position? _currentPosition;
  String _platformImei = 'Desconhecida';
  String uniqueId = "Desconhecida";
  bool _botaoPressionado = false;
  String? msgRetorno;
  bool? _erro;
  String? _error;
  List<Placemark>? _placemark;
  bool _chamadoRealizado = false;
  final location_back.Location location = location_back.Location();
  LocationData? _location;
  StreamSubscription<LocationData>? _locationSubscription;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  AnimationController? controller;
  Animation<double>? animation;
  bool localizando = false;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation =
        CurvedAnimation(parent: controller!, curve: Curves.fastOutSlowIn)
          ..addStatusListener(
            (status) {
              if (status == AnimationStatus.completed) {
                controller?.reverse();
              } else if (status == AnimationStatus.dismissed) {
                controller?.forward();
              }
            },
          );

    controller?.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    String platformImei;

    try {
      platformImei = await DeviceInformation.deviceIMEINumber;
      //     .getImei(shouldShowRequestPermissionRationale: false);
      // idunique = await ImeiPlugin.getId();
    } on PlatformException {
      platformImei = 'Falha em obter versão.';
    }

    if (!mounted) return;

    setState(() {
      _platformImei = platformImei;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      drawer: _drawer(context),
      appBar: _appBar(context),
      body: _body(context),
      bottomNavigationBar: _botaoPressionado == true && msgRetorno == null
          ? null
          : const BottomAppBar(
              color: Colors.purple,
              child: Text('USE COM RESPONSABILIDADE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25.0,
                      letterSpacing: 1,
                      height: 1.5,
                      fontFamily: 'Reem Kufi',
                      color: Colors.white))),
    );
  }

  Stack _body(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.pink[400]!,
                Colors.pink[300]!,
                Colors.pink[200]!,
              ],
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * 0.2,
            // ),
            _botaoPressionado == true && msgRetorno != null
                ? Container(
                    child: InkWell(
                        child: GrowTransition(
                          animation: animation,
                          child: Container(
                            // margin: EdgeInsets.all(10),
                            width: 210.0,
                            height: 210.0,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.pink[200]!,
                                    blurRadius: 10, // soften the shadow
                                    spreadRadius: 10.0, //extend the shadow
                                    offset: const Offset(
                                      2.0, // Move to right 10  horizontally
                                      2.0, // Move to bottom 5 Vertically
                                    ),
                                  )
                                ],
                                shape: BoxShape.circle,
                                image: const DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  image: AssetImage(
                                    "images/botaoDoPanico.png",
                                  ),
                                )),
                          ),
                        ),
                        onLongPress: () async {
                          _acionaBotaoPanico(context);
                        }),
                  )
                : InkWell(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      width: 210.0,
                      height: 210.0,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink[400]!,
                              blurRadius: 10, // soften the shadow
                              spreadRadius: 2.0, //extend the shadow
                              offset: const Offset(
                                2.0, // Move to right 10  horizontally
                                2.0, // Move to bottom 5 Vertically
                              ),
                            )
                          ],
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                            fit: BoxFit.contain,
                            image: AssetImage("images/botaoDoPanico.png"),
                          )),
                    ),
                    onLongPress: () async {
                      _acionaBotaoPanico(context);
                    }),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.36),
            _botaoPressionado != true && msgRetorno == null
                ? const Center(
                    child: Text(
                      'SEGURE O BOTÃO PARA ENVIAR UM CHAMADO',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        fontFamily: 'Reem Kufi',
                        color: Colors.white,
                      ),
                    ),
                  )
                : Container(),

            const SizedBox(
              height: 30,
            ),
            if (_botaoPressionado && msgRetorno != null && _erro != null)
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      color: _erro == false ? Colors.green : Colors.red[500],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        _erro == false
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 35,
                              )
                            : const Icon(
                                Icons.report_problem,
                                color: Colors.white,
                                size: 35,
                              ),
                        Text(msgRetorno!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              fontFamily: 'Reem Kufi',
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                ),
              ))
            else
              Container(),
            _botaoPressionado == true && msgRetorno == null
                ? Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 70,
                              height: 70,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.purple),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: Text(
                                "ALERTANDO A POLÍCIA",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
                : Container(),
            SizedBox(
              height: 20,
            ),
            // Padding(
            //     padding: const EdgeInsets.all(20.0),
            //     child: RaisedButton(
            //       onPressed: () {
            //         Navigator.push(context, MaterialPageRoute(builder: (context) => DdDenunciaPage(widget.pessoa)));
            //       },
            //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
            //       padding: const EdgeInsets.all(0.0),
            //       child: Ink(
            //         decoration: BoxDecoration(
            //           gradient: LinearGradient(
            //             begin: Alignment.centerLeft,
            //             end: Alignment.centerRight,
            //             colors: <Color>[
            //               Colors.purple[900]!,
            //               Colors.purple[600]!,
            //             ],
            //           ),
            //           borderRadius: BorderRadius.all(Radius.circular(80.0)),
            //         ),
            //         child: Container(
            //           constraints: const BoxConstraints(minWidth: 88.0, minHeight: 56.0), // min sizes for Material buttons
            //           alignment: Alignment.center,
            //           child: const Text(
            //             'FAÇA UMA DENÚNCIA',
            //             textAlign: TextAlign.center,
            //             style: TextStyle(color: Colors.white),
            //           ),
            //         ),
            //       ),
            //     )),
          ],
        ),
      ],
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Olá, ",
            style: TextStyle(fontSize: 18),
          ),
          Flexible(
            child: Text(
              _nomeUsuario(widget.pessoa),
              overflow: TextOverflow.fade,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  String _formataTexto(String texto) {
    String comAcentos = "ÄÅÁÂÀÃäáâàãÉÊËÈéêëèÍÎÏÌíîïìÖÓÔÒÕöóôòõÜÚÛüúûùÇç";
    String semAcentos = "AAAAAAaaaaaEEEEeeeeIIIIiiiiOOOOOoooooUUUuuuuCc";

    for (int i = 0; i < comAcentos.length; i++) {
      texto =
          texto.replaceAll(comAcentos[i].toString(), semAcentos[i].toString());
    }

    texto = texto.toUpperCase();
    return texto;
  }

  _acionaBotaoPanico(context) {
    if (_chamadoRealizado == true) {
      setState(() {
        _erro = true;
        msgRetorno = "VOCÊ JÁ REALIZOU UM CHAMADO!\nPor favor, aguarde!";
      });
    } else {
      _confirmarAlerta(context);
    }
  }

  //Obtem apenas o primeiro nome do usuário
  String _nomeUsuario(Pessoa? pessoa) {
    List<String> nome = pessoa!.nome!.split(" ");
    return nome[0];
  }

  void _confirmaAcionaBotaoPanico() async {
    setState(() {
      _botaoPressionado = true;
    });

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    _geolocatorPlatform.isLocationServiceEnabled().then((value) async {
      if (value == true) {
        var teste = await _geolocatorPlatform.getCurrentPosition();
        setState(() {
          _currentPosition = teste;
        });
        await initPlatformState();
        placemarkFromCoordinates(
                _currentPosition!.latitude, _currentPosition!.longitude)
            .then((value) {
          setState(() {
            _placemark = value;
          });

          bool cidadeCoberta = false;

          for (Cidade c in widget.cidades!) {
            if (c.nome?.compareTo(
                    _placemark!.elementAt(0).subAdministrativeArea!.trim()) ==
                0) {
              cidadeCoberta = true;
            }
          }
          if (cidadeCoberta == false) {
            setState(() {
              _erro = true;
              msgRetorno =
                  "ERRO AO FAZER CHAMADO\n Você não está na área de cobertura!\nProcure uma unidade de polícia mais próxima!";
            });

            return;
          }

          Denuncia d = new Denuncia();
          d.tipo = "PANICO";
          d.latitude = _currentPosition?.latitude.toString();
          d.longitude = _currentPosition?.longitude.toString();
          d.estado = _placemark?.elementAt(0).administrativeArea;
          d.so = "Android";
          d.cep = _placemark?.elementAt(0).postalCode;
          d.complemento = "";

          d.bairro = _formataTexto(_placemark!.elementAt(0).subLocality!);
          d.cidade = _placemark?.elementAt(0).subAdministrativeArea;

          d.numero = _placemark?.elementAt(0).subThoroughfare;
          d.imei = _platformImei;
          d.endereco = _placemark?.elementAt(0).thoroughfare;

          DenunciaApi.enviarDenuncia(d).then((value) {
            if (value == true) {
              setState(() {
                _chamadoRealizado = true;
                _erro = false;
                msgRetorno = "CHAMADO REALIZADO COM SUCESSO!";
              });

              if (_chamadoRealizado == true) {
                setState(() {
                  localizando = true;
                });
                _startLocation();
              }
              return;
            } else {
              setState(() {
                _erro = true;
                msgRetorno =
                    "ERRO AO FAZER CHAMADO\nVerifique sua conexão com a internet!";
              });
            }
          });

          // _geolocatorPlatform.getCurrentPosition().then((Position position) async {

          //   setState(() {
          //     _currentPosition = position;
          //   });
          //   await initPlatformState();

          //   }).catchError((e) {
          //     setState(() {
          //       _erro = true;
          //       msgRetorno = "ERRO AO FAZER CHAMADO\nNão foi possível obter sua localização!";
          //     });
          //   });
        }
                // ).catchError((e) {
                //   _erro = true;
                //   msgRetorno = "ERRO AO FAZER CHAMADO\nNão foi possível obter sua localização!";
                // });
                // }
                ).catchError((e) {
          setState(() {
            _erro = true;
            msgRetorno =
                "ERRO AO FAZER CHAMADO\nNão foi possível obter sua localização!";
          });
        });
      } else {
        setState(() {
          _erro = true;
          msgRetorno =
              "ERRO AO FAZER CHAMADO\nNão foi possível obter sua localização!";
        });
      }
    });
  }

  Future<void> _startLocation() async {
    location.onLocationChanged.handleError((dynamic err) {
      setState(() {
        _error = err.code;
      });
      _locationSubscription?.cancel();
      location.enableBackgroundMode(enable: true);
    }).listen((LocationData currentLocation) {
      location.enableBackgroundMode(enable: true);

      location.changeNotificationOptions(
        color: Colors.pink,
        description: "Dispositivo sendo monitorado",
        title: 'Salve Maria',
        iconName: 'Salve Maria',
        channelName: 'Salve Maria',
        onTapBringToFront: true,
      );
      setState(() {
        _error = null;
        _location = currentLocation;

        AcompanhamentoApi.enviarLocalizacao(
            _location!.latitude.toString(), _location!.longitude.toString());
      });
    });
  }

  // Future<void> _stopListen() async {
  //   setState(() {
  //     location.enableBackgroundMode(enable: false);
  //     _location = null;
  //     _locationSubscription?.cancel();
  //   });
  // }

  _confirmarAlerta(BuildContext context) {
    Widget cancelaButton = TextButton(
      child: Text(
        "NÃO",
        style: TextStyle(color: Colors.pink, fontSize: 20),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continuaButton = TextButton(
      child: Text(
        "SIM",
        style: TextStyle(color: Colors.pink, fontSize: 20),
      ),
      onPressed: () {
        Navigator.pop(context);
        _confirmaAcionaBotaoPanico();
      },
    );

    AlertDialog alert = AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Alertando Polícia",
              style: TextStyle(color: Colors.purple, fontSize: 18),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "DESEJA REALMENTE ACIONAR A POLÍCIA?",
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.pink),
              ),
            ),
            Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              cancelaButton,
              Text(
                "|",
                style: TextStyle(color: Colors.pink, fontSize: 18),
              ),
              continuaButton,
            ])
          ],
        ));
    //exibe o diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _drawer(BuildContext context) {
    return SafeArea(
        child: Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.pink[300]!),
            accountName: Text("Salve Maria - Maranhão"),
            accountEmail: Text(""),
            currentAccountPicture: CircleAvatar(
              radius: 30.0,
              backgroundImage: AssetImage('images/iconSalveMaria.png'),
              backgroundColor: Colors.transparent,
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
          //   child: Text(
          //     "Disque denúncia",
          //     style: TextStyle(color: Colors.grey, fontSize: 16),
          //   ),
          // ),
          ListTile(
              tileColor: Colors.purple,
              leading: Icon(Icons.edit_note, size: 30, color: Colors.white),
              title: Text("Faça uma denúncia".toUpperCase(),
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DdDenunciaPage(widget.pessoa)));
              }),
          ListTile(
              leading: Icon(Icons.send),
              title: Text("Whastapp"),
              onTap: () {
                Navigator.pop(context);
                abrirWhatsApp();
              }),
          ListTile(
              leading: Icon(Icons.email),
              title: Text("Email"),
              onTap: () {
                Navigator.pop(context);
                abrirEmail();
              }),
          ListTile(
              leading: Icon(Icons.phone),
              title: Text("Ligação da capital"),
              onTap: () {
                Navigator.pop(context);
                fazerLigacao("32235800");
              }),
          ListTile(
              leading: Icon(Icons.phone),
              title: Text("Ligação do interior"),
              onTap: () {
                Navigator.pop(context);
                fazerLigacao("03003135800");
              }),
          Spacer(),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
          //   child: Text(
          //     "Mais",
          //     style: TextStyle(color: Colors.grey, fontSize: 16),
          //   ),
          // ),
          ListTile(
              leading: Icon(Icons.star),
              title: Text("Como ocultar o Salve Maria"),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OcultarAppPage()));
              }),
          ListTile(
              leading: Icon(Icons.info),
              title: Text("Sobre"),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MaisInformacoesPage()));
              }),
        ],
      ),
    ));
  }

  void abrirWhatsApp() async {
    var whatsappUrl = "whatsapp://send?phone=+559892248660&text=Olá, ";

    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  fazerLigacao(String telefone) async {
    String url = "tel:" + telefone;
    Uri _uri = Uri.parse(url);
    if (await canLaunchUrl(_uri)) {
      await launchUrl(_uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  abrirEmail() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'disquedenunciamaranhao@gmail.com',
      query: 'subject=Denunciar&body=Olá, ',
    );
    String url = params.toString();
    Uri _uri = Uri.parse(url);
    if (await canLaunchUrl(_uri)) {
      await launchUrl(_uri);
    } else {}
  }
}
