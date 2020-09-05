import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const int _windowPopupDuration = 300;
const double _kWindowCloseIntervalEnd = 2.0 / 3.0;
const Duration _kWindowDuration = Duration(milliseconds: _windowPopupDuration);

typedef AnimatedWidgetBuilder = Widget Function(Widget child,
    Animation<double> animation, Animation<double> secondaryAnimation);

class PopupWindowButton<T> extends StatefulWidget {
  const PopupWindowButton(
      {Key key,
      this.child,
      this.buttonBuilder,
      this.window,
      this.offset = Offset.zero,
      this.elevation = 2.0,
      this.duration = 300,
      this.type = MaterialType.card,
      this.windowBuilder,
      this.onWindowShow,
      this.onWindowDismiss})
      : super(key: key);

  /// 显示按钮button
  /// button which clicked will popup a window, use instead of buttonBuilder
  /// next version remove child;
  @deprecated
  final Widget child;

  /// the builder for child,
  final WidgetBuilder buttonBuilder;

  /// window 出现的位置。
  /// window's position in screen
  final Offset offset;

  /// 阴影
  /// shadow
  final double elevation;

  /// 需要显示的window
  /// the target window, use instead of windowBuilder
  /// next version remove window;
  @deprecated
  final Widget window;

  /// 按钮按钮后到显示window 出现的时间
  /// the transition duration before [window] show up
  final int duration;

  final MaterialType type;

  final AnimatedWidgetBuilder windowBuilder;

  final VoidCallback onWindowShow;

  final VoidCallback onWindowDismiss;

  @override
  _PopupWindowButtonState createState() {
    return _PopupWindowButtonState();
  }

  static _PopupWindowButtonState of(BuildContext context) {
    final _PopupWindowScope scope =
        context.inheritFromWidgetOfExactType(_PopupWindowScope);
    return scope?.state;
  }
}

void showWindow<T>(
    {@required BuildContext context,
    RelativeRect position,
    @required Widget window,
    double elevation = 8.0,
    int duration = _windowPopupDuration,
    String semanticLabel,
    MaterialType type,
    AnimatedWidgetBuilder windowBuilder,
    VoidCallback onWindowShow,
    VoidCallback onWindowDismiss}) {
  Navigator.push(
    context,
    _PopupWindowRoute<T>(
        position: position,
        child: window,
        elevation: elevation,
        duration: duration,
        semanticLabel: semanticLabel,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        type: type,
        windowBuilder: windowBuilder,
        onWindowShow: onWindowShow,
        onWindowDismiss: onWindowDismiss),
  );
}

class _PopupWindowButtonState<T> extends State<PopupWindowButton> {
  void showPopupWindow() {
    final RenderBox button = context.findRenderObject();
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(widget.offset, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showWindow<T>(
        context: context,
        window: widget.window,
        position: position,
        duration: widget.duration,
        elevation: widget.elevation,
        type: widget.type,
        windowBuilder: widget.windowBuilder,
        onWindowShow: widget.onWindowShow,
        onWindowDismiss: widget.onWindowDismiss);
  }

  @override
  Widget build(BuildContext context) {
    return _PopupWindowScope(
        state: this,
        child: InkWell(
          onTap: showPopupWindow,
          child: widget.buttonBuilder?.call(context) ?? widget.child,
        ));
  }
}

class _PopupWindowRoute<T> extends PopupRoute<T> {
  _PopupWindowRoute(
      {this.position,
      this.child,
      this.elevation,
      this.theme,
      this.barrierLabel,
      this.semanticLabel,
      this.duration,
      this.type = MaterialType.card,
      this.windowBuilder,
      this.onWindowShow,
      this.onWindowDismiss});

  @override
  Animation<double> createAnimation() {
    return CurvedAnimation(
        parent: super.createAnimation(),
        curve: Curves.linear,
        reverseCurve: const Interval(0.0, _kWindowCloseIntervalEnd));
  }

  final RelativeRect position;
  final Widget child;
  final double elevation;
  final ThemeData theme;
  final String semanticLabel;
  @override
  final String barrierLabel;
  final int duration;
  final MaterialType type;
  final AnimatedWidgetBuilder windowBuilder;
  final VoidCallback onWindowShow;
  final VoidCallback onWindowDismiss;

  @override
  Duration get transitionDuration =>
      duration == 0 ? _kWindowDuration : Duration(milliseconds: duration);

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => null;

  @override
  bool didPop(T result) {
    onWindowDismiss?.call();
    return super.didPop(result);
  }

  @override
  TickerFuture didPush() {
    onWindowShow?.call();
    return super.didPush();
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Builder(
      builder: (BuildContext context) {
        return CustomSingleChildLayout(
          delegate: _PopupWindowLayout(position),
          child: AnimatedBuilder(
              child: child,
              animation: animation,
              builder: (BuildContext context, Widget child) {
                return windowBuilder == null
                    ? FadeTransition(
                        opacity: animation,
                        child: Material(
                          type: type,
                          elevation: elevation,
                          child: child,
                        ),
                      )
                    : windowBuilder(child, animation, secondaryAnimation);
              }),
        );
      },
    );
  }
}

class _PopupWindowLayout extends SingleChildLayoutDelegate {
  _PopupWindowLayout(this.position);

  // Rectangle of underlying button, relative to the overlay's dimensions.
  final RelativeRect position;

  // We put the child wherever position specifies, so long as it will fit within
  // the specified parent size padded (inset) by 8. If necessary, we adjust the
  // child's position so that it fits.

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus 8.0 pixels in each
    // direction.
    return BoxConstraints.loose(constraints.biggest);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // size: The size of the overlay.
    // childSize: The size of the menu, when fully open, as determined by
    // getConstraintsForChild.

    // Find the ideal vertical position.
    double y = position.top;

    // Find the ideal horizontal position.
    double x;
    if (position.left > position.right) {
      // Menu button is closer to the right edge, so grow to the left, aligned to the right edge.
      x = size.width - position.right - childSize.width;
    } else if (position.left < position.right) {
      // Menu button is closer to the left edge, so grow to the right, aligned to the left edge.
      x = position.left;
    }
    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_PopupWindowLayout oldDelegate) {
    return position != oldDelegate.position;
  }
}

class _PopupWindowScope extends InheritedWidget {
  const _PopupWindowScope({Key key, this.state, Widget child})
      : super(key: key, child: child);

  final _PopupWindowButtonState state;

  @override
  bool updateShouldNotify(_PopupWindowScope oldWidget) {
    return state != oldWidget.state;
  }
}
