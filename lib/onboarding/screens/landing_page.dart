import 'package:flutter/material.dart';
import 'package:hackitba/helpers/DeepWidgets.dart';

import '../ui_view/slider_layout_view.dart';

class LandingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: onBordingBody(),
    );
  }

  Widget onBordingBody() => Container(
        color: DeepWidgets().bgColor,
        child: SliderLayoutView(),
      );
}
