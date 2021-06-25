import 'package:flutter/material.dart';
import 'package:pets_love/models/consulta_model.dart';
import 'package:pets_love/models/pet_model.dart';
import 'package:pets_love/screens/components/custom_navbar.dart';
import 'package:pets_love/screens/consulta_pet/components/consulta_card.dart';
import 'package:pets_love/screens/form_cadastro_consulta/form_cadastro_consulta_screen.dart';
import 'package:pets_love/screens/form_cadastro_remedio/form_cadastro_remedio_screen.dart';
import 'package:pets_love/services/consulta_service.dart';
import 'package:pets_love/services/pet_service.dart';

class ConsultaPetScreen extends StatefulWidget {
  final int id;

  ConsultaPetScreen({this.id});

  @override
  _ConsultaPetScreenState createState() => _ConsultaPetScreenState();
}

class _ConsultaPetScreenState extends State<ConsultaPetScreen> {
  final PetService petService = PetService();
  final ConsultaService consultaService = ConsultaService();
  Pet pet;
  List<Consulta> consultaList = [];
  Future<Pet> _loadPet;
  Future<List> _loadConsultas;

  @override
  void initState() {
    // TODO: implement initState
    _loadPet = _getPet(widget.id);
    _loadConsultas = _getConsultas(widget.id.toString());
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
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Hero(
                        tag: pet.id,
                        child: Container(
                          width: double.infinity,
                          height: 350,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(pet.imageUrl),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 40, left: 10),
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.arrow_back_ios),
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Consultas",
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 24,
                              fontWeight: FontWeight.bold
                          ),)
                      ],
                    ),
                  ),
                  FutureBuilder(
                      future: _loadConsultas,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          consultaList = snapshot.data;
                          return Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.all(10),
                              itemCount: consultaList.length,
                              itemBuilder: (context, index) {
                                return consultaCard(
                                    context, index, consultaList[index]);
                              },
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Center(
                            child: Text("Este pet não possui remédios"),
                          );
                        }
                      }
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          FormCadastroConsultaScreen(id: pet.id,),
                    ),
                  );
                },
                child: Icon(Icons.add),
                backgroundColor: Colors.redAccent,
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation
                  .centerDocked,
              bottomNavigationBar: CustomNavbar(paginaAberta: 2, pet: pet,),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
    );
  }

  Future<List> _getConsultas(String id) async {
    return await consultaService.getConsultasPet(id);
  }

  Future<Pet> _getPet(int id) async {
    return await petService.getPet(id);
  }
}
