import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:stock/bdd/gastos_db.dart';
import 'package:stock/pantallas/lista_gastos.dart';

class Carga_gasto extends StatefulWidget {
  const Carga_gasto({Key? key}) : super(key: key);

  @override
  _Carga_gastoState createState() => _Carga_gastoState();
}

class _Carga_gastoState extends State<Carga_gasto> {
  DateTime fecha = DateTime.now();
  TextEditingController monto_controller = TextEditingController();
  TextEditingController asunto_controller = TextEditingController();

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
    size: AdSize.largeBanner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  @override
  void initState() {
    super.initState();
    monto_controller.addListener(() {});
    asunto_controller.addListener(() {});
    myBanner.load();
  }

  @override
  void dispose() {
    monto_controller.dispose();
    asunto_controller.dispose();
    super.dispose();
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
        title: Text("Compra de productos"),
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
                            labelText: "Asunto"),
                        controller: asunto_controller,
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
                  ],
                )),
            //La imagen del producto
            ElevatedButton(
                onPressed: () async {
                  //Guarda todos los datos en la base de datos
                  //int codigo = 0;
                  String fech = fecha.toString();
                  int codigo = await DB_transaccion.transaccionlength();
                  Transacciones transaccion = Transacciones(
                      cod: codigo,
                      nombre: "Yo",
                      asunto: asunto_controller.text,
                      monto: double.parse(monto_controller.text),
                      fecha: fech.substring(0, 10));
                  DB_transaccion.insert(transaccion);
                  print(fecha.toString());
                  Route route =
                      MaterialPageRoute(builder: (context) => Lista_gastos());
                  Navigator.pushReplacement(context, route);
                  //MaterialPageRoute(builder: (context) => Lista_Productos()),
                },
                child: Text("Guardar datos")),
                Container(
                  alignment: Alignment.center,
                  child: AdWidget(ad: myBanner,),
                  width: myBanner.size.width.toDouble(),
                  height: myBanner.size.height.toDouble(),
                ),
          ],
        ),
      ),
    );
  }
}
