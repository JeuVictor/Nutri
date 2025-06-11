import 'dart:async';

import 'package:sqflite/sqflite.dart';
import '../database/db.dart';
import '../models/usuario_model.dart';

class UsuarioRepository {
  Future<void> inserirUsuario(UsuarioModel usuario) async {
    final db = await DB.instance.database;

    await db.insert(
      'usuario',
      usuario.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> atualizarUsuario(UsuarioModel u) async {
    final db = await DB.instance.database;

    await db.update('usuario', u.toMap(), where: 'id = ?', whereArgs: [u.id]);
  }

  Future<UsuarioModel?> obterUsuario() async {
    final db = await DB.instance.database;

    final resultado = await db.query('usuario', limit: 1);

    if (resultado.isNotEmpty) {
      return UsuarioModel.fromMap(resultado.first);
    }
    return null;
  }

  Future<void> deletarTodos() async {
    final db = await DB.instance.database;
    await db.delete('usuario');
  }
}
