import 'package:flutter/material.dart';
import 'package:stock/pantallas/lista_cliente.dart';
import 'package:stock/pantallas/lista_compras.dart';
import 'package:stock/pantallas/lista_gastos.dart';
import 'package:stock/pantallas/lista_productos.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const Principal(),
    );
  }
}

class Principal extends StatefulWidget {
  const Principal({Key? key}) : super(key: key);

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage("assets/fondo.jpg"))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Wrap(
              direction: Axis.vertical,
              alignment: WrapAlignment.end,
              spacing: 20,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                //Boton para acceder a la lista de productos
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Lista_Productos()));
                          },
                          child: boton("Lista de productos")),
                    ),
                  ],
                ),
                //Registros individuales
                /*
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Lista()));
                      },
                      child: boton("Registros de productos individuales")),
                ),*/
                //Boton para acceder a la lista de compras
                Row(
                  children: [
                    SizedBox(width: 30),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Lista_compra()));
                          },
                          child: boton("Lista de Ventas")),
                    ),
                  ],
                ),
                //Lista de gastos
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Lista_gastos()));
                          },
                          child: boton("Lista de Gastos")),
                    ),
                  ],
                ),
                //Boton para acceder a la lista de clientes
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Lista_clientes()));
                          },
                          child: boton("Lista de Clientes")),
                    ),
                  ],
                ),
                //Botones de ayuda
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Ayuda()));
                          },
                          child: boton("Ayuda")),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget boton(String titulo) {
    return Container(
      width: 140,
      child: Card(
          color: Colors.blue,
          margin: EdgeInsets.all(8),
          child: Text(
            titulo,
            style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 25,
                backgroundColor: Colors.blue),
          )),
    );
  }
}

class Ayuda extends StatelessWidget {
  const Ayuda({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de productos"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          tooltip: "Atras",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
          //Navigator.pushReplacement(context, route);
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: const DecorationImage(
                image: AssetImage("assets/ayuda.jpg"), fit: BoxFit.cover)),
      ),
    );
  }
}
