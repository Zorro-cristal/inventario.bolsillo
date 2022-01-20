import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:stock/bdd/clientes.dart';
import 'package:stock/main.dart';
import 'package:stock/pantallas/actualizar_cliente.dart';
import 'package:stock/pantallas/carga_cliente.dart';

class Lista_clientes extends StatefulWidget {
  const Lista_clientes({Key? key}) : super(key: key);

  @override
  _Lista_clientesState createState() => _Lista_clientesState();
}

class _Lista_clientesState extends State<Lista_clientes> {
  List<Cliente> clientes = [];
  List<Cliente> filtrado = [];

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
    obtenerListaClientes();
    myBanner.load();
    super.initState();
  }

  obtenerListaClientes() async {
    List<Cliente> aux = await DB_cliente.clientes();
    aux.sort((a, b) => a.nombre.compareTo(b.nombre));
    setState(() {
      clientes = aux;
      filtrado = clientes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Lista de clientes"),
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
            Route route =
                MaterialPageRoute(builder: (context) => Carga_cliente());
            Navigator.push(context, route);
            //Navigator.pushReplacement(context, route);
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
                    hintText: "Ingrese el nombre de un cliente"),
                onChanged: (string) {
                  setState(() {
                    filtrado = clientes
                        .where((u) => u.nombre
                            .toLowerCase()
                            .contains(string.toLowerCase()))
                        .toList();
                  });
                },
              ),
            ),
            //Ahora ira la lista de clientes
            Expanded(
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: filtrado.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(filtrado[index].nombre),
                      subtitle: Text(filtrado[index].ruc),
                      onLongPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Actualizar_clientes(
                                    client: clientes[index])));
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
                                    Container(
                                      width: 300,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Ruc del cliente: ",
                                            style: TextStyle(
                                              backgroundColor: Colors.white,
                                              fontSize: 20,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            clientes[index].ruc,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              backgroundColor: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 300,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Nombre del cliente: ",
                                            style: TextStyle(
                                              backgroundColor: Colors.white,
                                              fontSize: 20,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            clientes[index].nombre,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              backgroundColor: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 300,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Direccion del cliente: ",
                                            style: TextStyle(
                                              backgroundColor: Colors.white,
                                              fontSize: 20,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            clientes[index].direccion,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              backgroundColor: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 300,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Nùmero del cliente: ",
                                            style: TextStyle(
                                              backgroundColor: Colors.white,
                                              fontSize: 20,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            clientes[index].numero,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              backgroundColor: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25,
                                            ),
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
            //Mostrara el total de clientes
            Card(
              elevation: 15,
              shadowColor: Colors.black54,
              child: Text(
                "Numero de clientes: " + clientes.length.toString(),
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
