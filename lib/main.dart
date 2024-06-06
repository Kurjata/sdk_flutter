import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _statusMessage = 'Carregando...';
  Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('https://app.track.co/survey/pKkCv3TQTZed5efab2b4-c083-4025-4fb0-1733838642d2'));
      Map<String, dynamic> data = jsonDecode(response.body);
      log('$data');
      if (response.statusCode == 200) {
        setState(() {
          _userData = json.decode(response.body);
          _statusMessage = 'Dados carregados com sucesso!';
        });
      } else {
        setState(() {
          _statusMessage = 'Erro ao carregar dados: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Erro ao conectar ao servidor: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Usuário'),
      ),
      body: Center(
        child: _userData.isEmpty
            ? Text(_statusMessage)
            : ListView(
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Nome completo'),
              subtitle: Text('${_userData['nome']} ${_userData['sobrenome']}'),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('E-mail'),
              subtitle: Text(_userData['email']),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Login'),
              subtitle: Text(_userData['login']),
            ),
            ListTile(
              leading: Icon(Icons.lock_outline),
              title: Text('CPF'),
              subtitle: Text(_userData['cpf']),
            ),
          ],
        ),
      ),
    );
  }
}