import 'package:flutter/material.dart';
import 'package:lycle/src/ui/widgets/heroWidget.dart';

import '../../constants/ui.dart';

import '../../data/heroTag.dart';

import '../widgets/backgroundGradientAnimationWidget.dart';
import '../widgets/roundedImage.dart';

class NFTDetailPage extends StatelessWidget {
  final String imageUrl;
  final String nftTitle;
  final Animation<double> animation;

  const NFTDetailPage(
      {Key? key,
      required this.imageUrl,
      required this.nftTitle,
      required this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
            minimum: const EdgeInsets.all(kDefaultPadding),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                  child:
                      Align(alignment: Alignment.topLeft, child: BackButton())),
              Stack(children: [
                BackgroundGradientAnimationWidget(
                    beginColor: const Color(0xA0ffffff),
                    endColor: Colors.transparent,
                    beginAlignment: Alignment.bottomLeft,
                    endAlignment: Alignment.topRight,
                    duration: const Duration(milliseconds: 5000),
                    child: HeroWidget(
                        tag: HeroTag.image(imageUrl),
                        child: RoundedImage(
                            width: size.width - 32,
                            height: size.width - 32,
                            radius: kDefaultRadius,
                            imageProvider: NetworkImage(imageUrl)))),
                AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) => FadeTransition(
                          opacity: CurvedAnimation(
                              parent: animation,
                              curve:
                                  Interval(0.2, 1, curve: Curves.easeInExpo)),
                          child: child,
                        ),
                    child: Image.asset(
                      'assets/medal.png',
                      width: (size.width - 32) * 0.25,
                      height: (size.width - 32) * 0.25,
                    ))
              ]),
              SizedBox(
                height: kLargePadding,
              ),
              HeroWidget(
                  tag: HeroTag.text(nftTitle),
                  child: Text(
                    nftTitle,
                    style: TextStyle(fontSize: 32),
                  )),
              SizedBox(
                height: kLargePadding,
              ),
              Expanded(
                  child: AnimatedBuilder(
                animation: animation,
                builder: (context, child) => FadeTransition(
                  opacity: CurvedAnimation(
                      parent: animation,
                      curve: Interval(0.2, 1, curve: Curves.easeInExpo)),
                  child: child,
                ),
                child: Column(
                  children: [
                    Text("소유 날짜 : 2022/07/30 12:34"),
                    Text("이 부분은 추후 업데이트 될 예정입니다.")
                  ],
                ),
              ))
            ])));
  }
}
