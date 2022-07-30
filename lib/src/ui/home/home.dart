import 'package:flutter/material.dart';

import 'package:card_swiper/card_swiper.dart';

import 'package:lycle/src/constants/ui.dart';

import '../widgets/backgroundGradientAnimationWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<String> _imageUrl = [
    "http://wiki.hash.kr/images/2/25/BAYC_1.png",
    "http://wiki.hash.kr/images/f/ff/BAYC_2.png",
    "http://wiki.hash.kr/images/4/4e/BAYC_3.png",
    "http://wiki.hash.kr/images/7/76/BAYC_4.png",
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Color(0xFFEEEEEE),
        body: SafeArea(
            minimum: EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: kDefaultPadding),
                    child: Text(
                      "장성호님, 안녕하세요",
                      style: TextStyle(fontSize: (size.width - 32) * 0.1),
                    )),
                Expanded(
                    child: Swiper(
                  onIndexChanged: (index) => _currentIndex = index,
                  fade: 0.25,
                  itemCount: _imageUrl.length,
                  scrollDirection: Axis.horizontal,
                  viewportFraction: 0.7,
                  scale: 0.75,
                  itemBuilder: (context, index) {
                    bool isCurrentPage = _currentIndex == index;
                    return Container(
                        margin: const EdgeInsets.all(kDefaultPadding),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                              Radius.circular(kDefaultRadius)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.7),
                              spreadRadius: 0,
                              blurRadius: 5.0,
                              offset: const Offset(
                                  5, 5), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(children: [
                                isCurrentPage
                                    ? BackgroundGradientAnimationWidget(
                                        beginColor: const Color(0xA0ffffff),
                                        endColor: Colors.transparent,
                                        beginAlignment: Alignment.bottomLeft,
                                        endAlignment: Alignment.topRight,
                                        duration:
                                            const Duration(milliseconds: 5000),
                                        child: Container(
                                          width: (size.width - 32) * 0.5,
                                          height: (size.width - 32) * 0.5,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(
                                                          kDefaultRadius)),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      _imageUrl[index]))),
                                        ),
                                      )
                                    : Container(
                                        width: (size.width - 32) * 0.5,
                                        height: (size.width - 32) * 0.5,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(
                                                        kDefaultRadius)),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    _imageUrl[index]))),
                                      ),
                                Image.asset(
                                  'assets/medal.png',
                                  width: (size.width - 32) * 0.15,
                                  height: (size.width - 32) * 0.15,
                                )
                              ]),
                              SizedBox(
                                height: 32,
                              ),
                              Text(
                                "BAYC #156",
                                style: TextStyle(
                                    fontSize: (size.width - 32) * 0.1),
                              )
                            ]));
                  },
                )),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: kDefaultPadding),
                    child: Text(
                      "${_currentIndex + 1} / ${_imageUrl.length}",
                      style: TextStyle(fontSize: (size.width - 32) * 0.1),
                    )),
                Container(
                  height: 40,
                  color: Colors.white,
                  child: Text("추후 하단 바가 들어갑니다."),
                )
              ],
            )));
  }
}
