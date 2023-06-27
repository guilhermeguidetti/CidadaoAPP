import 'package:app_cidadao/pages/payment.dart';
import 'package:app_cidadao/pages/ticket_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../firebase_options.dart';

class CreditCardPage extends StatefulWidget{
  final double finalPrice;
  final double hours;
  final String zonaazul;
  final double price;
  final String placa;
  const CreditCardPage(this.finalPrice, this.hours, this.zonaazul, this.price, this.placa, {Key? key}) : super(key: key);


  @override
  _CreditCardPage createState() => _CreditCardPage();
}

 class _CreditCardPage extends State<CreditCardPage>{
   String  _result = "";
   String  _status = "";
   String  _transactionId = "";

   Future<void> paymentSimulator() async {
     var data = {
       "cardHolderName": name.text.toUpperCase(),
       "cardNumber": number.text,
       "cardValidityYear": year.text,
       "cardValidityMonth": month.text,
       "cvv": cvv.text,
       "plate": widget.placa.toUpperCase(),
       "amount": widget.price,
       "hours": widget.hours
     };
     final result =
     await FirebaseFunctions.instanceFor(region: "southamerica-east1").httpsCallable('paymentSimulator').call(data);
     setState(() {
       _result = result.data["message"];
       _status = result.data["status"];
       _transactionId = result.data["transactionId"];
       //log(jsonDecode(result.toString()));
       print(_result);
       if(_result == "Sucesso"){
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

   final formKey = GlobalKey<FormState>();
   TextEditingController cvv = TextEditingController();
   TextEditingController number = TextEditingController();
   TextEditingController year = TextEditingController();
   TextEditingController month = TextEditingController();
   TextEditingController name = TextEditingController();

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
         title: const Text("Pagamento por Cartão"),
       ),
      backgroundColor: const Color(0xFFffffff),
      body: SingleChildScrollView(child: Container(
        padding: const EdgeInsets.only(left: 40, right: 40, top: 25),
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
              'Dados do Cartão de Crédito',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 20),
            ),
            SizedBox(height: height*0.05,),
            TextFormField(
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              controller: name,
              decoration: const InputDecoration(

                  floatingLabelStyle: TextStyle(color: Color(0xFF314BB4)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.5, color: Colors.blueAccent),
                    // borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.5, color: Colors.blue),
                  ),
                  labelText: "Nome"
              ),
            ),
            SizedBox(height: height*0.05,),
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(19),
              ],
              controller: number,
              decoration: const InputDecoration(
                  floatingLabelStyle: TextStyle(color: Color(0xFF314BB4)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.5, color: Colors.blueAccent),
                    // borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.5, color: Colors.blue),
                  ),
                  labelText: "Número"
              ),
            ),
            SizedBox(height: height*0.05,),
            Row(children: [
              Expanded(
                  child:TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(2),
                    ],
                    controller: month,
                  decoration: const InputDecoration(
                    floatingLabelStyle: TextStyle(color: Color(0xFF314BB4)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: Colors.blueAccent),
                      // borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: Colors.blue),
                    ),
                    labelText: "Mês"
              ),
            ),),
              const SizedBox(width: 5,),
              Expanded(
                child:TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(2),
                  ],
                  controller: year,
                  decoration: const InputDecoration(
                      floatingLabelStyle: TextStyle(color: Color(0xFF314BB4)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.5, color: Colors.blueAccent),
                        // borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.5, color: Colors.blue),
                      ),
                      labelText: "Ano"
                  ),
                ),),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                  child:
                  TextFormField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3),
                    ],
                    keyboardType: TextInputType.number,
                    controller: cvv,
              decoration: const InputDecoration(
                  floatingLabelStyle: TextStyle(color: Color(0xFF314BB4)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.5, color: Colors.blueAccent),
                    // borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.5, color: Colors.blue),
                  ),
                  labelText: "CVV"
              ),
            ),),]),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                paymentSimulator();
              },
              child: const Text('Realizar Pagamento'),
            )

     ]
     )
     )
     ]
     )

     )
     )
     );
   }



   }