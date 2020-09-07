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

const double windowHeight = 200;

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
            offset: Offset(0, windowHeight),
            buttonBuilder: (BuildContext context) {
              return PopupWindowBtn();
            },
            windowBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  child: Container(
                    color: Colors.greenAccent,
                    height: windowHeight,
                  ),
                ),
              );
            },
            onWindowShow: () {
              print('PopupWindowButton window show');
            },
            onWindowDismiss: () {
              print('PopupWindowButton window dismiss');
            },
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

class PopupWindowBtn extends StatefulWidget {
  @override
  _PopupWindowBtnState createState() => _PopupWindowBtnState();
}

class _PopupWindowBtnState extends State<PopupWindowBtn> {
  bool _autoShowDialog = false;

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_autoShowDialog) {
        _autoShowDialog = false;
        PopupWindowButton.of(context).showPopupWindow();
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Image(image: AssetImage("images/ic_share.png"));
  }
}
