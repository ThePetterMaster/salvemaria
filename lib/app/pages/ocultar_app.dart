import 'package:flutter/material.dart';

class OcultarAppPage extends StatelessWidget {
  static const RosaApp = const Color(0xFFD95B96);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Oculte seu aplicativo"),
        backgroundColor: Colors.pink[400]!,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            Text(
              "Observação: ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "    Para utilizar o Salve Maria - Maranhão, realize o mesmo processo, retirando-o da lista de aplicativos ocultos.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 18),
              ),
            ),
            Divider(),
            Text(
              "Passo 1:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "   Acesse o menu aplicativos do celular e toque no ícone de três pontos localizado no canto superior direito.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 18),
            ),
            Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  _alertDialogImage(context, 'images/passo_1.jpeg');
                },
                child: Container(height: 200, child: Image(image: AssetImage('images/passo_1.jpeg'))),
              ),
            )),
            Text(
              "Passo 2:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "   Toque em '\Configurações da tela inicial\'.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 18),
            ),
            Center(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      _alertDialogImage(context, 'images/passo_2.jpeg');
                    },
                    child: Container(
                      height: 200,
                      child: Image(image: AssetImage('images/passo_2.jpeg')),
                    ),
                  )),
            ),
            Text(
              "Passo 3: ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "   Arraste a tela para baixo até que a opção 'Ocultar aplicativos' apareça. Em seguida, toque nela.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 18),
            ),
            Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  _alertDialogImage(context, 'images/passo_3.jpeg');
                },
                child: Container(height: 200, child: Image(image: AssetImage('images/passo_3.jpeg'))),
              ),
            )),
            Text(
              "Passo 4: ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "    Escolha cada um dos aplicativos que você deseja ocultar e toque em 'OK'. Pronto.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 18),
            ),
            Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  _alertDialogImage(context, 'images/passo_4.jpeg');
                },
                child: Container(height: 200, child: Image(image: AssetImage('images/passo_4.jpeg'))),
              ),
            )),
          ]),
        ),
      ),
    );
  }

  void _alertDialogImage(context, String s) {
    Widget dispararButton = FlatButton(
      child: Text(
        "Fechar",
        style: TextStyle(color: Colors.pink),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // configura o  AlertDialog
    AlertDialog alert = AlertDialog(
      content: Image(image: AssetImage(s)),
      actions: [
        dispararButton,
      ],
    );
    // exibe o dialogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
