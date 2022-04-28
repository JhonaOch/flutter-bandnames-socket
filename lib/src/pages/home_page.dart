import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avanzado1_bandnameapp/src/models/band.dart';
import 'package:flutter_avanzado1_bandnameapp/src/services/socket_service.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    // Band(id: '1', name: 'Metallica', votes: 10),
    // Band(id: '2', name: 'Slayer', votes: 10),
    // Band(id: '3', name: 'Basca', votes: 10),
    // Band(id: '4', name: 'Dragon Force', votes: 10),
  ];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('active-bands', (_handleActiveBands));
    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    print(payload);

    bands = (payload as List).map((band) => Band.fromJson(band)).toList();

    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'BandNames',
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 10),
              child: (socketService.serverStatus == ServerStatus.Online)
                  ? const Icon(Icons.check_circle, color: Colors.blue)
                  : const Icon(
                      Icons.offline_bolt,
                      color: Color.fromARGB(255, 255, 17, 0),
                    )),
        ],
      ),
      body:Column(
        children: [
         
         _showGrap(),
          Expanded(
            child: ListView.builder(
            itemCount: bands.length,
            itemBuilder: (context, index) => bandTile(bands[index])),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add), elevation: 1, onPressed: addNewBand),
    );
  }

  Widget bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      key: Key(band.id as String),
      direction: DismissDirection.startToEnd,
      //TODO: DELETE
      onDismissed: (_) =>
          socketService.socket.emit('delete-band', {'id': band.id}),
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.only(left: 8.0),
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              'Delete band',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name!.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),

        title: Text(
          band.name as String,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20)),
        //TODO: VOTACION
        onTap: () => socketService.socket.emit('vote-band', {'id': band.id}),
      ),
    );
  }

  addNewBand() {
    final textController = TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('New band name'),
              content: TextField(
                controller: textController,
                autofocus: true,
                onChanged: (value) {
                  // this.bandName = value;
                },
              ),
              actions: <Widget>[
                MaterialButton(
                  child: const Text('Cancel'),
                  elevation: 5,
                  textColor: Colors.blue,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                MaterialButton(
                  child: const Text('Save'),
                  elevation: 5,
                  textColor: Colors.blue,
                  onPressed: () => addBanToList(textController.text),
                )
              ],
            );
          });
    }
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('New band name'),
            content: CupertinoTextField(
              controller: textController,
              autofocus: true,
              onChanged: (value) {
                // this.bandName = value;
              },
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('Cancel'),
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: const Text('Save'),
                isDefaultAction: true,
                onPressed: () => addBanToList(textController.text),
              )
            ],
          );
        });
  }

  void addBanToList(String name) {
    if (name.length > 1) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.emit('add-band', {'name': name});
    }

    Navigator.pop(context);
  }


  Widget _showGrap() {
    Map<String, double> dataMap = Map();
    bands.forEach((band) {
      dataMap.putIfAbsent(band.name.toString(), () => band.votes!.toDouble());
    });

    final colorList =[
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.yellow,
      Colors.purple,
      Colors.pink,
      Colors.orange,
      Colors.brown,
      Colors.grey,
      Colors.black,
      Colors.teal,
      Colors.indigo,
      Colors.cyan,
      Colors.lime,
      Colors.limeAccent,
      Colors.lightGreen,
      Colors.lightBlue,
      Colors.lightGreenAccent,
      Colors.lightBlueAccent,
      Colors.deepOrange,
      Colors.deepOrangeAccent,
      Colors.deepPurple,
      Colors.deepPurpleAccent,
      Colors.indigoAccent,
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.redAccent,
      Colors.yellowAccent,
      Colors.pinkAccent,
      Colors.orangeAccent,
    
    ];

    return Container(
      width: double.infinity,
      height: 200,
      child: PieChart(
        dataMap: dataMap,
      animationDuration: Duration(milliseconds: 800),
      //chartLegendSpacing: 32,
     chartRadius: MediaQuery.of(context).size.width / 3.2,
      colorList: colorList,
      //initialAngleInDegree: 0,
      chartType: ChartType.ring,
      //ringStrokeWidth: 32,
     centerText: "Bandas",
     
      legendOptions: const LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: true,
       // legendShape: _BoxShape.circle,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions:  const ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: true,
        showChartValuesOutside: false,
        decimalPlaces: 0,
      ),
      ));
  }
}
