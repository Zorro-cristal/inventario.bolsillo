import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:stock/bdd/gastos_db.dart';
import 'package:stock/main.dart';
import 'package:stock/pantallas/actualizar_compra.dart';
import 'package:stock/pantallas/carga_compra.dart';
import 'package:grouped_list/grouped_list.dart';

class Lista_compra extends StatefulWidget {
  const Lista_compra({Key? key}) : super(key: key);

  @override
  _Lista_compraState createState() => _Lista_compraState();
}

class _Lista_compraState extends State<Lista_compra> {
  List<Transacciones> transacciones = [];
  List<Transacciones> filtrado = [];
  double total = 0;

  final BannerAdListener listener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );

  final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-6184780932224233/6744302941',
    //adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  @override
  void initState() {
    myBanner.load();
    obtenerListaCompras();
    super.initState();
  }

  void obtenerListaCompras() async {
    List<Transacciones> aux = await DB_transaccion.transacciones();
    aux.sort((a, b) => a.cod.compareTo(b.cod));
    aux.removeWhere((element) => element.nombre == "Yo");
    /*int fin = await DB_transaccion.transaccionlength();
    for (int i = 0; i < fin; i++) {
      if (aux[i].nombre == "Yo") {
        aux.remove(aux[i]);
      }
    }*/
    setState(() {
      transacciones = aux;
      filtrado = transacciones;
    });
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < transacciones.length; i++) {
      setState(() {
        total = total + transacciones[i].monto;
      });
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("Lista de ventas"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            tooltip: "Atras",
            onPressed: () {
              //Navigator.pop(context);
              Route route =
                  MaterialPageRoute(builder: (context) => Principal());
              Navigator.pushReplacement(context, route);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Carga_compra()));
          },
          child: const Icon(Icons.add),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //Primeramente ira un filtrador
            Card(
              shadowColor: Colors.black54,
              elevation: 15,
              child: TextField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    hintStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                    hintText: "Ingrese el asunto de una transaccion"),
                onChanged: (string) {
                  setState(() {
                    filtrado = transacciones
                        .where((u) => u.asunto
                            .toLowerCase()
                            .contains(string.toLowerCase()))
                        .toList();
                    total = 0;
                  });
                  for (int i = 0; i < filtrado.length; i++) {
                    setState(() {
                      total = total + filtrado[i].monto;
                    });
                  }
                },
              ),
            ),
            //Ahora ira la lista de transacciones
            Expanded(
              child: GroupedListView<dynamic, Transacciones>(
                elements: filtrado,
                groupBy: (element) => element,
                groupSeparatorBuilder: (Transacciones groupByValue) {
                  return Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blue,
                      ),
                      child: Text(
                        groupByValue.fecha,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ));
                },
                itemComparator: (element1, element2) =>
                    element1.fecha.compareTo(element2.fecha),
                useStickyGroupSeparators: true,
                floatingHeader: true,
                order: GroupedListOrder.ASC,
                itemBuilder: (context, dynamic element) {
                  /*return Text(element.nombre);
              },
            )),
            Expanded(
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                  itemCount: filtrado.length,
                  itemBuilder: (context, index) {*/
                  return Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white60),
                        color: Colors.white),
                    child: ListTile(
                      //title: Text(filtrado[index].asunto),
                      title: Text(element.asunto),
                      //subtitle: Text(filtrado[index].monto.toString()),
                      subtitle: Text(element.monto.toString()),
                      onLongPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Actualizar_gastos(transaccion: element)));
                      },
                      onTap: () async {
                        //Muestra informacion del producto
                        return showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              String fecha = element.fecha;
                              return AlertDialog(
                                content: Column(
                                  children: [
                                    Container(
                                      //height: 50,
                                      width: 300,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          Text("Fecha de la compra: ",
                                              style: TextStyle(
                                                  backgroundColor: Colors.white,
                                                  fontSize: 20,
                                                  fontStyle: FontStyle.italic)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            fecha.substring(8, 10) +
                                                "/" +
                                                fecha.substring(5, 7) +
                                                "/" +
                                                fecha.substring(0, 4),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                backgroundColor: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      //height: 50,
                                      width: 300,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          Text("Nombre del comprador: ",
                                              style: TextStyle(
                                                  backgroundColor: Colors.white,
                                                  fontSize: 20,
                                                  fontStyle: FontStyle.italic)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            //filtrado[index].nombre,
                                            element.nombre,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                backgroundColor: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      //height: 50,
                                      width: 300,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          Text("Producto comprado: ",
                                              style: TextStyle(
                                                  backgroundColor: Colors.white,
                                                  fontSize: 20,
                                                  fontStyle: FontStyle.italic)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            //filtrado[index].asunto,
                                            element.asunto,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                backgroundColor: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      //height: 50,
                                      width: 300,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          Text("Monto de la compra: ",
                                              style: TextStyle(
                                                  backgroundColor: Colors.white,
                                                  fontSize: 20,
                                                  fontStyle: FontStyle.italic)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            //filtrado[index].monto.toString(),
                                            element.monto.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                backgroundColor: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                    ),
                  );
                },
              ),
            ),
            //),
            //Suma de los elementos
            Card(
              elevation: 15,
              shadowColor: Colors.black54,
              child: Text(
                "Suma total= " + total.toString(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: AdWidget(
                ad: myBanner,
              ),
              width: myBanner.size.width.toDouble(),
              height: myBanner.size.height.toDouble(),
            ),
          ],
        ));
  }
}
