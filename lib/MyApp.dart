import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'transaction.dart';

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _contentController = TextEditingController();
  final _amountController = TextEditingController();

  //define state
  Transaction _transaction = Transaction(content: '', amount: 0.0);
  List<Transaction> _transactions = List<Transaction>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "this is a statefulWidget",
      home: Scaffold(
          key: _scaffoldKey,
          body: SafeArea(
            minimum: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Content'),
                  controller: _contentController,
                  onChanged: (text) {
                    setState(() {
                      _transaction.content = text;
                    });
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Amount(Money)'),
                  controller: _amountController,
                  onChanged: (text) {
                    setState(() {
                      _transaction.amount = double.tryParse(text) ?? 0;
                    });
                  },
                ),
                Padding(padding: const EdgeInsets.symmetric(vertical: 12)),
                ButtonTheme(
                  height: 50,
                  child: FlatButton(
                    child: Text('Insert Transaction', style: const TextStyle(fontSize: 18),),
                    color: Colors.pinkAccent,
                    textColor: Colors.white,
                    onPressed: () {
                      // print('Content = $_content, money\'s amount = $_amount');
                      //Display to UI ?
                      //Now it must add the "transaction object" to a list of transaction(state)
                      setState(() {
                        _transactions.add(_transaction);
                        _transaction = Transaction(content: '', amount: 0.0);
                        _contentController.text = '';
                        _amountController.text = '';
                      });
                      //Now i want to display the list below
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                            'transaction list : ' + _transactions.toString()),
                        duration: Duration(seconds: 3),
                      ));
                    },
                  ),
                ),
                Column(
                  children:
                    _transactions.map((eachTransaction){
                      return ListTile(
                          leading: const Icon(Icons.access_alarm),
                          title: Text(eachTransaction.content),
                          subtitle: Text('Price: ${eachTransaction.amount}'),
                          onTap:(){
                            print('You clicked: ${eachTransaction.content}');
                          },
                      );
                    }).toList()
                )
              ],
            ),
          )),
    );
  }
}
