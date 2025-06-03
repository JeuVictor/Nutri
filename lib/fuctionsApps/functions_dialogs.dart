import 'dart:io';

import 'package:flutter/material.dart';

Future<bool> mostrarDialogoConfirmacao({
  required BuildContext context,
  required String titulo,
  required String mensagem,
  String textConfirmar = 'Confirmar',
  String textCancelar = 'Cancelar',
  Color corBotaoConfirmar = Colors.red,
}) async {
  final resultado = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(titulo),
      content: Text(mensagem),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(textCancelar),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            textConfirmar,
            style: TextStyle(color: corBotaoConfirmar),
          ),
        ),
      ],
    ),
  );

  return resultado ?? false;
}

