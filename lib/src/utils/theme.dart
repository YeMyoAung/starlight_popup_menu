part of starlight_popup_menu;

class StarlightPopupMenuTheme {
  StarlightPopupMenuTheme({
    this.indicatorColor = const Color(0xFF4C4C4C),
    this.showIndicator = true,
    this.barrierColor = Colors.black12,
    this.indicatorSize = 10.0,
    this.horizontalMargin = 10.0,
    this.verticalMargin = 10.0,
    this.position,
    this.enablePassEvent = true,
    this.customIndicator,
  });

  final bool showIndicator;
  final Color indicatorColor;
  final double indicatorSize;
  final Color barrierColor;
  final double horizontalMargin;
  final double verticalMargin;
  final StarlightPreferredPosition? position;
  final bool enablePassEvent;
  final CustomClipper<Path>? customIndicator;
}
