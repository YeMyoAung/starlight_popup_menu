part of starlight_popup_menu;

class StarlightPopupMenuController extends ChangeNotifier {
  bool menuIsShowing = false;

  void showMenu() {
    if (menuIsShowing) return;
    menuIsShowing = true;
    notifyListeners();
  }

  void hideMenu() {
    if (!menuIsShowing) return;
    menuIsShowing = false;
    notifyListeners();
  }
}
