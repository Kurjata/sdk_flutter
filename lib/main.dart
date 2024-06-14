import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
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
  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchData() async {
    try {
      if (_webViewController != null) {

        String html = await _webViewController!.currentUrl();
        // Extrair dados JSON do HTML
        _userData = jsonDecode(html);
        log('Dados do Usuário: $_userData');
        setState(() {
          _statusMessage = 'Dados carregados com sucesso!';
        });
      } else {
        setState(() {
          _statusMessage = 'Erro ao carregar dados: WebView não inicializada.';
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // WebView para abrir a URL e capturar os dados
            SizedBox(
              height: 300,
              child: WebView(
                initialUrl: 'https://app.track.co/survey/QGAILkDBvkAdbb80243a-41c9-49df-5250-1ad3693653c3',
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
                onPageFinished: (url) {
                  fetchData(); // Busca os dados após a página carregar
                },
              ),
            ),
            SizedBox(height: 20),
            // Exibe o status e os dados do usuário
            Text(_statusMessage),
            if (!_userData.isEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _userData.keys.length,
                itemBuilder: (context, index) {
                  final key = _userData.keys.elementAt(index);
                  return ListTile(
                    leading: Icon(Icons.person),
                    title: Text(key),
                    subtitle: Text(_userData[key].toString()),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}