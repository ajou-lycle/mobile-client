import 'package:flutter/material.dart';

import 'package:card_swiper/card_swiper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _imageUrl = [
    "http://wiki.hash.kr/images/2/25/BAYC_1.png",
    "http://wiki.hash.kr/images/f/ff/BAYC_2.png",
    "http://wiki.hash.kr/images/4/4e/BAYC_3.png",
    "http://wiki.hash.kr/images/7/76/BAYC_4.png",
  ];

  final List<String> _imageUrlList = List<String>.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.grey,
        body: Center(
            child: SizedBox(
                height: size.height * 0.75,
                child: Swiper(
                  fade: 0.25,
                  itemCount: _imageUrl.length,
                  autoplay: true,
                  scrollDirection: Axis.horizontal,
                  viewportFraction: 0.7,
                  scale: 0.75,
                  itemBuilder: (context, index) {
                    return Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            boxShadow: [BoxShadow()]),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(children: [
                                Container(
                                  width: size.width * 0.5,
                                  height: size.width * 0.5,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(16)),
                                      image: DecorationImage(
                                          image:
                                              NetworkImage(_imageUrl[index]))),
                                ),
                                Image.asset(
                                  'assets/medal.png',
                                  width: size.width * 0.15,
                                  height: size.width * 0.15,
                                )
                              ]),
                              SizedBox(
                                height: 32,
                              ),
                              Text(
                                "BAYC #156",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 32),
                              ),
                            ]));
                  },
                ))));
  }
}
