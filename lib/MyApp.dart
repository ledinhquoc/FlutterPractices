import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'transaction.dart';
import 'TrtansactionList.dart';

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

  void _insertTransaction() {
    if (_transaction.content.isEmpty ||
        _transaction.amount == 00 ||
        _transaction.amount.isNaN) {
      return;
    }
    _transaction.createDate = DateTime.now();
    _transactions.add(_transaction);
    _transaction = Transaction(content: '', amount: 0.0);
    _contentController.text = '';
    _amountController.text = '';
  }

  void _onButtonShowModalSheet() {
    showModalBottomSheet(
        context: this.context,
        builder: (context) {
          return Column(
            children: <Widget>[
              Container(padding: EdgeInsets.all(10),child:TextField(
                decoration: InputDecoration(labelText: 'Content'),
                controller: _contentController,
                onChanged: (text) {
                  setState(() {
                    _transaction.content = text;
                  });
                },
              ),),
              Container(padding: EdgeInsets.all(10),child:TextField(
                decoration: InputDecoration(labelText: 'Amount(Money)'),
                controller: _amountController,
                onChanged: (text) {
                  setState(() {
                    _transaction.amount = double.tryParse(text) ?? 0;
                  });
                },
              ),),
              //ok button
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        child: RaisedButton(
                          color: Colors.teal,
                          child: Text(
                            'Save',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          onPressed: () {
                            print('press Save');
                            setState(() {
                              this._insertTransaction();
                              Navigator.of(context).pop();
                            });
                          },
                        ),
                          height: 50,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: 10)),
                    Expanded(
                      child: SizedBox(
                        child: RaisedButton(
                          color: Colors.redAccent,
                          child: Text('Cancel',
                              style:
                              TextStyle(fontSize: 16, color: Colors.white)),
                          onPressed: () {
                            print('Pressed cancel');
                            Navigator.of(context).pop();
                          },
                        ),height: 50,
                      )
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // In this lession, we need to add AppBar and more "Add" button
    return Scaffold(
        appBar: AppBar(
          title: const Text('Transaction manager'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  // this._insertTransaction();
                  this._onButtonShowModalSheet();
                });
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add transaction',
          child: Icon(Icons.add),
          onPressed: () {
            this._onButtonShowModalSheet();
          },
          backgroundColor: Theme.of(context).primaryColor,
        ),
        key: _scaffoldKey,
        body: SafeArea(
            minimum: const EdgeInsets.only(left: 20, right: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(padding: const EdgeInsets.symmetric(vertical: 12)),
                  ButtonTheme(
                    height: 50,
                    child: FlatButton(
                      child: Text(
                        'Insert Transaction',
                        style: const TextStyle(fontSize: 25,fontFamily: 'Sacramento'),
                      ),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () {
                        // print('Content = $_content, money\'s amount = $_amount');
                        //Display to UI ?
                        //Now it must add the "transaction object" to a list of transaction(state)
                        this._onButtonShowModalSheet();
                      },
                    ),
                  ),
                  TransactionList(
                    transactions: _transactions,
                  )
                ],
              ),
            )));
  }
}
