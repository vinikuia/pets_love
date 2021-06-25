import 'package:flutter/material.dart';
import 'package:pets_love/models/consulta_model.dart';
import 'package:pets_love/models/remedio_model.dart';
import 'package:pets_love/screens/perfil_pet/perfil_pet_screen.dart';
import 'package:pets_love/services/consulta_service.dart';

Widget consultaCard(BuildContext context, int index, Consulta consulta) {
  return GestureDetector(
    onTap: () {
      _exibirDialog(context, consulta);
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
          child: Icon(Icons.pets, color: Colors.redAccent,),
        ),
        title: Text(
          consulta.titulo,
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        subtitle: Text(
          consulta.data,
        ),
      ),
    ),
  )
  );
}

void _exibirDialog(BuildContext context, Consulta consulta) {
  ConsultaService consultaService = ConsultaService();
  Widget cancelaButton = FlatButton(
    child: Text("Cancelar"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );
  Widget removerButton = FlatButton(
    child: Text("Remover"),
    onPressed:  () {
      consultaService.removeConsultaPet(consulta.id);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              PerfilPetScreen(id: int.parse(consulta.pet),),
        ),
      );
    },
  );
  AlertDialog alert = AlertDialog(
    title: Text("Remover consulta"),
    content: Text("Deseja remover a consulta?"),
    actions: [
      cancelaButton,
      removerButton,
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}