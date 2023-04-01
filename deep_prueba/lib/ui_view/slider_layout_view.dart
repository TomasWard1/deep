/* 
En este archivo está el widget que se encarga de mostrar el slider
*/
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:deep_prueba/constants/constants.dart';
import 'package:deep_prueba/model/slider.dart';
import 'package:deep_prueba/widgets/slide_dots.dart';
import 'package:deep_prueba/widgets/slide_items/slide_item.dart';

class SliderLayoutView extends StatefulWidget {
  const SliderLayoutView({super.key});
  // Acá defino el widget que se encarga de mostrar el slider
  @override
  State<StatefulWidget> createState() => _SliderLayoutViewState();
}

class _SliderLayoutViewState extends State<SliderLayoutView> {
  int _currentPage =
      0; // Acá defino la variable que se encarga de saber en que slide estamos
  final PageController _pageController = PageController(initialPage: 0);

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
              alignment: AlignmentDirectional.bottomCenter,
              children: <Widget>[
                PageView.builder(
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
                            if (i == _currentPage)
                              SlideDots(true)
                            else
                              SlideDots(false)
                        ],
                      ),
                    ),
                  ],
                )
              ],
            )),
      );
}