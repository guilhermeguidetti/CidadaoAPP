import 'package:flutter/material.dart';
import 'package:app_cidadao/pages/home.dart';

class TicketPage extends StatefulWidget{
  final double hours;
  final String zonaazul;
  final double finalprice;
  final double price;
  final String placa;
  final String transactionId;
  const TicketPage(this.hours, this.zonaazul, this.finalprice, this.price, this.placa, this.transactionId, {Key? key}) : super(key: key);
  @override
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  // TODO IMPLEMENTAR FUNÇÃO DE INSERIR TICKET NO FIRESTORE
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String when_end_formatted = "";
    DateTime when_end = DateTime.now();
    String formattedDate = "\n${now.day.toString()}/${now.month.toString().padLeft(2,'0')}/${now.year.toString().padLeft(2,'0')} ${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}\n";
    if(widget.hours == 0.5) {
      when_end = now.add(const Duration(minutes: 30));
      when_end_formatted = "\n${when_end.day.toString()}/${when_end.month.toString().padLeft(2,'0')}/${when_end.year.toString().padLeft(2,'0')} ${when_end.hour.toString().padLeft(2,'0')}:${when_end.minute.toString().padLeft(2,'0')}\n";
    }
    else if(widget.hours == 1.0) {
      when_end = now.add(const Duration(hours: 1));
      when_end_formatted = "\n${when_end.day.toString()}/${when_end.month.toString().padLeft(2,'0')}/${when_end.year.toString().padLeft(2,'0')} ${when_end.hour.toString().padLeft(2,'0')}:${when_end.minute.toString().padLeft(2,'0')}\n";
    }
    else if(widget.hours == 2.0) {
      when_end = now.add(const Duration(hours: 2));
      when_end_formatted = "\n${when_end.day.toString()}/${when_end.month.toString().padLeft(2,'0')}/${when_end.year.toString().padLeft(2,'0')} ${when_end.hour.toString().padLeft(2,'0')}:${when_end.minute.toString().padLeft(2,'0')}\n";
    }
      return Scaffold(
      appBar: AppBar(
        title: const Text("Recibo"),
      ),
      body: SingleChildScrollView(child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: <Widget>[
            RichText(
                textAlign: TextAlign.left,
                text: const TextSpan(children: [
                  WidgetSpan(child: Icon(Icons.airplane_ticket, size: 40),
                  ),
                  TextSpan(
                      text: "TICKET COMPRADO ",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                      )),
                ])
            ),
            const SizedBox(
              width: 50,
              height: 50,
            ),
            RichText(
                textAlign: TextAlign.left,
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: widget.zonaazul,
                      style: const TextStyle(
                          fontSize: 30,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold)),
                ])
            ),
            RichText(
                textAlign: TextAlign.left,
                text: TextSpan(children: <TextSpan>[
                  const TextSpan(
                      text: "Placa: ",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: widget.placa.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 30,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold)),
                ])
            ),
            const SizedBox(
              width: 20,
              height: 20,
            ),
            RichText(
                textAlign: TextAlign.left,
                text: TextSpan(children: <TextSpan>[
                  const TextSpan(
                      text: "Tempo pago: ",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 30
                      )),
                  if(widget.hours == 0.5)
                    const TextSpan(
                        text: "30 min",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.black87))
                  else if(widget.hours == 1.0)
                    const TextSpan(
                        text: "1 hora",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.black87))
                  else if(widget.hours == 2.0)
                      const TextSpan(
                          text: "2 horas",
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.black87))
                ])
            ),
            const SizedBox(
              width: 30,
              height: 30,
            ),
            RichText(
                textAlign: TextAlign.left,
                text:  TextSpan(children: <TextSpan>[
                    const TextSpan(
                        text: "Valor/h: ",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 30
                        )),
                  const TextSpan(
                      text: "R\$ ",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.green)),
                  TextSpan(
                      text: widget.price.toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 30,
                          color: Colors.green))
                ])
            ),
            const SizedBox(
              width: 30,
              height: 30,
            ),
            RichText(
                textAlign: TextAlign.left,
                text: TextSpan(children: <TextSpan>[
                  const TextSpan(
                      text: "Valor total pago: ",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 30
                      )),
                  const TextSpan(
                      text: "R\$ ",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.green)),
                  TextSpan(
                      text: widget.finalprice.toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 30,
                          color: Colors.green))
                ])
            ),
            const SizedBox(
              width: 50,
              height: 50,
            ),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: <TextSpan>[
                  const TextSpan(
                      text: "Sua vaga estará disponível a partir de: ",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 30
                      )),
                  TextSpan(
                      text: formattedDate.toString(),
                      style: const TextStyle(
                          fontSize: 30,
                          color: Colors.red)),
                  const TextSpan(
                      text: "até ",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.black87)),
                  TextSpan(
                      text: when_end_formatted.toString(),
                      style: const TextStyle(
                          fontSize: 30,
                          color: Colors.red)),
                  TextSpan(
                      text: "\nID da transação: \n${widget.transactionId}\n",
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                      )),
                ]),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) {
                  if (route.settings.name != "/") return false;
                  return true;
                });},
              child: const Text('OK'),
            )

          ],
        ),
      ),
      ),
      );
    }
  }

DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
  value: item,
  child: Text(
    item,
    style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 20, color: Colors.grey),
  ),
);
