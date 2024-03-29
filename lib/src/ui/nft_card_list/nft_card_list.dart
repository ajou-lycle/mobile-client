import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:card_swiper/card_swiper.dart';

import 'package:lycle/src/constants/ui.dart';
import 'package:lycle/src/controller/nft_card.dart';
import 'package:lycle/src/ui/nft_detail/nft_card.dart';
import 'package:lycle/src/ui/widgets/rounded_image.dart';

import '../../data/hero_tag.dart';
import '../../routes/routes_enum.dart';
import '../widgets/background_gradient_animation_widget.dart';
import '../widgets/hero_widget.dart';

class NftCardListPage extends StatefulWidget {
  const NftCardListPage({Key? key}) : super(key: key);

  @override
  State<NftCardListPage> createState() => _NftCardListPageState();
}

class _NftCardListPageState extends State<NftCardListPage> {
  List<String> _imageUrl = [
    "https://i.ytimg.com/vi/0q1muV-hOEc/maxresdefault.jpg",
    "https://img.freepik.com/premium-vector/cute-llama-vector-icon-illustration-alpaca-mascot-cartoon-character_461200-167.jpg?w=1060",
    "https://img.freepik.com/premium-vector/cute-business-llama-icon-illustration-alpaca-mascot-cartoon-character-animal-icon-concept-isolated_138676-989.jpg?w=1060",
    "https://image.fnnews.com/resource/media/image/2021/09/24/202109240700515991_l.jpg",
  ];

  List<String> _nftTitle = [
    "LYCLE #1",
    "LYCLE #11",
    "LYCLE #111",
    "LYCLE #1111",
  ];

  NFTCardController nftCardIndexController = NFTCardIndexController(0);

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
                    // TODO: Swiper component 분리
                    child: Swiper(
                  onIndexChanged: (index) =>
                      nftCardIndexController.value = index,
                  fade: 0.25,
                  itemCount: _imageUrl.length,
                  scrollDirection: Axis.horizontal,
                  viewportFraction: 0.7,
                  scale: 0.75,
                  itemBuilder: (context, index) {
                    bool isCurrentPage = nftCardIndexController.value == index;
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
                                        child: InkWell(
                                            // TODO: Navigator function 분리
                                            onTap: () => Navigator.of(context).pushNamed(PageRoutes.nftDetail.routeName,
                                                arguments: NftDetailArguments(
                                                    imageUrl: _imageUrl[index],
                                                    nftTitle:
                                                        _nftTitle[index])),
                                            child: HeroWidget(
                                                tag: HeroTag.image(
                                                    _imageUrl[index]),
                                                child: RoundedImage(
                                                    width:
                                                        (size.width - 32) * 0.5,
                                                    height:
                                                        (size.width - 32) * 0.5,
                                                    radius: kDefaultRadius,
                                                    decorationImage: DecorationImage(
                                                        image: NetworkImage(
                                                            _imageUrl[index]),
                                                        fit: BoxFit.cover)))))
                                    : RoundedImage(
                                        width: (size.width - 32) * 0.5,
                                        height: (size.width - 32) * 0.5,
                                        radius: kDefaultRadius,
                                        decorationImage: DecorationImage(image: NetworkImage(_imageUrl[index]), fit: BoxFit.cover)),
                                Image.asset(
                                  'assets/medal.png',
                                  width: (size.width - 32) * 0.15,
                                  height: (size.width - 32) * 0.15,
                                )
                              ]),
                              SizedBox(
                                height: kLargePadding,
                              ),
                              HeroWidget(
                                  tag: HeroTag.text(_nftTitle[index]),
                                  child: Text(
                                    _nftTitle[index],
                                    style: TextStyle(
                                        fontSize: (size.width - 32) * 0.1),
                                  )),
                            ]));
                  },
                )),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: kDefaultPadding),
                    child: ValueListenableBuilder<dynamic>(
                      valueListenable: nftCardIndexController
                          .getController(nftCardIndexController),
                      builder:
                          (BuildContext context, dynamic value, Widget? child) {
                        return Text(
                          "${value + 1} / ${_imageUrl.length}",
                          style: TextStyle(fontSize: (size.width - 32) * 0.1),
                        );
                      },
                    )),
              ],
            )));
  }
}
