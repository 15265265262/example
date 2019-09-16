import 'package:flutter_web/material.dart';

class ExpandSearch extends StatefulWidget {
  final TextStyle style;
  final Widget child;
  final Icon icon;
  final double width;
  final List<String> list;
  final Function(String) callback;
  final double fixedH;
  ExpandSearch(
      {Key key,
      this.child,
      this.style,
      this.icon,
      this.list,
      this.width,
      this.fixedH,
      this.callback})
      : super(key: key);

  @override
  createState() => ExpandSearchState();
}

class ExpandSearchState extends State<ExpandSearch>
    with TickerProviderStateMixin {
  bool _isExpand = false, _isTouch = false;
  TextEditingController _controller;
  OverlayEntry _overlayEntry;
  Animation<double> _animation;
  AnimationController _animationController;
  FocusNode _focusNode = FocusNode();
  final TextStyle style = TextStyle(color: Colors.grey, fontSize: 16.0);
  

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode.addListener(_onFocus);
    _animationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    CurvedAnimation curve = CurvedAnimation(
        parent: _animationController, curve: Curves.fastLinearToSlowEaseIn);
    _animation = Tween(begin: 0.0, end: widget.width).animate(curve)
      ..addListener(() {
        if (_animation.value != 52.0) setState(() {});
        if (_animation.isCompleted && _focusNode.hasFocus) {
          _popup(
            context,
       widget.list);
        }
      });
    _controller.addListener(_onQueryChanged);
  }

  void _onFocus() {
    if (_animation.isCompleted && _focusNode.hasFocus) {
      _popup(
        context,
        widget.list,
      );
    }
  }

  void _onQueryChanged() {
    setState(() {
    });
  }

  String get value => _controller.value.text.trim();

  @override
  Widget build(BuildContext context) {
    var textStyle = widget.style == null ? style : widget.style;
    final String searchFieldLabel =
        MaterialLocalizations.of(context).searchFieldLabel;
    String routeName;
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        routeName = '';
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        routeName = searchFieldLabel;
    }
    return Listener(
        onPointerHover: (event) {
          _isExpand = true;
          _animationController.forward();
        },
        onPointerExit: (event) {
          if (!_isTouch && _animation.isCompleted) removeList();
        },
        child: Semantics(
            explicitChildNodes: true,
            scopesRoute: true,
            namesRoute: true,
            label: routeName,
            child: _edText(textStyle)));
  }

  _edText(TextStyle textStyle) => Container(
      width: _animation.value > 52.0 ? _animation.value : 52.0,
      height: 50.0,
      padding: EdgeInsets.only(
          left: _isExpand ? 8.0 : 10.0, right: _isExpand ? 15.0 : 10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6), color: Color(0xF2F2F2F2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
              child: Offstage(
                  offstage: !_isExpand,
                  child: Padding(
                      padding: EdgeInsets.only(left: 2.0, right: 2.0),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        inputFormatters: [LengthLimitingTextInputFormatter(50)],
                        maxLines: 1,
                        style: textStyle,
                        cursorColor: Colors.grey,
                        cursorWidth: 2.0,
                        obscureText: false,
                        cursorRadius: Radius.circular(5.0),
                        onChanged: (value) {
                          if (value.trim().length == 0) {
                            if (_overlayEntry != null) {
                              _overlayEntry.remove();
                              _overlayEntry = null;
                            }
                          } else
                            _popup(
                              context,
                              [value],
                            );
                        },
                        decoration: InputDecoration(
                          counterText: '',
                          errorStyle: textStyle,
                          hintStyle: textStyle,
                          fillColor: Colors.grey,
                          focusColor: Colors.grey,
                          hoverColor: Colors.grey,
                          border: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        textInputAction: TextInputAction.search,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        textCapitalization: TextCapitalization.sentences,
                        maxLengthEnforced: false,
                      )))),
          GestureDetector(
              onTap: () {},
              child: Icon(
                IconData(0xf017c, fontFamily: 'Happy'),
                size: 28,
                color: _isExpand ? Colors.green : Colors.grey,
              )),
        ],
      ));

  _item(int index, String value) => BgPressed(
      onClick: () {
        widget.callback(value);
        removeList();
      },
      child: Container(
          alignment: Alignment.center,
          height: 40.0,
          child: Text(
            value,
            style: TextStyle(color: Colors.grey, fontSize: 12.0),
            softWrap: true,
            textAlign: TextAlign.center,
            maxLines: 2,
          )));

  _popup(BuildContext context, List<String> list) {
    if (_overlayEntry != null) {
      _overlayEntry.remove();
      _overlayEntry = null;
    }
    final RenderBox button = context.findRenderObject();
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    double dx = button.size.bottomRight(Offset.zero).dx;
    double dy = 0;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset(Offset.zero.dx, dy), ancestor: overlay),
        button.localToGlobal(Offset(dx, dy), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    OverlayState _overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
              top: position.top,
              left: position.left,
              width: 200,
              child: Listener(
                  onPointerHover: (event) {
                    _isTouch = true;
                  },
                  onPointerExit: (event) {
                    _isTouch = false;
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                        padding: EdgeInsets.only(top: 54.0),
                        child: Container(
                          padding: EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                            color: Color(0xF2F2F2F2),
                            border: Border.all(width: 0.5, color: Colors.grey),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5.0,
                                  spreadRadius: 1.0,
                                  offset: Offset(0.6, 1.2)),
                            ],
                          ),
                          constraints: BoxConstraints(
                              maxWidth: widget.width, maxHeight:  widget.fixedH == 0 ? list.length*40.0 : widget.fixedH ),
                          child: Material(
                              child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Expanded(
                                  child: ListView.separated(
                                itemCount: list.length,
                                itemBuilder: (c, index) =>
                                    _item(index, list[index]),
                                separatorBuilder: (context, index) => Divider(
                                  height: 1.0,
                                  color: const Color(0xF2F2F2F2),
                                ),
                              ))
                            ],
                          )),
                        )),
                  )),
            ));

    _overlayState.insert(_overlayEntry);
  }

  removeList() {
    if (_overlayEntry != null) {
      _overlayEntry.remove();
      _overlayEntry = null;
    }
    _focusNode.unfocus();
    _animationController.reverse();
    _isExpand = false;
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _animationController = null;
    _controller?.removeListener(_onQueryChanged);
    _controller?.dispose();
    _controller = null;
    _focusNode?.removeListener(_onFocus);
    _focusNode?.dispose();
    _focusNode = null;
    _overlayEntry = null;
    super.dispose();
  }
}

class BgPressed extends StatefulWidget {
  final Widget child;
  final Function onClick;

  BgPressed({Key key, this.child, this.onClick}) : super(key: key);

  createState() => BgPressedState();
}

class BgPressedState extends State<BgPressed> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: widget.onClick,
        child: widget.child,
      ),
    );
  }
}
