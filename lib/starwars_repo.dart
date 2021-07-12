import 'dart:convert';
import 'package:dio/dio.dart';

class StarWarsRepo {
  Future<void> fetchCharacter() async {
    var dio = Dio();
    final response = await dio.get("https://swapi.dev/api/people");
    List<StarWarsCharacter> fetchCharacter =
        StarWarsCharacter.parseList(jsonDecode(response.data));
  }
}

class StarWarsCharacter {
  final String name;
  final String birthYear;
  final String gender;
  final String url;
  String id;
  String imageUrl;

  StarWarsCharacter(this.name, this.birthYear, this.gender, this.url) {
    this.id = this.url.split("/")[5];
    this.imageUrl = "https://starwars-visualguide.com/assets/img/characters/" +
        this.id +
        ".jpg";
  }

  factory StarWarsCharacter.fromJson(Map<String, dynamic> json) {
    return StarWarsCharacter(
        json["name"], json["birth_year"], json["gender"], json["url"]);
  }
  static List<StarWarsCharacter> parseList(List<dynamic> list) {
    return list.map((i) => StarWarsCharacter.fromJson(i)).toList();
  }
}
