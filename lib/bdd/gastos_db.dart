import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Transacciones {
  String fecha;
  String asunto;
  double monto;
  String nombre;
  int cod;

  Transacciones({
    required this.fecha,
    required this.asunto,
    required this.monto,
    required this.nombre,
    required this.cod,
  });

  Map<String, dynamic> toMap() {
    return {
      'cod': cod,
      'fecha': fecha,
      'nombre': nombre,
      'monto': monto,
      'asunto': asunto,
    };
  }
}

class DB_transaccion {
  static Future<Database> _openDb() async {
    return openDatabase(join(await getDatabasesPath(), 'transaccion.db'),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE transaccion (cod INTEGER PRIMARY KEY, nombre TEXT, fecha TEXT, asunto TEXT, monto REAL)");
    }, version: 1);
  }

  static Future<int> insert(Transacciones transac) async {
    Database database = await _openDb();
    return database.insert("transaccion", transac.toMap());
  }

  static Future<int> delete(Transacciones transac) async {
    Database database = await _openDb();
    return database
        .delete("transaccion", where: "cod= ?", whereArgs: [transac.cod]);
  }

  static Future<int> update(Transacciones transac) async {
    Database database = await _openDb();
    return database.update("transaccion", transac.toMap(),
        where: "cod= ?", whereArgs: [transac.cod]);
  }

  static Future<List<Transacciones>> transacciones() async {
    Database database = await _openDb();
    final List<Map<String, dynamic>> transaccionMap =
        await database.query("transaccion");
    for (var n in transaccionMap) {
      print("cod " + n['cod'].toString() + ": " + n['asunto']);
    }
    return List.generate(
        transaccionMap.length,
        (i) => Transacciones(
            cod: transaccionMap[i]['cod'],
            asunto: transaccionMap[i]['asunto'],
            nombre: transaccionMap[i]['nombre'],
            fecha: transaccionMap[i]['fecha'],
            monto: transaccionMap[i]['monto']));
  }

  static Future<int> transaccionlength() async {
    Database database = await _openDb();
    final List<Map<String, dynamic>> transaccionMap =
        await database.query("transaccion");
    return transaccionMap.length;
  }
}
