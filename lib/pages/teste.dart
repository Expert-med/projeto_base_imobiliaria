import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TestePage extends StatefulWidget {
  @override
  _TestePageState createState() => _TestePageState();
}

class _TestePageState extends State<TestePage> {
  String? _selectedState;
  String? _selectedCity;
  List<String> _states = [];
  Map<String, List<String>> _cities = {};

  @override
  void initState() {
    super.initState();
    fetchStates();
  }

  Future<void> fetchStates() async {
    final response = await http.get(Uri.parse('https://servicodados.ibge.gov.br/api/v1/localidades/estados'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        _states = data.map((state) => state['nome']).cast<String>().toList();
      });
    } else {
      throw Exception('Failed to fetch states');
    }
  }

  Future<void> fetchCities(String stateCode) async {
    final response = await http.get(Uri.parse('https://servicodados.ibge.gov.br/api/v1/localidades/estados/$stateCode/municipios'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        _cities[stateCode] = data.map((city) => city['nome']).cast<String>().toList();
      });
    } else {
      throw Exception('Failed to fetch cities');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estados e Cidades'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedState,
              hint: Text('Selecione um estado'),
              onChanged: (value) {
                setState(() {
                  _selectedState = value; // Atualizar o estado selecionado
                  _selectedCity = null; // Resetar a cidade selecionada
                });
                if (_cities[value!] == null) {
                  fetchCities(value!); // Carregar as cidades para o estado selecionado
                }
              },
              items: _states.map((state) {
                return DropdownMenuItem<String>(
                  value: state,
                  child: Text(state),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            if (_selectedState != null && _cities[_selectedState!] != null)
              DropdownButtonFormField<String>(
                value: _selectedCity,
                hint: Text('Selecione uma cidade'),
                onChanged: (value) {
                  setState(() {
                    _selectedCity = value; // Atualizar a cidade selecionada
                  });
                },
                items: _cities[_selectedState!]!.map((city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
