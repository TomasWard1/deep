/* 
En este archivo está el widget que se encarga de mostrar el slider
*/
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/SpacesController.dart';
import '../../helpers/DeepWidgets.dart';
import '../../helpers/Functions.dart';
import '../model/slider.dart';
import '../widgets/slide_dots.dart';
import '../widgets/slide_items/slide_item.dart';

class SliderLayoutView extends StatefulWidget {
  const SliderLayoutView({super.key});

  // Acá defino el widget que se encarga de mostrar el slider
  @override
  State<StatefulWidget> createState() => _SliderLayoutViewState();
}

class _SliderLayoutViewState extends State<SliderLayoutView> {
  int _currentPage = 0; // Acá defino la variable que se encarga de saber en que slide estamos
  final PageController _pageController = PageController(initialPage: 0);
  final DeepWidgets dw = DeepWidgets();

  SpacesController get sc => Get.find<SpacesController>();

  @override
  void initState() {
    // Acá defino el método que se encarga de cambiar de slide cada 8 segundos
    super.initState();
    Timer.periodic(const Duration(seconds: 8), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
    });
  }

  @override
  void dispose() {
    // Acá defino el método que se encarga de cerrar el slider
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    // Acá defino el método que se encarga de cambiar de slide
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) => topSliderLayout();

  Widget topSliderLayout() => Container(
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Row(
                    children: [
                      const Spacer(),
                      Image.asset(
                        'assets/deepLogo.jpg',
                        width: 60,
                        height: 60,
                      ),
                      const Spacer()
                    ],
                  ),
                ),
                PageView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: sliderArrayList.length,
                  itemBuilder: (ctx, i) => SlideItem(i),
                ),
                Stack(
                  alignment: AlignmentDirectional.topStart,
                  children: <Widget>[
                    const Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 15.0, bottom: 15.0),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.0, bottom: 15.0),
                      ),
                    ),
                    Container(
                      alignment: AlignmentDirectional.bottomCenter,
                      margin: const EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          for (int i = 0; i < sliderArrayList.length; i++)
                            if (i == _currentPage) SlideDots(true) else SlideDots(false)
                        ],
                      ),
                    ),
                    if (_currentPage == 2)
                      Container(
                          alignment: AlignmentDirectional.bottomCenter,
                          margin: const EdgeInsets.only(bottom: 20),
                          width: double.infinity,
                          child: dw.actionButton('Conectar Wallet', Icons.wallet, () async {
                            Functions().loginWithMetamask(false);
                          }))
                  ],
                )
              ],
            )),
      );
}
