import 'package:flutter/material.dart';
import 'package:pets_love/models/consulta_model.dart';
import 'package:pets_love/models/pet_model.dart';
import 'package:pets_love/screens/consulta_pet/consulta_pet_screen.dart';
import 'package:pets_love/services/consulta_service.dart';
import 'package:pets_love/services/pet_service.dart';

class FormCadastroConsultaScreen extends StatefulWidget {
  int id;

  FormCadastroConsultaScreen({this.id});

  @override
  _FormCadastroConsultaScreenState createState() => _FormCadastroConsultaScreenState();
}

class _FormCadastroConsultaScreenState extends State<FormCadastroConsultaScreen> {
  final _tituloController = TextEditingController();
  final _dataController = TextEditingController();
  final PetService petService = PetService();
  final ConsultaService cs = ConsultaService();
  Pet pet;
  Future<Pet> _loadPet;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    _loadPet = _getPet(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadPet,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          pet = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text('Cadastro de consulta'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _tituloController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: "Título"),
                      ),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _dataController,
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                                labelText: selectedDate.toString()),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: Container(
                          height: 40,
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: () {
                              Consulta novaConsulta = Consulta(
                                titulo: _tituloController.text,
                                data: selectedDate.toString(),
                                pet: pet.id.toString()
                              );
                              cs.addConsulta(novaConsulta);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ConsultaPetScreen(id: widget.id,),
                                ),
                              );

                            },
                            color: Colors.redAccent,
                            child: Text(
                              "Cadastrar",
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },

    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime dataSelecionada = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2019, 1),
        lastDate: DateTime(2030));
    if (dataSelecionada != null && dataSelecionada != selectedDate) {
      setState(() {
        selectedDate = dataSelecionada;
      });
    }
  }

  Future<Pet> _getPet(int id) async {
    return await petService.getPet(id);
  }
}
