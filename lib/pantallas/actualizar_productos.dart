import 'package:flutter/material.dart';
import 'package:stock/bdd/productos_db.dart';
import 'package:stock/imagen.dart';
import 'package:stock/pantallas/lista_productos.dart';
import 'package:stock/publicidad.dart';

class Actualizar_productos extends StatefulWidget {
  final Producto prod;

  Actualizar_productos({Key? key, required this.prod}) : super(key: key);

  @override
  State<Actualizar_productos> createState() => _Actualizar_productosState();
}

class _Actualizar_productosState extends State<Actualizar_productos> {
  TextEditingController nombre_controller = TextEditingController();
  TextEditingController compra_controller = TextEditingController(text: "0");
  TextEditingController venta_controller = TextEditingController(text: "0");
  TextEditingController cantidad_controller = TextEditingController();
  double diferencia = 0;

  @override
  void initState() {
    super.initState;
    nombre_controller.addListener(() {});
    compra_controller.addListener(() {});
    venta_controller.addListener(() {});
    cantidad_controller.addListener(() {});
  }

  @override
  void dispose() {
    nombre_controller.dispose();
    compra_controller.dispose();
    venta_controller.dispose();
    cantidad_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Carga de producto"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          tooltip: "Atras",
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
                onChanged: () => Form.of(primaryFocus!.context!)!.save(),
                child: Wrap(
                  direction: Axis.vertical,
                  children: [
                    Card(
                      color: Colors.orange,
                      child: Text(
                          "Por favor ingrese todos los datos para actualizar el producto"),
                    ),
                    //El codigo del producto
                    Container(
                      padding: EdgeInsets.all(6),
                      width: double.maxFinite,
                      child:
                          //El campo de nombre del producto
                          TextFormField(
                        decoration: const InputDecoration(
                            hintText: "Nombre del producto",
                            hintStyle: TextStyle(fontSize: 20),
                            labelText: "Producto"),
                        controller: nombre_controller,
                        validator: (String? value) {
                          return (value == null
                              ? "No deje este campo vacio"
                              : null);
                        },
                      ),
                    ),
                    //La cantidad del producto
                    Container(
                      padding: EdgeInsets.all(6),
                      width: double.maxFinite,
                      child: TextFormField(
                        decoration: const InputDecoration(
                            hintText: "Cantidad del producto",
                            hintStyle: TextStyle(fontSize: 20),
                            labelText: "Cantidad"),
                        keyboardType: TextInputType.number,
                        controller: cantidad_controller,
                        validator: (String? value) {
                          return (value == 0 ? "No deje este campo vacio" : null);
                        },
                      ),
                    ),
                    //El campo de precio de compra
                    Container(
                      padding: EdgeInsets.all(6),
                      width: double.maxFinite,
                      child: TextFormField(
                          decoration: const InputDecoration(
                              hintText: "Precio de compra del producto",
                              hintStyle: TextStyle(fontSize: 20),
                              labelText: "Precio de compra"),
                          keyboardType: TextInputType.number,
                          controller: compra_controller,
                          onChanged: (String val) {
                            setState(() {
                              diferencia = double.parse(venta_controller.text) -
                                  double.parse(compra_controller.text);
                            });
                          }),
                    ),
                    //El campo de precio de venta
                    Container(
                      padding: EdgeInsets.all(6),
                      width: double.maxFinite,
                      child: TextFormField(
                          decoration: const InputDecoration(
                              hintText: "Precio de venta del producto",
                              hintStyle: TextStyle(fontSize: 20),
                              labelText: "Precio de venta"),
                          keyboardType: TextInputType.number,
                          controller: venta_controller,
                          onChanged: (String val) {
                            setState(() {
                              diferencia = double.parse(venta_controller.text) -
                                  double.parse(compra_controller.text);
                            });
                          }),
                    ),
                  ],
                )),
            //La imagen del producto
            Imagen_producto_carga(),
            Card(
              color: Colors.black26,
              child: Text("Imagen del producto"),
            ),
            //Muestra el monto de ganancia y el porcentaje
            Card(
                elevation: 5,
                color: Colors.white24,
                shadowColor: Colors.black38,
                margin: EdgeInsets.all(8),
                child: Text("Ganancia de: " + diferencia.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ))),
            ElevatedButton(
                onPressed: () async {
                  //Guarda todos los datos en la base de datos
                  //int cod = await DB_producto.productolength();
                  Producto prod = Producto(
                      cod: widget.prod.cod,
                      nombre: nombre_controller.text,
                      cantidad: int.parse(cantidad_controller.text),
                      compra: double.parse(compra_controller.text),
                      venta: double.parse(venta_controller.text));
                  DB_producto.update(prod);
                  print(prod.nombre + " actualizado correctamente");
                  Route route =
                      MaterialPageRoute(builder: (context) => Lista_Productos());
                  Navigator.pushReplacement(context, route);
                },
                child: Text("Guardar datos")),
            ElevatedButton(
                onPressed: () async {
                  //Guarda todos los datos en la base de datos
                  //int cod = await DB_producto.productolength();
                  Producto prod = Producto(
                      cod: widget.prod.cod,
                      nombre: widget.prod.nombre,
                      cantidad: widget.prod.cantidad,
                      compra: widget.prod.compra,
                      venta: widget.prod.venta);
                  DB_producto.delete(prod);
                  print(prod.nombre + " eliminado correctamente");
                  Route route =
                      MaterialPageRoute(builder: (context) => Lista_Productos());
                  Navigator.pushReplacement(context, route);
                },
                child: Text("Eliminar datos")),
                BannerLargePublicity(),
          ],
        ),
      ),
    );
  }
}
