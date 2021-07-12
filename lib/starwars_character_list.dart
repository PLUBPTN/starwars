import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:starwars/starwars_repo.dart';

class StarWarsCharacterList extends StatefulWidget {
  StarWarsCharacterList() : super();

  @override
  _StarWarsCharacterListState createState() => _StarWarsCharacterListState();
}

class _StarWarsCharacterListState extends State {
  bool _hasMore;
  int _pageNumber;
  bool _error;
  bool _loading;
  final int _defaultcharactersPerPageCount = 10;
  List<StarWarsCharacter> _characters;
  final int _nextPageThreshold = 5;
  StarWarsRepo repo;

  @override
  void initState() {
    super.initState();
    _hasMore = true;
    _pageNumber = 1;
    _error = false;
    _loading = true;
    _characters = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Star Wars Characters"),
        ),
        body: getBody());
  }

  Widget getBody() {
    if (_characters.isEmpty) {
      if (_loading) {
        return Center(
            child: Padding(
          padding: const EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ));
      } else if (_error) {
        return Center(
            child: InkWell(
          onTap: () {
            setState(() {
              _loading = true;
              _error = false;
              repo.fetchCharacter();
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text("Error while loading characters, tap to try agin"),
          ),
        ));
      }
    } else {
      return ListView.builder(
          itemCount: _characters.length + (_hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _characters.length - _nextPageThreshold) {
              repo.fetchCharacter();
            }
            if (index == _characters.length) {
              if (_error) {
                return Center(
                    child: InkWell(
                  onTap: () {
                    setState(() {
                      _loading = true;
                      _error = false;
                      repo.fetchCharacter();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child:
                        Text("Error while loading characters, tap to try agin"),
                  ),
                ));
              } else {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircularProgressIndicator(),
                ));
              }
            }
            final StarWarsCharacter character = _characters[index];
            return Card(
              child: Column(
                children: <Widget>[
                  Image.network(
                    character.imageUrl,
                    fit: BoxFit.fitWidth,
                    width: double.infinity,
                    height: 160,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(character.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ],
              ),
            );
          });
    }
    return Container();
  }
}
