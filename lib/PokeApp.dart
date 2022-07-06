import 'package:flutter/material.dart';
import 'dart:convert';
import 'pokemon.dart';
import 'package:http/http.dart' as http;

const api =
    'https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json';

class PokeApp extends StatefulWidget {
  const PokeApp({Key? key}) : super(key: key);

  @override
  State<PokeApp> createState() => _PokeAppState();
}

class _PokeAppState extends State<PokeApp> {
  //final favorited = <Pokemon>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('PokeFlutter'),
      ),
      body: Container(
        child: FutureBuilder<List<Pokemon>>(
          future: buscaPokemons(),
          builder: (context, snapshot) {
            //TELA DE LOADING
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                ),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            List<Pokemon>? pokemons = snapshot.data;

            return pokemons != null && pokemons.isNotEmpty
                ? ListView.builder(
                    itemCount: pokemons.length,
                    itemBuilder: (_, i) {
                      if (i.isOdd) return const Divider();

                      //final alreadyFav = favorited.contains(pokemons[i]);

                      return ListTile(
                        title: Text(pokemons[i].name),
                        trailing: Icon(
                          Icons.catching_pokemon,
                          color: pokemons[i].fav ? Colors.red : Colors.grey,
                        ),
                        onTap: () {
                          
                          setState(() {
                            print(pokemons[i].fav);
                            pokemons[i].setFav();
                            print(pokemons[i].fav);
                          });
                        },
                      );
                    },
                  )
                : const Center(
                    child: Text('Ops, sem pokemons!'),
                  );
          },
        ),
      ),
    );
  }
}

Future<List<Pokemon>> buscaPokemons() async {
  var url = Uri.parse(api);

  //Lista de Objetos Pokemons
  List<Pokemon> listaPokemons = [];

  http.Response response = await http.get(url);

  var responseData;

  if (response.statusCode == 200) {
    responseData = json.decode(response.body);
  }

  for (int i = 0; i < 151; i++) {
    listaPokemons.add(Pokemon(responseData['pokemon'][i]['name'], false));
  }

  return listaPokemons;
}
