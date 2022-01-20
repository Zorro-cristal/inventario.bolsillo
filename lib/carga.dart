import 'package:flutter/material.dart';

class Carga extends StatefulWidget {
  const Carga({Key? key}) : super(key: key);

  @override
  _CargaState createState() => _CargaState();
}

class _CargaState extends State<Carga> {
  late String nombre;
  double compra = 0;
  double venta = 0;
  late int cantidad;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carga de producto"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          tooltip: "Atras",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(6),
            child:
                //El campo de nombre del producto
                TextFormField(
              decoration: const InputDecoration(
                  hintText: "Nombre del producto", labelText: "Producto"),
              onSaved: (String? value) {
                nombre = value!;
              },
              validator: (String? value) {
                return (value == null ? "No deje este campo vacio" : null);
              },
            ),
          ),
          //La cantidad del producto
          Container(
            padding: EdgeInsets.all(6),
            child: TextFormField(
              decoration: const InputDecoration(
                  hintText: "Cantidad del producto", labelText: "Cantidad"),
              onSaved: (String? value) {
                nombre = value!;
              },
              validator: (String? value) {
                return (value == 0 ? "No deje este campo vacio" : null);
              },
            ),
          ),
          //El campo de precio de compra
          Container(
            padding: EdgeInsets.all(6),
            child: TextFormField(
              decoration: const InputDecoration(
                  hintText: "Precio de compra del producto",
                  labelText: "Precio de compra"),
              onSaved: (String? value) {
                compra = value as double;
              },
            ),
          ),
          //El campo de precio de venta
          Container(
            padding: EdgeInsets.all(6),
            child: TextFormField(
              decoration: const InputDecoration(
                  hintText: "Precio de venta del producto",
                  labelText: "Precio de venta"),
              onSaved: (String? value) {
                venta = value as double;
              },
            ),
          ),
          //La imagen del producto
          //Muestra el monto de ganancia y el porcentaje
          Container(child: Text((venta - compra).toString())),
          ElevatedButton(
              onPressed: () {
                //Guarda todos los datos en la base de datos
              },
              child: Text("Guardar datos"))
        ],
      ),
    );
  }
}
