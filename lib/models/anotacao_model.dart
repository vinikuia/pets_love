import 'dart:math';

class Anotacao {
  String pet, id;
  String titulo, conteudo;

  Anotacao({this.id, this.pet, this.titulo, this.conteudo});
  Random random = new Random();


  Map<String, dynamic> toJson() {
    return {
      'id': random.nextInt(1000).toString(),
      'pet': pet,
      'titulo': titulo,
      'conteudo': conteudo
    };
  }

  Anotacao.fromJson(dynamic map) {
    id = map["id"];
    titulo = map["titulo"];
    pet = map["pet"];
    conteudo = map["conteudo"];
  }
}