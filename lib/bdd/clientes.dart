import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Cliente {
  String ruc;
  String nombre;
  String direccion;
  String numero;

  Cliente({required this.ruc, required this.nombre, required this.direccion, required this.numero});

  Map<String, dynamic> toMap() {
    return {
      'ruc': ruc,
      'nombre': nombre,
      'direccion': direccion,
      'numero': numero,
    };
  }
}

class DB_cliente {
  static Future<Database> _openDb() async {
    return openDatabase(join(await getDatabasesPath(), 'cliente.db'),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE cliente (ruc TEXT PRIMARY KEY, nombre TEXT, direccion TEXT, numero TEXT)");
    }, version: 1);
  }

  static Future<int> insert(Cliente cliente) async {
    Database database = await _openDb();
    return database.insert("cliente", cliente.toMap());
  }

  static Future<int> delete(Cliente cliente) async {
    Database database = await _openDb();
    return database
        .delete("cliente", where: "ruc= ?", whereArgs: [cliente.ruc]);
  }

  static Future<int> update(Cliente cliente) async {
    Database database = await _openDb();
    return database.update("cliente", cliente.toMap(),
        where: "ruc= ?", whereArgs: [cliente.ruc]);
  }

  static Future<List<Cliente>> clientes() async {
    Database database = await _openDb();
    final List<Map<String, dynamic>> clienteMap =
        await database.query("cliente");
    for (var n in clienteMap) {
      print("ruc " + n['ruc'] + ": " + n['nombre']);
    }
    return List.generate(
        clienteMap.length,
        (i) => Cliente(
            ruc: clienteMap[i]['ruc'],
            nombre: clienteMap[i]['nombre'],
            direccion: clienteMap[i]['direccion'],
            numero: clienteMap[i]['numero']));
  }

  static Future<int> clientelength() async {
    Database database = await _openDb();
    final List<Map<String, dynamic>> clienteMap =
        await database.query("cliente");
    return clienteMap.length;
  }
}
