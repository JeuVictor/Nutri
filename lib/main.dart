import 'package:flutter/material.dart';
import './pages/login.dart';
import './pages/pacientes.dart';
import './pages/myapp.dart';
import './pages/cadastro_paciente.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Nutri Duda',
      initialRoute: '/',
      routes: {
        '/cadastro_paciente': (context) => const CadastroPaciente(),
        '/': (context) => const MyApp(),
        '/pacientes': (context) => const Pacientes(),
        '/login': (context) => const Login(),
      },
    ),
  );
}
