part of starlight_popup_menu;

class _StarlightMenuLayoutDelegate extends MultiChildLayoutDelegate {
  _StarlightMenuLayoutDelegate({
    required this.anchorSize,
    required this.anchorOffset,
    required this.verticalMargin,
    this.position,
  });

  final Size anchorSize;
  final Offset anchorOffset;
  final double verticalMargin;
  final StarlightPreferredPosition? position;

  @override
  void performLayout(Size size) {
    Size contentSize = Size.zero;
    Size arrowSize = Size.zero;
    Offset contentOffset = Offset(0, 0);
    Offset arrowOffset = Offset(0, 0);

    double anchorCenterX = anchorOffset.dx + anchorSize.width / 2;
    double anchorTopY = anchorOffset.dy;
    double anchorBottomY = anchorTopY + anchorSize.height;
    _StarlightMenuPosition menuPosition = _StarlightMenuPosition.bottomCenter;

    if (hasChild(_StarlightMenuLayoutId.content)) {
      contentSize = layoutChild(
        _StarlightMenuLayoutId.content,
        BoxConstraints.loose(size),
      );
    }
    if (hasChild(_StarlightMenuLayoutId.arrow)) {
      arrowSize = layoutChild(
        _StarlightMenuLayoutId.arrow,
        BoxConstraints.loose(size),
      );
    }
    if (hasChild(_StarlightMenuLayoutId.downArrow)) {
      layoutChild(
        _StarlightMenuLayoutId.downArrow,
        BoxConstraints.loose(size),
      );
    }

    bool isTop = false;
    if (position == null) {
      isTop = anchorBottomY > size.height / 2;
    } else {
      isTop = position == StarlightPreferredPosition.top;
    }
    if (anchorCenterX - contentSize.width / 2 < 0) {
      menuPosition = isTop
          ? _StarlightMenuPosition.topLeft
          : _StarlightMenuPosition.bottomLeft;
    } else if (anchorCenterX + contentSize.width / 2 > size.width) {
      menuPosition = isTop
          ? _StarlightMenuPosition.topRight
          : _StarlightMenuPosition.bottomRight;
    } else {
      menuPosition = isTop
          ? _StarlightMenuPosition.topCenter
          : _StarlightMenuPosition.bottomCenter;
    }

    switch (menuPosition) {
      case _StarlightMenuPosition.bottomCenter:
        arrowOffset = Offset(
          anchorCenterX - arrowSize.width / 2,
          anchorBottomY + verticalMargin,
        );
        contentOffset = Offset(
          anchorCenterX - contentSize.width / 2,
          anchorBottomY + verticalMargin + arrowSize.height,
        );
        break;
      case _StarlightMenuPosition.bottomLeft:
        arrowOffset = Offset(anchorCenterX - arrowSize.width / 2,
            anchorBottomY + verticalMargin);
        contentOffset = Offset(
          0,
          anchorBottomY + verticalMargin + arrowSize.height,
        );
        break;
      case _StarlightMenuPosition.bottomRight:
        arrowOffset = Offset(anchorCenterX - arrowSize.width / 2,
            anchorBottomY + verticalMargin);
        contentOffset = Offset(
          size.width - contentSize.width,
          anchorBottomY + verticalMargin + arrowSize.height,
        );
        break;
      case _StarlightMenuPosition.topCenter:
        arrowOffset = Offset(
          anchorCenterX - arrowSize.width / 2,
          anchorTopY - verticalMargin - arrowSize.height,
        );
        contentOffset = Offset(
          anchorCenterX - contentSize.width / 2,
          anchorTopY - verticalMargin - arrowSize.height - contentSize.height,
        );
        break;
      case _StarlightMenuPosition.topLeft:
        arrowOffset = Offset(
          anchorCenterX - arrowSize.width / 2,
          anchorTopY - verticalMargin - arrowSize.height,
        );
        contentOffset = Offset(
          0,
          anchorTopY - verticalMargin - arrowSize.height - contentSize.height,
        );
        break;
      case _StarlightMenuPosition.topRight:
        arrowOffset = Offset(
          anchorCenterX - arrowSize.width / 2,
          anchorTopY - verticalMargin - arrowSize.height,
        );
        contentOffset = Offset(
          size.width - contentSize.width,
          anchorTopY - verticalMargin - arrowSize.height - contentSize.height,
        );
        break;
    }
    if (hasChild(_StarlightMenuLayoutId.content)) {
      positionChild(_StarlightMenuLayoutId.content, contentOffset);
    }

    _menuRect = Rect.fromLTWH(
      contentOffset.dx,
      contentOffset.dy,
      contentSize.width,
      contentSize.height,
    );
    bool isBottom = false;
    if (_StarlightMenuPosition.values.indexOf(menuPosition) < 3) {
      isBottom = true;
    }
    if (hasChild(_StarlightMenuLayoutId.arrow)) {
      positionChild(
        _StarlightMenuLayoutId.arrow,
        isBottom
            ? Offset(arrowOffset.dx, arrowOffset.dy + 0.1)
            : Offset(-100, 0),
      );
    }
    if (hasChild(_StarlightMenuLayoutId.downArrow)) {
      positionChild(
        _StarlightMenuLayoutId.downArrow,
        !isBottom
            ? Offset(arrowOffset.dx, arrowOffset.dy - 0.1)
            : Offset(-100, 0),
      );
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) => false;
}
