import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salvemaria/app/pages/cadastro_vitima.dart';

class TermoUso extends StatefulWidget {
  @override
  TermoUsoState createState() => TermoUsoState();
}

class TermoUsoState extends State<TermoUso> {
  static const RosaApp = const Color(0xFFD95B96);

  bool? aceito = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink[400],
          centerTitle: true,
          elevation: 0,
          title: Text("Termo de Uso"),
        ),
        backgroundColor: Colors.white,
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
                        Colors.pink[400]!,
                        Colors.pink[300]!,
                        Colors.pink[200]!,
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
                        width: 90.0,
                        height: 90.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage("images/iconSalveMaria.png"),
                            )),
                      ),
                      Text('SALVE MARIA',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontFamily: 'Reem Kufi',
                            color: Colors.white,
                          )),
                      Text('Maranhão',
                          style: TextStyle(
                            fontSize: 20.0,
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
                          child: Text(
                              '   Declaro concordar integralmente com as regras que disciplinam o uso do aplicativo, nos termos da legislação'
                              ' pátria vigente que rege a matéria, conforme portaria SSP nº 669/2020.\n'
                              '   Declaro ainda ter conhecimento de que o uso do "Botão de Segurança" somente ocorrerá em situações de Urgência, relativos à violência contra a mulher, em que seja necessária a intervenção policial.\n'
                              '   Os responsáveis por eventuais comunicações falsas estarão sujeitos às sanções penais, cíveis e administrativas cabíveis à espécie. ',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: 'Reem Kufi',
                                color: Colors.white,
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Divider(
                          height: 5,
                          color: Colors.white,
                        ),
                      ),
                      Center(
                        child: CheckboxListTile(
                          checkColor: RosaApp,
                          activeColor: Colors.white,
                          title: Text(
                            "Li e aceito os termos de uso",
                            style: TextStyle(color: Colors.white),
                          ),
                          value: aceito,
                          onChanged: (newValue) {
                            setState(() {
                              aceito = newValue;
                            });
                          },
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: RaisedButton(
                            onPressed: aceito == true
                                ? () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CadastroVitima()));
                                  }
                                : null,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.0)),
                            padding: const EdgeInsets.all(0.0),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: aceito == true
                                      ? <Color>[
                                          Colors.purple[800]!,
                                          Colors.purple[700]!,
                                          Colors.purple[600]!,
                                          Colors.purple[500]!,
                                          Colors.purple[400]!,
                                        ]
                                      : <Color>[
                                          Colors.grey[800]!,
                                          Colors.grey[700]!,
                                          Colors.grey[600]!,
                                          Colors.grey[500]!,
                                          Colors.grey[400]!,
                                        ],
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(80.0)),
                              ),
                              child: Container(
                                constraints: const BoxConstraints(
                                    minWidth: 88.0,
                                    minHeight:
                                        56.0), // min sizes for Material buttons
                                alignment: Alignment.center,
                                child: const Text(
                                  'Avançar',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )),
                    ])
              ],
            ),
          ],
        ));
  }
}
