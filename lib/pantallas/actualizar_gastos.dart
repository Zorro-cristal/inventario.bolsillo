import 'package:flutter/material.dart';
import 'package:stock/bdd/gastos_db.dart';
import 'package:stock/pantallas/lista_gastos.dart';
import 'package:stock/publicidad.dart';

class Actualizar_gastos extends StatefulWidget {
  Transacciones transaccion;

  Actualizar_gastos({Key? key, required this.transaccion}) : super(key: key);

  @override
  _Actualizar_gastosState createState() => _Actualizar_gastosState();
}

class _Actualizar_gastosState extends State<Actualizar_gastos> {
  TextEditingController monto_controller = TextEditingController();
  TextEditingController asunto_controller = TextEditingController();
  DateTime fecha = DateTime.now();

  @override
  void initState() {
    super.initState();
    monto_controller.addListener(() {});
    asunto_controller.addListener(() {});
  }

  @override
  void dispose() {
    super.dispose();
    monto_controller.dispose();
    asunto_controller.dispose();
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
          title: Text("Actualizar Gastos"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            tooltip: "Atras",
            onPressed: () => Navigator.pop(context),
          )),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //La fecha de la transaccion
            Container(
              padding: EdgeInsets.all(6),
              width: double.maxFinite,
              child: ElevatedButton(
                child: Text(fecha.day.toString() +
                    "-" +
                    fecha.month.toString() +
                    "-" +
                    fecha.year.toString()),
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
                  spacing: 20,
                  direction: Axis.vertical,
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
                          return (value == 0 ? "No deje este campo vacio" : null);
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
                          return (value == 0 ? "No deje este campo vacio" : null);
                        },
                      ),
                    ),
                  ],
                )),
            ElevatedButton(
                onPressed: () async {
                  //Guarda todos los datos en la base de datos
                  //int codigo = 0;
                  String fech= fecha.toString();
                  Transacciones transaccion = Transacciones(
                      cod: widget.transaccion.cod,
                      nombre: "Yo",
                      asunto: asunto_controller.text,
                      monto: double.parse(monto_controller.text),
                      fecha: fech.substring(0, 10));
                  DB_transaccion.insert(transaccion);
                  print(fecha.toString());
                  Route route =
                      MaterialPageRoute(builder: (context) => Lista_gastos());
                  Navigator.pushReplacement(context, route);
                },
                child: Text("Guardar datos")),
            ElevatedButton(
                onPressed: () async {
                  //Guarda todos los datos en la base de datos
                  //int codigo = 0;
                  String fech;
                  Transacciones transaccion = Transacciones(
                      cod: widget.transaccion.cod,
                      nombre: widget.transaccion.nombre,
                      asunto: widget.transaccion.asunto,
                      monto: widget.transaccion.monto,
                      fecha: widget.transaccion.fecha);
                  DB_transaccion.delete(transaccion);
                  print(fecha.toString());
                  Route route =
                      MaterialPageRoute(builder: (context) => Lista_gastos());
                  Navigator.pushReplacement(context, route);
                  //MaterialPageRoute(builder: (context) => Lista_Productos()),
                },
                child: Text("Eliminar datos")),
                BannerLargePublicity(),
          ],
        ),
      ),
    );
  }
}
