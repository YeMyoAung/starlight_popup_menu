part of starlight_popup_menu;

abstract class StarlightPopupMenuBase extends StatefulWidget {
  const StarlightPopupMenuBase({
    Key? key,
  }) : super(key: key);

  Widget builder(BuildContext context, StarlightPopupMenuController controller);
  Widget menu(BuildContext context, StarlightPopupMenuController controller);
  StarlightPressType pressType() => StarlightPressType.onTap;
  StarlightPopupMenuTheme style() => StarlightPopupMenuTheme();
  StarlightPopupMenuTheme get _style => style();
  void onChange(bool value) {}
  @override
  _StarlightPopupMenuBaseState createState() => _StarlightPopupMenuBaseState();
}

class _StarlightPopupMenuBaseState extends State<StarlightPopupMenuBase> {
  final StarlightPopupMenuController _controller =
      StarlightPopupMenuController();

  late final Widget _indicator = ClipPath(
    child: Container(
      width: widget._style.indicatorSize,
      height: widget._style.indicatorSize,
      color: widget._style.indicatorColor,
    ),
    clipper: widget._style.customIndicator ?? _ArrowClipper(),
  );

  RenderBox? _childBox;
  RenderBox? _parentBox;
  OverlayEntry? _overlayEntry;
  bool _canResponse = true;

  _showMenu() {
    _overlayEntry = OverlayEntry(
      builder: (_) {
        final Widget menu = Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth:
                  _parentBox!.size.width - 2 * widget._style.horizontalMargin,
              minWidth: 0,
            ),
            child: CustomMultiChildLayout(
              delegate: _StarlightMenuLayoutDelegate(
                anchorSize: _childBox!.size,
                anchorOffset: _childBox!.localToGlobal(
                  Offset(
                    -widget._style.horizontalMargin,
                    0,
                  ),
                ),
                verticalMargin: widget._style.verticalMargin,
                position: widget._style.position,
              ),
              children: [
                if (widget._style.showIndicator)
                  LayoutId(
                    id: _StarlightMenuLayoutId.arrow,
                    child: _indicator,
                  ),
                if (widget._style.showIndicator)
                  LayoutId(
                    id: _StarlightMenuLayoutId.downArrow,
                    child: Transform.rotate(
                      angle: math.pi,
                      child: _indicator,
                    ),
                  ),
                LayoutId(
                  id: _StarlightMenuLayoutId.content,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Material(
                        child: widget.menu(context, _controller),
                        color: Colors.transparent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
        return Listener(
          behavior: widget._style.enablePassEvent
              ? HitTestBehavior.translucent
              : HitTestBehavior.opaque,
          onPointerDown: (PointerDownEvent event) {
            final Offset offset = event.localPosition;
            if (_menuRect.contains(
              Offset(
                offset.dx - widget._style.horizontalMargin,
                offset.dy,
              ),
            )) {
              return;
            }
            _controller.hideMenu();

            _canResponse = false;
            Future.delayed(Duration(milliseconds: 300))
                .then((_) => _canResponse = true);
          },
          child: widget._style.barrierColor == Colors.transparent
              ? menu
              : Container(
                  color: widget._style.barrierColor,
                  child: menu,
                ),
        );
      },
    );
    if (_overlayEntry != null) {
      Overlay.of(context)!.insert(_overlayEntry!);
    }
  }

  bool _hideMenu() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
    return true;
  }

  _listener() {
    widget.onChange(_controller.menuIsShowing);
    if (_controller.menuIsShowing)
      _showMenu();
    else
      _hideMenu();
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_listener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _childBox = context.findRenderObject() as RenderBox?;
      _parentBox =
          Overlay.of(context)?.context.findRenderObject() as RenderBox?;
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _hideMenu();
    _controller.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget child = Material(
      child: InkWell(
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: widget.builder(context, _controller),
        onTap: () {
          if (widget.pressType() == StarlightPressType.onTap && _canResponse) {
            _controller.showMenu();
          }
        },
        onLongPress: () {
          if (widget.pressType() == StarlightPressType.longPress &&
              _canResponse) {
            _controller.showMenu();
          }
        },
      ),
      color: Colors.transparent,
    );

    if (Platform.isIOS) {
      return child;
    } else {
      return WillPopScope(
        onWillPop: () async => _hideMenu(),
        child: child,
      );
    }
  }
}
