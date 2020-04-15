# popup_window

<img src="example/screenshot/20190316_160029.gif"  height="400" alt="Screenshot"/> 

A library to display a view like window in android native.
## Getting Started


```
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
            ) ,
        ),
     )
```

More detail see example: main.dart
