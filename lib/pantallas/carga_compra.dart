import 'package:flutter/material.dart';
import 'package:stock/bdd/gastos_db.dart';
import 'package:stock/pantallas/lista_compras.dart';
import 'package:stock/pantallas/lista_productos.dart';
import 'package:stock/publicidad.dart';

class Carga_compra extends StatefulWidget {
  const Carga_compra({Key? key}) : super(key: key);

  @override
  _Carga_compraState createState() => _Carga_compraState();
}

class _Carga_compraState extends State<Carga_compra> {
  DateTime fecha = DateTime.now();
  double monto = 0;
  TextEditingController monto_controller = TextEditingController();
  TextEditingController asunto_controller = TextEditingController();
  TextEditingController nombre_controller = TextEditingController();
  TextEditingController cant_controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    monto_controller.addListener(() {});
    asunto_controller.addListener(() {});
    nombre_controller.addListener(() {});
    cant_controller.addListener(() {});
  }

  @override
  void dispose() {
    super.dispose();
    monto_controller.dispose();
    asunto_controller.dispose();
    nombre_controller.dispose();
    cant_controller.dispose();
  }

  void obtenerFecha() async {
    fecha = (await showDatePicker(
        context: context,
        initialDate: fecha,
        firstDate: DateTime(2020),
        lastDate: DateTime(3020)))!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Venta de productos"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          tooltip: "Atras",
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //La fecha de la transaccion
            Container(
              padding: EdgeInsets.all(6),
              width: 300,
              child: ElevatedButton(
                child: Text(
                  fecha.day.toString() +
                      "-" +
                      fecha.month.toString() +
                      "-" +
                      fecha.year.toString(),
                  style: TextStyle(fontSize: 30),
                ),
                onPressed: () async {
                  setState(() {
                    obtenerFecha();
                  });
                },
              ),
            ),
            Form(
                onChanged: () => Form.of(primaryFocus!.context!)!.save(),
                child: Wrap(
                  direction: Axis.vertical,
                  spacing: 20,
                  children: [
                    //El asunto de la transaccion
                    Container(
                      padding: EdgeInsets.all(6),
                      width: double.maxFinite,
                      child: TextFormField(
                        //initialValue: "1",
                        decoration: const InputDecoration(
                            hintText: "Asunto de la transaccion",
                            hintStyle: TextStyle(fontSize: 20),
                            labelText: "Asunto"),
                        controller: asunto_controller,
                        validator: (String? value) {
                          return (value == 0
                              ? "No deje este campo vacio"
                              : null);
                        },
                      ),
                    ),
                    //El nombre del comprador
                    Container(
                      padding: EdgeInsets.all(6),
                      width: double.maxFinite,
                      child: TextFormField(
                        //initialValue: "1",
                        decoration: const InputDecoration(
                            hintText: "Nombre del comprador",
                            hintStyle: TextStyle(fontSize: 20),
                            labelText: "Comprador"),
                        controller: nombre_controller,
                        validator: (String? value) {
                          return (value == 0
                              ? "No deje este campo vacio"
                              : null);
                        },
                      ),
                    ),
                    //El monto de la transaccion
                    Container(
                      padding: EdgeInsets.all(6),
                      width: double.maxFinite,
                      child: TextFormField(
                        decoration: const InputDecoration(
                            hintText: "Monto de la transaccion",
                            hintStyle: TextStyle(fontSize: 20),
                            labelText: "Monto"),
                        keyboardType: TextInputType.number,
                        controller: monto_controller,
                        validator: (String? value) {
                          return (value == 0
                              ? "No deje este campo vacio"
                              : null);
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(6),
                      width: double.maxFinite,
                      child: TextFormField(
                        //initialValue: "1",
                        decoration: const InputDecoration(
                            hintText: "Cantidad de elementos: ",
                            hintStyle: TextStyle(fontSize: 20),
                            labelText: "Cantidad"),
                        controller: cant_controller,
                        keyboardType: TextInputType.number,
                        onChanged: (String Val) {
                          setState(() {
                            monto = int.parse(cant_controller.text) *
                                double.parse(monto_controller.text);
                          });
                        },
                        validator: (String? value) {
                          return (value == 0
                              ? "No deje este campo vacio"
                              : null);
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(6),
                      width: double.maxFinite,
                      child: Text(
                        "Monto total: " + monto.toString(),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      /*TextFormField(
                        //initialValue: "1",
                        decoration: const InputDecoration(
                            hintText: "Nombre del comprador",
                            hintStyle: TextStyle(fontSize: 20),
                            labelText: "Comprador"),
                        controller: nombre_controller,
                        validator: (String? value) {
                          return (value == 0 ? "No deje este campo vacio" : null);
                        },
                      ),*/
                    ),
                  ],
                )),
            //La imagen del producto
            ElevatedButton(
                onPressed: () async {
                  //Guarda todos los datos en la base de datos
                  //int codigo = 0;
                  int codigo = await DB_transaccion.transaccionlength();
                  String fech = fecha.toString();
                  print(fech.substring(0, 10));
                  Transacciones transaccion = Transacciones(
                      cod: codigo,
                      nombre: nombre_controller.text,
                      asunto: asunto_controller.text,
                      monto: int.parse(cant_controller.text) *
                          double.parse(monto_controller.text),
                      fecha: fech.substring(0, 10));
                  DB_transaccion.insert(transaccion);
                  print(fecha.toString());
                  Route route =
                      MaterialPageRoute(builder: (context) => Lista_compra());
                  Navigator.pushReplacement(context, route);
                },
                child: Text("Guardar datos")),
                BannerLargePublicity(),
          ],
        ),
      ),
    );
  }
}
