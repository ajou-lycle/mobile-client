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
        body: Swiper(
          itemCount: _imageUrl.length,
          itemWidth: size.width * 0.75,
          itemHeight: size.width * 0.75,
          autoplay: true,
          scrollDirection: Axis.horizontal,
          layout: SwiperLayout.STACK,
          itemBuilder: (context, index) {
            return Image.network(_imageUrl[index]);
          },
        ));
  }
}