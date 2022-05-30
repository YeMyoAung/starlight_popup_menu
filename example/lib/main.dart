import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:starlight_popup_menu/starlight_popup_menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Default"),
            MenuVertical(
              state: State(),
            ),
            SizedBox(
              height: 20,
            ),
            Text("Custom"),
            MenuVertical(
              state: State(),
              customIndicator: StarClipper(),
            ),
          ],
        ),
      ),
    );
  }
}

class State {
  Stream<bool> get stream => _streamController.stream;

  final StreamController<bool> _streamController = StreamController.broadcast();

  void onChange(bool value) {
    _streamController.sink.add(value);
  }
}

class MenuVertical extends StarlightPopupMenuBase {
  final CustomClipper<Path>? customIndicator;
  final State state;
  const MenuVertical({Key? key, this.customIndicator, required this.state})
      : super(key: key);

  @override
  void onChange(bool value) {
    state.onChange(value);
    super.onChange(value);
  }

  @override
  StarlightPressType pressType() {
    return StarlightPressType.onTap;
  }

  @override
  StarlightPopupMenuTheme style() => StarlightPopupMenuTheme(
        position: StarlightPreferredPosition.bottom,
        horizontalMargin: 8,
        verticalMargin: 0,
        indicatorSize: 15,
        indicatorColor: Colors.white,
        customIndicator: customIndicator,
      );

  @override
  Widget builder(
      BuildContext context, StarlightPopupMenuController controller) {
    return StreamBuilder<bool>(
        initialData: false,
        stream: state.stream,
        builder: (_, snapshot) {
          return AnimatedIcon(
            icon: snapshot.data == true
                ? AnimatedIcons.menu_close
                : AnimatedIcons.arrow_menu,
            progress: kAlwaysCompleteAnimation,
          );
        });
  }

  @override
  Widget menu(BuildContext context, StarlightPopupMenuController controller) {
    return Container(
      width: 200,
      height: 120,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: controller.hideMenu,
            title: Row(
              children: const [
                Icon(Icons.settings),
                SizedBox(
                  width: 10,
                ),
                Text("Setting"),
              ],
            ),
          ),
          ListTile(
            onTap: controller.hideMenu,
            title: Row(
              children: const [
                Icon(Icons.help),
                SizedBox(
                  width: 10,
                ),
                Text("Help"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StarClipper extends CustomClipper<Path> {
  StarClipper();

  double _degreeToRadian(double deg) => deg * (pi / 180.0);

  @override
  Path getClip(Size size) {
    Path path = Path();
    double max = 2 * pi;

    double width = size.width;
    double halfWidth = width / 2;

    double wingRadius = halfWidth;
    double radius = halfWidth / 2;

    double degreesPerStep = _degreeToRadian(360 / 6);
    double halfDegreesPerStep = degreesPerStep / 2;

    path.moveTo(width, halfWidth);

    for (double step = 0; step < max; step += degreesPerStep) {
      path.lineTo(halfWidth + wingRadius * cos(step),
          halfWidth + wingRadius * sin(step));
      path.lineTo(halfWidth + radius * cos(step + halfDegreesPerStep),
          halfWidth + radius * sin(step + halfDegreesPerStep));
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
