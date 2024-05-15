import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _textValue = 0;

  @override
  void initState() {
    super.initState();
    // Charger la valeur au démarrage de l'application
    _loadTextValue();
  }
  // Méthode pour charger la valeur depuis les préférences partagées
  void _loadTextValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int storedValue = prefs.getInt('textValue') ?? 0;
    setState(() {
      _textValue = storedValue;
    });
  }
  // Méthode pour changer la valeur du texte
  void _changeTextValue() {
    setState(() {
      _textValue++;
    });
    // Stocker la nouvelle valeur dans les préférences partagées
    _saveTextValue();
  }

// Méthode pour sauvegarder la valeur dans les préférences partagées
  void _saveTextValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('textValue', _textValue);
  }

  // Méthode pour supprimer la valeur stockée
  void _clearTextValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('textValue');
    setState(() {
      _textValue = 0;
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exemple de SharedPreferences'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Valeur actuelle : $_textValue',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _changeTextValue,
              child: Text('Changer la valeur'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _clearTextValue,
              child: Text('Effacer la valeur'),
            ),
          ],
        ),
      ),
    );
  }
}
