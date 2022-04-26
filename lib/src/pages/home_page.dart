import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avanzado1_bandnameapp/src/models/band.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 10),
    Band(id: '2', name: 'Slayer', votes: 10),
    Band(id: '3', name: 'Basca', votes: 10),
    Band(id: '4', name: 'Dragon Force', votes: 10),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Center(
          child:  Text(
            'BandNames',
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (context, index) => bandTile(bands[index])),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add), elevation: 1, onPressed: addNewBand),
    );
  }

  Widget bandTile(Band band) {
    return Dismissible(
      key: Key(band.id as String),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction){
        print('direction: $direction');
        print('id: ${band.id}');
        //TODO agregar el metodo borrar del backend 
      },
      background: Container(
        color: Colors.red,
        padding:EdgeInsets.only(left: 8.0),

        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: const Text('Delete band',style: TextStyle(color: Colors.white),),
          ),
        ),
      ),
       child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name!.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        // ignore: prefer_const_constructors
        title: Text(
          band.name as String,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Text('${band.votes}', style: TextStyle(fontSize: 20)),
        onTap: () {
          print(band.name);
        },
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
      bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }

    Navigator.pop(context);
  }
}
