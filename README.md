# popup_window

<img src="screenshot/20190316_160029.gif"  height="400" alt="Screenshot"/> 

A library to display a view like window in android native.
## Getting Started

**1.Install**
```yaml
dependencies:
  popup_window: ^1.0.0+4
```

**2.Import**

```dart
import 'package:popup_window/popup_window.dart';
```

**3.Usage**
```
/// windowHeigh = 200;
PopupWindowButton(
  offset: Offset(0, windowHeight),
  child: Image(image: AssetImage("images/ic_share.png")),
  window: Container(
    color: Colors.greenAccent,
    height: windowHeight,
  ),
  /// not required.
  builder: (Widget child, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        child: child,
      ),
    );
  },
)
```

More detail see example: main.dart
