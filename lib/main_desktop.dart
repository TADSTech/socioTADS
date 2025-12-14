import 'package:flutter/cupertino.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

/// Initialize desktop window with bitsdojo_window
void initializeWindow() {
  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(1100, 750);
    win.minSize = const Size(800, 600);
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "SocioTADS";
    win.show();
  });
}
