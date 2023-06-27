import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:app_cidadao/pages/ticket_info.dart';

import '../firebase_options.dart';

final functions = FirebaseFunctions.instance;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
class PixPage extends StatefulWidget{
  final double finalPrice;
  final double hours;
  final String zonaazul;
  final double price;
  final String placa;
  const PixPage(this.finalPrice, this.hours, this.zonaazul, this.price, this.placa, {Key? key}) : super(key: key);
  @override
  _PixPage createState() => _PixPage();
}
class _PixPage extends State<PixPage> {
  String  _result = "";
  String  _status = "";
  String  _transactionId = "";
  Future<void> paymentPixSimulator() async {
    var data = {
      "plate": widget.placa.toUpperCase(),
      "amount": widget.price,
      "hours": widget.hours
    };
    final result =
    await FirebaseFunctions.instanceFor(region: "southamerica-east1").httpsCallable('paymentPixSimulator').call(data);
    setState(() {
      _result = result.data["message"];
      _status = result.data["status"];
      _transactionId = result.data["transactionId"];

      print(_result);
      if(_result == "Sucesso"){
        Navigator.of(context).popUntil((route) {
          if (route.settings.name != "/") return false;
          return true;
        });
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TicketPage(widget.hours, widget.zonaazul, widget.finalPrice, widget.price, widget.placa, _transactionId))
        );
      }
      else{
        var snackBar = SnackBar(
          content: Text(_result.toString()),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  String  _chave = "";
  Future<void> getPixKey() async {
    final result =
    await FirebaseFunctions.instanceFor(region: "southamerica-east1")
        .httpsCallable('getPixKey')
        .call();
    setState(() {
      _chave = result.data[0]["chave"];
    });
  }

  final formKey = GlobalKey<FormState>(); //key for form
  String name="";

  @override
  void initState() {
    super.initState();
      getPixKey();
      Timer(const Duration(seconds: 10), () {
        paymentPixSimulator();
      });
  }

  @override
  Widget build(BuildContext context) {
    final double height= MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
        title: const Text("Pagamento por PIX"),
      ),
      backgroundColor: const Color(0xFFffffff),
      body: SingleChildScrollView(child: Container(
        padding: const EdgeInsets.only(left: 100, right: 40, top: 25),
        child: Column(
            children: [
              Form(
                key: formKey, //key for form
                child:Column(
                  children: [
                    SizedBox(height:height*0.04),
                    const Text(
                      'Valor a pagar',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 30),
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: <TextSpan>[
                        const TextSpan(
                            text: "R\$ ",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 40,
                            )),
                        TextSpan(
                            text: widget.finalPrice.toStringAsFixed(2),
                            style: const TextStyle(
                                fontSize: 40,
                                color: Colors.green,
                                fontWeight: FontWeight.bold)),
                      ]),
                    ),
                    SizedBox(height:height*0.05),
                    const Text(
                      'QR CODE',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 20),
                    ),
                    QrImage(
                      data: _chave,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                    SizedBox(height:height*0.02),
                    const Text(
                      "Chave PIX",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 24),
                    ),
                    //Text("Welcomed !", style: TextStyle(fontSize: 30, color:Color(0xFF363f93)),),
                    SizedBox(height: height*0.03,),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: const BorderSide(color: Colors.black)
                            )
                        ),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        elevation: MaterialStateProperty.resolveWith<double?>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return 16;
                              }
                              return null;
                            }
                        ),
                      ),
                      icon: const Icon(Icons.copy),
                      label: const Text('COPIAR'),
                      onPressed: () =>
                          Clipboard.setData(ClipboardData(text: _chave))
                              .then((value) { //only if ->
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Chave copiada'),
                              ),
                            ); // -> show a notification
                          },
                          ),
                    ),
                  ],
                ),
              ),
            ]),
        ),
      ),
    );
  }


    Future selectNotification(String payload) async {
      //Handle notification tapped logic here
    }
    /*
    showDialog(context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text("Teste"),
          content: Text("Teste"),
          actions: [
            CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("Ok"),
                onPressed: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => TicketPage(widget.hours, widget.zonaazul, widget.finalPrice, widget.price, widget.placa, _transactionId),));

                }
            )
          ],
        )
    );*/

}