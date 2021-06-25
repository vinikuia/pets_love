import 'package:flutter/material.dart';
import 'package:pets_love/models/anotacao_model.dart';
import 'package:pets_love/screens/perfil_pet/perfil_pet_screen.dart';
import 'package:pets_love/services/anotacao_service.dart';

Widget anotacaoCard(BuildContext context, int index, Anotacao anotacao) {
  return GestureDetector(
    onTap: () {
      _exibirDialog(context, anotacao);
    },
    child: Card(
      elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Container(
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          leading: Container(
            padding: EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              border: Border(
                  right: BorderSide(width: 1.0, color: Colors.redAccent)
              ),
            ),
            child: Icon(Icons.healing, color: Colors.redAccent,),
          ),
          title: Text(
            anotacao.titulo,
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          subtitle: Text(
            anotacao.conteudo,
          ),
        ),
      ),
    ),
  );
}

void _exibirDialog(BuildContext context, Anotacao anotacao) {
  AnotacaoService anotacaoService = AnotacaoService();
  Widget cancelaButton = FlatButton(
    child: Text("Cancelar"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget removerButton = FlatButton(
    child: Text("Remover"),
    onPressed: () {
      anotacaoService.removeAnotacaoPet(anotacao.id);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => PerfilPetScreen(id: int.parse(anotacao.pet),),
        ),
      );
    },
  );
  AlertDialog alert = AlertDialog(
    title: Text("Remover anotação"),
    content: Text("Deseja remover a anotação?"),
    actions: [
      cancelaButton,
      removerButton
    ],
  );
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      }
  );
}