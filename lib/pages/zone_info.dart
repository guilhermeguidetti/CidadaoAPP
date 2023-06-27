import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:app_cidadao/pages/payment.dart';
class ZoneInfoPage extends StatefulWidget {
  const ZoneInfoPage(this.zoneId, {Key? key, required this.title}) : super(key: key);
  final int zoneId;
  final String title;

  @override
  State<ZoneInfoPage> createState() => _ZoneInfoPageState();
}
class _ZoneInfoPageState extends State<ZoneInfoPage> {
  String partners = "";
  String partners1 = "";
  String partners2 = "";
  String hours1 = "";
  String hours2 = "";
  String hours3 = "";
  String rules = "";
  double price = 5;
  String zoneName = "";

  Future<void> getZoneInfo() async {
    final result =
    await FirebaseFunctions.instanceFor(region: "southamerica-east1")
        .httpsCallable('getZonesInfo')
        .call();
    setState(() {
       hours1 = result.data[widget.zoneId]["hours"][0].toString();
       hours2 = result.data[widget.zoneId]["hours"][1].toString();
       hours3 = result.data[widget.zoneId]["hours"][2].toString();
       partners = result.data[widget.zoneId]["partners"][0].toString();
       partners1 = result.data[widget.zoneId]["partners"][1].toString();
       partners2 = result.data[widget.zoneId]["partners"][2].toString();
       rules = result.data[widget.zoneId]["rules"][0].toString();
       zoneName = result.data[widget.zoneId]["name"].toString();
    });
  }
  static const double _price = 5;
  final _items = [
    "00h30m",
    "01h00m",
    "02h00m",
  ];
  final _hours = [
    0.5,
    1.0,
    2.0,
  ];
  double _finalPrice = _price/2;
  String value = "00h30m";
  double _hoursP = 0.5;
  void dropdownCallback(String? selectedValue) {
    if(selectedValue is String) {
      setState(() {
        value = selectedValue;
        _hoursP = _hours[_items.indexWhere((element) => element == value)];
        _finalPrice = _price * _hours[_items.indexWhere((element) => element == value)];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getZoneInfo();
  }

  @override
  Widget build(BuildContext context) {
    final double _price = price;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                  ),
        title: Text(zoneName),
      ),
      body: SingleChildScrollView(child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Valor/h',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const SizedBox(width: 50),
                  Text(
                    'R\$ ${_price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ]
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Tempo',
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(width: 50),
                DropdownButton<String>(
                  value: value,
                  items: _items.map(buildMenuItem).toList(),
                  onChanged: dropdownCallback,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: 250,
              height: 125,
              decoration: const BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Valor total',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'R\$ ${_finalPrice.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headline4,
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Horários',
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 10),
            Text(
              'Seg a Qui ($hours1 - $hours2)\nSex a Dom ($hours1 - $hours3)',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Text(
              'Parceiros',
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 10),
            Text(
              "$partners\n$partners1\n$partners2",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Text(
              'Regras',
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 10),
            Text(
              rules,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentPage(_finalPrice, _hoursP, widget.title, _price)),
                );
              },
              child: const Text('Realizar Pagamento'),
            )

          ],
        ),
      ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
    value: item,
    child: Text(
      item,
      style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 20, color: Colors.grey),
    ),
  );

}
