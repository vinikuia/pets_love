import 'dart:math';

class Consulta {
  String pet, id, titulo, data;

  Consulta({this.id, this.pet, this.titulo, this.data});
  Random random = new Random();

  Map<String, dynamic> toJson() {
    return {
      'id': random.nextInt(1000).toString(),
      'pet': pet,
      'titulo': titulo,
      'data': data
    };
  }

  Consulta.fromJson(dynamic map) {
    id = map["id"];
    titulo = map["titulo"];
    pet = map["pet"];
    data = map["data"];
  }

}