import 'package:flutter/material.dart';
import 'package:pets_love/models/anotacao_model.dart';
import 'package:pets_love/models/pet_model.dart';
import 'package:pets_love/screens/anotacao_pet/components/anotacao_card.dart';
import 'package:pets_love/screens/components/custom_navbar.dart';
import 'package:pets_love/screens/form_cadastro_anotacao/form_cadastro_anotacao_screen.dart';
import 'package:pets_love/services/anotacao_service.dart';
import 'package:pets_love/services/pet_service.dart';

class AnotacaoPetScreen extends StatefulWidget {
  final int id;

  AnotacaoPetScreen({this.id});

  @override
  _AnotacaoPetScreenState createState() => _AnotacaoPetScreenState();
}

class _AnotacaoPetScreenState extends State<AnotacaoPetScreen> {
  List<Anotacao> anotacaoList = List();
  final PetService petService = PetService();
  final AnotacaoService anotacaoService = AnotacaoService();
  Pet pet;
  Future<Pet> _loadPet;
  Future<List> _loadAnotacaos;

  @override
  void initState() {
    // TODO: implement initState
    _loadPet = _getPet(widget.id);
    _loadAnotacaos = _getAnotacoes(widget.id.toString());
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
                      Text("Anotações",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                        ),)
                    ],
                  ),
                ),
                FutureBuilder(
                  future: _loadAnotacaos,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      anotacaoList = snapshot.data;
                      return Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.all(10),
                          itemCount: anotacaoList.length,
                          itemBuilder: (context, index) {
                            return anotacaoCard(
                                context, index, anotacaoList[index]);
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Center(
                        child: Text("Este pet não possui anotacaos"),
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
                        FormCadastroAnotacaoScreen(id: pet.id,),
                  ),
                );
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.redAccent,
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation
                .centerDocked,
            bottomNavigationBar: CustomNavbar(paginaAberta: 3, pet: pet,),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }

  Future<List> _getAnotacoes(String id) async {
    return await anotacaoService.getAnotacoesPet(id);
  }

  Future<Pet> _getPet(int id) async {
    return await petService.getPet(id);
  }
}
