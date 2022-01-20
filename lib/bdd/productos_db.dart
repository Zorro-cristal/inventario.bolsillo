import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Producto {
  final int cod;
  final String nombre;
  final int cantidad;
  final double compra;
  final double venta;

  Producto(
      {required this.cod,
      required this.nombre,
      required this.cantidad,
      required this.compra,
      required this.venta});

  Map<String, dynamic> toMap() {
    return {
      'cod': cod,
      'nombre': nombre,
      'cantidad': cantidad,
      'compra': compra,
      'venta': venta,
    };
  }
}

class DB_producto {
  static Future<Database> _openDb() async {
    return openDatabase(join(await getDatabasesPath(), 'producto.db'),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE producto (cod INTEGER PRIMARY KEY, nombre TEXT, cantidad INTEGER, compra REAL, venta REAL)");
    }, version: 1);
  }

  static Future<int> insert(Producto producto) async {
    Database database = await _openDb();
    return database.insert("producto", producto.toMap());
  }

  static Future<int> delete(Producto producto) async {
    Database database = await _openDb();
    return database
        .delete("producto", where: "cod= ?", whereArgs: [producto.cod]);
  }

  static Future<int> update(Producto producto) async {
    Database database = await _openDb();
    return database.update("producto", producto.toMap(),
        where: "cod= ?", whereArgs: [producto.cod]);
  }

  static Future<List<Producto>> productos() async {
    Database database = await _openDb();
    final List<Map<String, dynamic>> productoMap =
        await database.query("producto");
    for (var n in productoMap) {
      print("Producto " + n['cod'].toString() + ": " + n['nombre']);
    }
    return List.generate(
        productoMap.length,
        (i) => Producto(
            cod: productoMap[i]['cod'],
            nombre: productoMap[i]['nombre'],
            cantidad: productoMap[i]['cantidad'],
            compra: productoMap[i]['compra'],
            venta: productoMap[i]['venta']));
  }

  static Future<int> productolength() async {
    Database database = await _openDb();
    final List<Map<String, dynamic>> productoMap =
        await database.query("producto");
    return productoMap.length;
  }

  static Future<void> insertar2(Producto producto) async {
    Database database = await _openDb();
    var resultado = await database.rawInsert(
        "INSERT INTO producto (cod, nombre, cantidad, compra, venta"
        " VALUES (${producto.cod}, ${producto.nombre}, ${producto.cantidad}, ${producto.compra}, ${producto.venta})");
  }
}
