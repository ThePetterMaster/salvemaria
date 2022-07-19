import 'package:flutter/material.dart';

class MaisInformacoesPage extends StatelessWidget {
static const RosaApp = const Color(0xFFD95B96);
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      appBar: AppBar(
        centerTitle: true,
        title: Text("Instruções de Uso"),
        backgroundColor: Color(0xFFD95B96),
      ),
      backgroundColor: Colors.white,

  
      body: SingleChildScrollView(

        child: Padding(padding: EdgeInsets.all(10),

        child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[


            Text("1. Sobre o Aplicativo", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

            Text("  Este aplicativo foi desenvolvido pela Supervisão de Informática, da Secretaria da Segurança Pública do Estado do Maranhão, "
                  "em parceria com a SSP/PI e ATI/Piauí, com o objetivo de oferecer mais um canal  de denúncias de violências praticadas contra a mulher, em"
                " situações de urgência e emergência, e para denúncias de violência contra a mulher."
                  , textAlign: TextAlign.justify, style: TextStyle(fontSize: 18),),



            SizedBox(height: 12,),


            Text("2. Área de abrangência", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

            Text(" 2.1 - Botão de Emergência: Disponível para chamados de urgência de violências contra mulheres, praticadas nos municípios de São Luís, Raposa, São José de Ribamar e "
                "Paço do Lumiar.", textAlign: TextAlign.justify, style: TextStyle(fontSize: 18),),
            Text(" 2.2 - Denúncia: Disponível para denúncias de violências contra mulheres praticadas em todo o território maranhense.", textAlign: TextAlign.justify, style: TextStyle(fontSize: 18),),



            SizedBox(height: 12,),

            Text("3. Funcionamento", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

            Text(" 3.1 - Botão de Emergência: Ao acionar o botão de emergência, o aplicativo Salve Maria irá capturar sua localização, e seus dados pessoais, e abrirá um chamado para as forças de segurança, que farão o atendimento no local indicado.", textAlign: TextAlign.justify, style: TextStyle(fontSize: 18),),
            Text(" 3.2 - Denúnica: Ao acionar o botão de denúncia, você abrirá um chamado ao disque denúncia que irá direcionar sua denúncia a uma das unidades de proteção à mulher.", textAlign: TextAlign.justify, style: TextStyle(fontSize: 18),),


              ]
          ),


        ),



      ),
    );
  }
}