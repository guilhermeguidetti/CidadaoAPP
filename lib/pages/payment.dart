import 'dart:io';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:app_cidadao/pages/pix.dart';

import 'credit_card.dart';
class PaymentPage extends StatefulWidget{
  final double finalPrice;
  final double hours;
  final String zonaazul;
  final double price;
  const PaymentPage(this.finalPrice, this.hours, this.zonaazul, this.price, {Key? key}) : super(key: key);
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  TextEditingController placa = TextEditingController();
  TextEditingController cpf = TextEditingController();
  final formKey = GlobalKey<FormState>(); //key for form
  String name="";
  @override
  Widget build(BuildContext context) {
    final double height= MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    RegExp expPlaca = RegExp(
        r"^[a-zA-Z]{3}[0-9][A-Za-z0-9][0-9]{2}$",
        caseSensitive: false);
    RegExp expCpf = RegExp(r"^([0-9]{2}[\.]?[0-9]{3}[\.]?[0-9]{3}[\/]?[0-9]{4}[-]?[0-9]{2})|([0-9]{3}[\.]?[0-9]{3}[\.]?[0-9]{3}[-]?[0-9]{2})");

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
          title: const Text("Pagamento"),
        ),
        backgroundColor: const Color(0xFFffffff),
        body: SingleChildScrollView(child: Container(
          padding: const EdgeInsets.only(left: 40, right: 40, top: 25),
          child: Column(
              children: [
                Form(
                  key: formKey, //key for form
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                              text: 'R\$ ',
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
                      //Text("Welcomed !", style: TextStyle(fontSize: 30, color:Color(0xFF363f93)),),
                      SizedBox(height: height*0.05,),
                      TextFormField(
                        controller: placa,
                        decoration: const InputDecoration(
                          floatingLabelStyle: TextStyle(color: Color(0xFF314BB4)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1.5, color: Colors.blueAccent),
                              // borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1.5, color: Colors.blue),
                            ),
                            labelText: "Placa do Veículo"
                        ),
                        validator: (value) {
                          if(value!.isEmpty || !RegExp(r'^[A-Z]{3}[0-9][0-9A-Z][0-9]{2}+$').hasMatch(value)) {
                            return "Por favor, insira uma placa valida!";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(height: height*0.05,),
                      TextFormField(
                        controller: cpf,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            floatingLabelStyle: TextStyle(color: Color(0xFF314BB4)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1.5, color: Colors.blueAccent),
                              // borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1.5, color: Colors.blue),
                            ),
                            labelText: "CPF (Apenas Números)"
                        ),
                        validator: (value) {
                          if(value!.isEmpty || !RegExp(r'^([0-9]{2}[\.]?[0-9]{3}[\.]?[0-9]{3}[\/]?[0-9]{4}[-]?[0-9]{2})|([0-9]{3}[\.]?[0-9]{3}[\.]?[0-9]{3}[-]?[0-9]{2})+$').hasMatch(value)) {
                            return "Por favor, insira um CPF válido!";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(height: height*0.15,),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
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
                            icon: const Icon(Icons.credit_card_outlined, color: Colors.black),
                            onPressed: () {
                              if((expPlaca.hasMatch(placa.text)) && (expCpf.hasMatch(cpf.text))) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CreditCardPage(widget.finalPrice, widget.hours, widget.zonaazul, widget.price, placa.text)),
                                );
                              }
                              else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('CPF ou Placa do Veículo inválido'),
                                  ),
                                );
                              }
                            }, label: const Text("Pagar com Cartão de Crédito"),
                        ),
                      ),
                      SizedBox(height: height*0.01,),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
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
                          icon: const Icon(Icons.pix, color: Colors.black),
                          onPressed: () {
                            if((expPlaca.hasMatch(placa.text)) && (expCpf.hasMatch(cpf.text))) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PixPage(widget.finalPrice, widget.hours, widget.zonaazul, widget.price, placa.text)),
                              );
                            }
                            else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('CPF ou Placa do Veículo inválido'),
                                ),
                              );
                            }
                            }, label: const Text('Pagar com PIX'),
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
}