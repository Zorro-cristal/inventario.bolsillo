import 'package:flutter/material.dart';
import 'package:stock/bdd/clientes.dart';
import 'package:stock/pantallas/lista_cliente.dart';
import 'package:stock/publicidad.dart';

class Carga_cliente extends StatefulWidget {
  const Carga_cliente({Key? key}) : super(key: key);

  @override
  _Carga_clienteState createState() => _Carga_clienteState();
}

class _Carga_clienteState extends State<Carga_cliente> {
  TextEditingController ruc_controller = TextEditingController();
  TextEditingController nombre_controller = TextEditingController();
  TextEditingController direccion_controller = TextEditingController();
  TextEditingController numero_controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    ruc_controller.addListener(() {});
    nombre_controller.addListener(() {});
    direccion_controller.addListener(() {});
    numero_controller.addListener(() {});
  }

  @override
  void dispose() {
    ruc_controller.dispose();
    nombre_controller.dispose();
    direccion_controller.dispose();
    numero_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carga de datos del cliente"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          tooltip: "Atras",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Form(
                onChanged: () => Form.of(primaryFocus!.context!)!.save(),
                child: Wrap(
                  spacing: 20,
                  direction: Axis.vertical,
                  children: [
                    //El RUC del cliente
                    Container(
                      padding: EdgeInsets.all(6),
                      width: double.maxFinite,
                      child: TextFormField(
                        //initialValue: "1",
                        decoration: const InputDecoration(
                            hintText: "Ruc del cliente", 
                            hintStyle: TextStyle(fontSize: 20),
                            labelText: "Codigo"),
                        keyboardType: TextInputType.number,
                        controller: ruc_controller,
                        validator: (String? value) {
                          return (value == null
                              ? "No deje este campo vacio"
                              : null);
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(6),
                      width: double.maxFinite,
                      child:
                          //El campo de nombre del cliente
                          TextFormField(
                        decoration: const InputDecoration(
                            hintText: "Nombre del cliente",
                            hintStyle: TextStyle(fontSize: 20),
                            labelText: "Nombre"),
                        controller: nombre_controller,
                        validator: (String? value) {
                          return (value == null
                              ? "No deje este campo vacio"
                              : null);
                        },
                      ),
                    ),
                    //La direccion del cliente
                    Container(
                      padding: EdgeInsets.all(6),
                      width: double.maxFinite,
                      child: TextFormField(
                        decoration: const InputDecoration(
                            hintText: "Direccion del cliente",
                            hintStyle: TextStyle(fontSize: 20),
                            labelText: "Direccion"),
                        controller: direccion_controller,
                        validator: (String? value) {
                          return (value == 0 ? "No deje este campo vacio" : null);
                        },
                      ),
                    ),
                    //El campo del numero de contacto del cliente
                    Container(
                      padding: EdgeInsets.all(6),
                      width: double.maxFinite,
                      child: TextFormField(
                        decoration: const InputDecoration(
                            hintText: "Numero de contacto del cliente",
                            hintStyle: TextStyle(fontSize: 20),
                            labelText: "Numero de contacto"),
                        keyboardType: TextInputType.number,
                        controller: numero_controller,
                      ),
                    ),
                  ],
                )),
            ElevatedButton(
                onPressed: () {
                  //Guarda todos los datos en la base de datos
                  Cliente client = Cliente(
                      ruc: ruc_controller.text,
                      nombre: nombre_controller.text,
                      direccion: direccion_controller.text,
                      numero: numero_controller.text);
                  DB_cliente.insert(client);
                  //Navigator.pop(context);
                  Route route =
                      MaterialPageRoute(builder: (context) => Lista_clientes());
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
