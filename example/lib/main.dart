import 'package:flutter/material.dart';
import 'package:popup_window/popup_window.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: <Widget>[
          PopupWindowButton(
            offset: Offset(0, 200),
            child: Image(image: AssetImage("images/ic_share.png")),
            window: Container(
              padding: EdgeInsets.all(50),
              alignment: Alignment.center,
              color: Colors.greenAccent,
              height: 200,
              child: Container(
                color: Colors.white,
                height: 50,
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: Text(
          'Popup Window Demo, click share icon',
        ),
      ),
    );
  }
}
