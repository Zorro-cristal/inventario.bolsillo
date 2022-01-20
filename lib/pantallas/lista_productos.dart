import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:stock/bdd/productos_db.dart';
import 'package:stock/main.dart';
import 'package:stock/pantallas/actualizar_productos.dart';
import 'package:stock/pantallas/carga_productos.dart';

class Lista_Productos extends StatefulWidget {
  const Lista_Productos({Key? key}) : super(key: key);

  @override
  _Lista_ProductosState createState() => _Lista_ProductosState();
}

class _Lista_ProductosState extends State<Lista_Productos> {
  List<Producto> productos = [];
  List<Producto> filtrado = [];

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

  void initState() {
    obtenerListaProductos();
    myBanner.load();
    super.initState();
  }

  obtenerListaProductos() async {
    List<Producto> aux = await DB_producto.productos();
    aux.sort((a, b) => a.cod.compareTo(b.cod));
    setState(() {
      productos = aux;
      filtrado = productos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Lista de productos"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            tooltip: "Atras",
            onPressed: () {
              Route route =
                  MaterialPageRoute(builder: (context) => Principal());
              Navigator.pushReplacement(context, route);
              //Navigator.pop(context);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Carga_productos()));
          },
          child: const Icon(Icons.add),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
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
                    hintText: "Ingrese el nombre de un producto"),
                onChanged: (string) {
                  setState(() {
                    filtrado = productos
                        .where((u) => u.nombre
                            .toLowerCase()
                            .contains(string.toLowerCase()))
                        .toList();
                  });
                },
              ),
            ),
            //Ahora ira la lista de productos
            Expanded(
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: filtrado.length,
                  itemBuilder: (context, index) {
                    print(productos.length.toString());
                    return ListTile(
                      title: Text(filtrado[index].nombre),
                      subtitle: Text(filtrado[index].venta.toString()),
                      onLongPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Actualizar_productos(
                                    prod: productos[index])));
                      },
                      onTap: () async {
                        //Muestra informacion del producto
                        return showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.black12,
                                content: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    //Card(child: Text("Imagen del producto")),
                                    Container(
                                      //height: 50,
                                      width: 300,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          Text("Codigo del producto: ",
                                              style: TextStyle(
                                                  backgroundColor: Colors.white,
                                                  fontSize: 20,
                                                  fontStyle: FontStyle.italic)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            filtrado[index].cod.toString(),
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
                                          Text("Producto: ",
                                              style: TextStyle(
                                                  backgroundColor: Colors.white,
                                                  fontSize: 20,
                                                  fontStyle: FontStyle.italic)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            filtrado[index].nombre,
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
                                          Text("Precio de venta: ",
                                              style: TextStyle(
                                                  backgroundColor: Colors.white,
                                                  fontSize: 20,
                                                  fontStyle: FontStyle.italic)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            filtrado[index].venta.toString(),
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
                                          Text("Cantidad en Stock: ",
                                              style: TextStyle(
                                                  backgroundColor: Colors.white,
                                                  fontSize: 20,
                                                  fontStyle: FontStyle.italic)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            filtrado[index].cantidad.toString(),
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
                    );
                  },
                ),
              ),
            ),
            Card(
              elevation: 15,
              shadowColor: Colors.black54,
              child: Text(
                "Total de productos: " + productos.length.toString(),
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
